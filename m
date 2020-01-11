Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C12F137AE4
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 02:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgAKBSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 20:18:46 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:39112 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728005AbgAKBSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 20:18:45 -0500
Received: by mail-pj1-f68.google.com with SMTP id e11so176179pjt.4
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 17:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pvGMB3KeuMuBhjFr6q3+OZVdZqnhqAQvvMd4lUcVWl4=;
        b=RopNWktMutn11DILPwgxoa7hXtGuZ3LxRoNOt5puZlZkWUr9pSGmyGqyDy3hzt1xf7
         SxRW9wguDb44LH+OxtDXY0eMDxb3Gnpn4Ra5UY8nMFP7gr150S13+2LDJmfT/6lyj5cp
         VqHJc+sc2pvFTDUIAx1XtqPGrgNwuF71s6Xm5F49YAA6rz2Ti3elwtEvogrUZ8+P/jhP
         JQqrizrY1IvjGXOetgTy7Je+qp3d516fIfMz9QRc3ma1xAXkzQu/CoAucn2aiqTmqVJd
         kFGgPN98nDAJ4HqhWXdyJ/GyMUhOU5zRYDQDLzALKGSSwzARgIDhkopN7adcc+6dJHwt
         imbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pvGMB3KeuMuBhjFr6q3+OZVdZqnhqAQvvMd4lUcVWl4=;
        b=jthXF8iUrHLvl7VxP0Iz+2iAHDMytlmke4W++duqGZme/ALygvXg1BKZh4hD9xPuhx
         WV2Z+vVrtwIOmsvqvJD6v6ki4uI3v7ua/rvmBh+WEMShv9PNTi8bkh2B8d/20WUW9eer
         GoL5vDZPxxHe5sjtbhd1FyiXw+EZVgwRGDYD+tJcmh2p2hWWn0bfzDXeLJVfmaCE6f8i
         qf2oQ1hUHGrNWasnOAbqE4mpBiuq4i7nihykqabV9XtuSVkmMqiX7hef8UVsvuHGQhLd
         v5Pi4+fj6IQkP7ziyGbr8SXMWSnKtgHWai2bY/whsFk/qEPe98wsDv5bVy6UzNDGX465
         +NlA==
X-Gm-Message-State: APjAAAXUv8ZdUmCxuas2BVEpvjRiNAXzJKlueO1b/9IIIKj18f+kI1Q/
        xAKWmD0iowET416vy1bdtwE=
X-Google-Smtp-Source: APXvYqx+AQnIe0BIDNaPlpKfO2uQxqwC42Dhhnx/IKPYzyd/SLaE9VLaIBlb8YE7LElv7ynPWIGTkQ==
X-Received: by 2002:a17:90b:46c4:: with SMTP id jx4mr8626672pjb.32.1578705525183;
        Fri, 10 Jan 2020 17:18:45 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b42sm4143605pjc.27.2020.01.10.17.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 17:18:44 -0800 (PST)
Date:   Sat, 11 Jan 2020 09:18:35 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] net/route: remove ip route rtm_src_len, rtm_dst_len
 valid check
Message-ID: <20200111011835.GG2159@dhcp-12-139.nay.redhat.com>
References: <20200110082456.7288-1-liuhangbin@gmail.com>
 <49a723db-1698-761d-7c20-49797ed87cd1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49a723db-1698-761d-7c20-49797ed87cd1@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 02:48:03PM -0700, David Ahern wrote:
> On 1/10/20 1:24 AM, Hangbin Liu wrote:
> > In patch set e266afa9c7af ("Merge branch
> > 'net-use-strict-checks-in-doit-handlers'") we added a check for
> > rtm_src_len, rtm_dst_len, which will cause cmds like
> > "ip route get 192.0.2.0/24" failed.
> 
> kernel does not handle route gets for a range. Any output is specific to
> the prefix (192.0.2.0 in your example) so it seems to me the /24 request
> should fail.
> 

OK, so we should check all the range field if NETLINK_F_STRICT_CHK supplied,
like the following patch, right?


diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 87e979f2b74a..a681c5cfbf13 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3063,8 +3063,7 @@ static int inet_rtm_valid_getroute_req(struct sk_buff *skb,
 					      rtm_ipv4_policy, extack);
 
 	rtm = nlmsg_data(nlh);
-	if ((rtm->rtm_src_len && rtm->rtm_src_len != 32) ||
-	    (rtm->rtm_dst_len && rtm->rtm_dst_len != 32) ||
+	if (rtm->rtm_src_len || rtm->rtm_dst_len ||
 	    rtm->rtm_table || rtm->rtm_protocol ||
 	    rtm->rtm_scope || rtm->rtm_type) {
 		NL_SET_ERR_MSG(extack, "ipv4: Invalid values in header for route get request");
@@ -3083,12 +3082,6 @@ static int inet_rtm_valid_getroute_req(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	if ((tb[RTA_SRC] && !rtm->rtm_src_len) ||
-	    (tb[RTA_DST] && !rtm->rtm_dst_len)) {
-		NL_SET_ERR_MSG(extack, "ipv4: rtm_src_len and rtm_dst_len must be 32 for IPv4");
-		return -EINVAL;
-	}
-
 	for (i = 0; i <= RTA_MAX; i++) {
 		if (!tb[i])
 			continue;


Thanks
Hangbin
