Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8BD46F2D7
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 19:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241898AbhLISUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 13:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237501AbhLISUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 13:20:30 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B12C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 10:16:57 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id r25so21810816edq.7
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 10:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zr8u1Hr2IPz7syKJ3+BkiFaA4qAaCiYgwZw/iarb7Jc=;
        b=cfrG6/6uDN5qOewwriQzXyVh+Te22mGey76OEGayOyiMdB/O69YoHPQgS7lp0Kv0ED
         miKEd0YQauHICq5wwDocZb1KE6QGZi6JioaDS8r6LtjtkI204jdUB+OMRBXLvkcqcNDO
         lweuus3CJER1/qEQN+Vbxu+GGL0E/12cBqdI8SdUQsceTW0cn0BJ6ZJbg3UyL5M9vY1d
         aYowP39TtXcjLU5jBkjkIPtjTCCn0qj8YRScV++w77+XzXmWAPrmPH8BSqRqVEozRsz4
         9JPNQo1kwWG0kpPSe3RFF3wy0HYgcWnMObb09Qp5gLnCL8vEIVzlDB3Dv5DcWXqpWAVT
         nvmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zr8u1Hr2IPz7syKJ3+BkiFaA4qAaCiYgwZw/iarb7Jc=;
        b=4hxSu5OrAG1cVnOyKe+ATREiTvAXhYAySuy3gR+0E98j+5H/BTcGmSGwcXObmlURre
         QQMHd58YvCTkMTY11cHL1fv+g7a+K5xOrrsQIs3ztpVtdmWldA3/vPquDCnJJH9XFxMX
         lN+pvWyP87oOMjOXEk0o+3lQ43bZYWh19HSseBBgUpYOIX7YfuxaWDdKruRORtLyUzuJ
         Kvh1Cz9SzEAunpQfqMNO9QQvEvyLMG1yGHvDmEV6ITFVCbkoTSTCiWj2Iz671P9uF5VY
         KErooQY9dgKRa3wJZWDPoaGdhq/TRCse84pl/0raRzamxwMnQc3s3i0OyxPcNCCtk+xW
         C/Nw==
X-Gm-Message-State: AOAM531b9Ckcedw4IFaIL34hwqqIUNkSPTDsjQre13gKQHW+ljr9QdQQ
        2uvO90G85EvvU11twatGCtU=
X-Google-Smtp-Source: ABdhPJxEdeWJ0YXQEF5d2viu/LBkT1AnRr1udWNMJxP0CzjWA6Cev3OfTsNa4L9yQK8atrd5mFwE0Q==
X-Received: by 2002:a17:907:1c8a:: with SMTP id nb10mr17753959ejc.5.1639073815418;
        Thu, 09 Dec 2021 10:16:55 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id gb18sm255956ejc.95.2021.12.09.10.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 10:16:54 -0800 (PST)
Message-ID: <61b24816.1c69fb81.c3a53.17cc@mx.google.com>
X-Google-Original-Message-ID: <YbJIDufk/oQNZvqF@Ansuel-xps.>
Date:   Thu, 9 Dec 2021 19:16:46 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next 0/7] DSA master state tracking
References: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
 <61b17299.1c69fb81.8ef9.8daa@mx.google.com>
 <20211209142830.yh3j6gv7kskfif5w@skbuf>
 <61b21641.1c69fb81.d27e9.02a0@mx.google.com>
 <20211209173316.qkm5kuroli7nmtwd@skbuf>
 <61b24089.1c69fb81.c8040.164b@mx.google.com>
 <20211209175617.652rdiidc6pfgdwz@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209175617.652rdiidc6pfgdwz@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 05:56:17PM +0000, Vladimir Oltean wrote:
> On Thu, Dec 09, 2021 at 06:44:38PM +0100, Ansuel Smith wrote:
> > > I think the problem is that we also need to track the operstate of the
> > > master (netif_oper_up via NETDEV_CHANGE) before declaring it as good to go.
> > > You can see that this is exactly the line after which the timeouts disappear:
> > > 
> > > [    7.146901] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> > > 
> > > I didn't really want to go there, because now I'm not sure how to
> > > synthesize the information for the switch drivers to consume it.
> > > Anyway I've prepared a v2 patchset and I'll send it out very soon.
> > 
> > Wonder if we should leave the driver decide when it's ready by parsing
> > the different state? (And change
> > the up ops to something like a generic change?)
> 
> There isn't just one state to track, which is precisely the problem that
> I had to deal with for v2. The master is operational during the time
> frame between NETDEV_UP and NETDEV_GOING_DOWN, intersected with the
> interval during which netif_oper_up(master) is true. So in the simple
> state propagation approach, DSA would need to provide at least two ops
> to switches, one for admin state and the other for oper state. And the
> switch driver would need to AND the two and keep state by itself.
> Letting the driver make the decision would have been acceptable to me if
> we could have 3 ops and a common implementation, something like this:
> 
> static void qca8k_master_state_change(struct dsa_switch *ds,
> 				      const struct dsa_master *master)
> {
> 	bool operational = (master->flags & IFF_UP) && netif_oper_up(master);
> }
> 
> 	.master_admin_state_change	= qca8k_master_state_change,
> 	.master_oper_state_change	= qca8k_master_state_change,
> 
> but the problem is that during NETDEV_GOING_DOWN, master->flags & IFF_UP
> is still true, so this wouldn't work. And replacing the NETDEV_GOING_DOWN
> notifier with the NETDEV_DOWN one would solve that problem, but it would
> no longer guarantee that the switch can disable this feature without
> timeouts before the master is down - because now it _is_ down.

Ok will have to test v2 and check if this is also fixed.

-- 
	Ansuel
