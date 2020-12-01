Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4890B2C93D1
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 01:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbgLAAUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 19:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727373AbgLAAUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 19:20:44 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68166C0613D3;
        Mon, 30 Nov 2020 16:19:58 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id d17so157533ejy.9;
        Mon, 30 Nov 2020 16:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bBjclvgWoSr+bRB1ITg2zTw2nWf07seRYzMFcnIsPu4=;
        b=LYNZz/WVkbWUB4pZOLqNxwvsh4b7KxMBDmOBP8APt6ahYfooauzViPUDwB3ZyRXp9B
         EBO/nFUF9cePoyMuZQjtHd2aMFSmxgpxw/IXDjppqUaoynJo2t+yRpiuxAth+EfFNplk
         RngY70xpoHSAlKpkjgUSpm6Ma7uJCLQmExuUXmXrmQEXITj2/YV8cmRW4O6oC7BbMtuB
         ej8noBf/xZzk41yjJ1Y6jrgmIZtqW+jHYm7L2p9Ofpb60CLde9AYWZQYtA7W5XIKVVRZ
         ZRRGGMRZTvBkZSvOS85VuwUiNHPCr60CcAihlTg8FL7IWeS4i6BlXDHp4dBQ3/r29ZXd
         tgRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bBjclvgWoSr+bRB1ITg2zTw2nWf07seRYzMFcnIsPu4=;
        b=Z6+s3rnw8uiTL3oKavIkA+5rVvYqITotQPNTq7eI3nDysz6Velsey1vzhOIO8J2AlU
         AzgUYvt2yqcSg5XJpvuVu638Kpi4I9Egnj6Ily4VGSy7uWMYuAmxv+vNeFDlbv2voIYF
         +2c0HC/9JS2vEA63WfLN4H0CfmRo7JUg7xc/kS6rF6nsZKQqmgXyBeKapnW3+Ysb/TO5
         m3B0L03eInw8OxmUoD8Br/8+e7iXOHQdbQdLm+TLEcV/F7iSvdVxqbw4JW0qOWm0VjAB
         qq0kro7UFx3cW6JkW2OdYNyvqRvp7ulRQ90frKpXA+6HTqvCsXqtTPuhL3uhioLn4hXR
         a+tQ==
X-Gm-Message-State: AOAM533jh8VOiFjlqPsLuwSRHycAULiJ8+bPCQnX2351mhCJWDKP+pxL
        +M+Esaxa/uCRDazA4euz3VM=
X-Google-Smtp-Source: ABdhPJxRNMQJ/SPGOOj7Yu+TGXnJZECryZcNa0ht/Sg3H8EQbY+TgY6ZD1qEClYvkkZPMDyJwUGlhQ==
X-Received: by 2002:a17:906:98d4:: with SMTP id zd20mr408403ejb.532.1606781997082;
        Mon, 30 Nov 2020 16:19:57 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id oz19sm26555ejb.28.2020.11.30.16.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 16:19:56 -0800 (PST)
Date:   Tue, 1 Dec 2020 02:19:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201201001955.gy4fq4cxo6clw2it@skbuf>
References: <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201127233048.GB2073444@lunn.ch>
 <20201127233916.bmhvcep6sjs5so2e@skbuf>
 <20201128000234.hwd5zo2d4giiikjc@skbuf>
 <20201128003912.GA2191767@lunn.ch>
 <20201128014106.lcqi6btkudbnj3mc@skbuf>
 <20201127181525.2fe6205d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAFSKS=O-TDPax1smCPq=b1w3SVqJokesWx02AUGUXD0hUwXbAg@mail.gmail.com>
 <20201130235031.cdxkp344ph7uob7o@skbuf>
 <CAFSKS=NR6Toww7xj797Z09FNDXYawPFbbavv8hTzXJ2KFki=hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=NR6Toww7xj797Z09FNDXYawPFbbavv8hTzXJ2KFki=hg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 05:58:17PM -0600, George McCollister wrote:
> On Mon, Nov 30, 2020 at 5:50 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Mon, Nov 30, 2020 at 10:52:35AM -0600, George McCollister wrote:
> > > Another possible option could be replacing for_each_netdev_rcu with
> > > for_each_netdev_srcu and using list_for_each_entry_srcu (though it's
> > > currently used nowhere else in the kernel). Has anyone considered
> > > using sleepable RCUs or thought of a reason they wouldn't work or
> > > wouldn't be desirable? For more info search for SRCU in
> > > Documentation/RCU/RTFP.txt
> >
> > Want to take the lead?
>
> I certainly could take a stab at it. It would be nice to get a
> "doesn't sound like a terrible idea at first glance" from Jakub (and
> anyone else) before starting on it. Maybe someone has brought this up
> before and was shot down for $reason. If so that would be nice to
> know. Of course it's possible I could also find some reason it won't
> work after investigating/implementing/testing.

Well, for one thing, I don't think the benefit justifies the effort, but
then again, it's not my effort... I think there are simpler ways to get
sleepable context for the callers of dev_get_stats, I have some patches
that I'm working on. Not sure if you saw the discussion here.
https://lore.kernel.org/netdev/20201129205817.hti2l4hm2fbp2iwy@skbuf/
Let that not stop you, though.
