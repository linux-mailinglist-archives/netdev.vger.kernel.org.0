Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079082747BF
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 19:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgIVRv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 13:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbgIVRv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 13:51:26 -0400
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:171:314c::100:a1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BB8C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 10:51:26 -0700 (PDT)
Date:   Tue, 22 Sep 2020 19:51:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c0d3.blue; s=2018;
        t=1600797081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zCM5VxHkCIoBQeDJlIyw4juC1TJgd0X5qSumEOZ5cdQ=;
        b=ipbW8ktr8x318xBdJvWFr4qPkL452gpIHsDdF3J32VjU7bTntUOieHxevcgOR+BvdjaCl6
        nO8NG59iip3n7eGDrLawIxbFoX0IBFfi11wbkClVA7vl1hn5pCwnp94dk2P8sMhfV8ePM9
        sp+Lu+eW+NEns8yJOA6ZEqAuMvfBxajboF2g9HWuDJ+8CP2Gpkh9p6ioC1hHKloRBHoOu9
        7zYbsY8OcfNgLjED8MjndpiscdZRtlIHY1qKXYD4frwq6epkS/0AH3LvCDdWrrDI1GLlye
        iagt4ajRj8F0cPxPsVp/Pw6zIPkYb/lVrsiqaQeSoOYrDCGO9c+Hz8UgpoQ/Fg==
From:   Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     The list for a Better Approach To Mobile Ad-hoc
         Networking <b.a.t.m.a.n@lists.open-mesh.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <a@unstable.cc>
Subject: Re: [PATCH net-next v2 06/16] net: bridge: mcast: rename br_ip's u
 member to dst
Message-ID: <20200922175119.GA10212@otheros>
References: <20200922073027.1196992-1-razor@blackwall.org>
 <20200922073027.1196992-7-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200922073027.1196992-7-razor@blackwall.org>
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=linus.luessing@c0d3.blue smtp.mailfrom=linus.luessing@c0d3.blue
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 10:30:17AM +0300, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Since now we have src in br_ip, u no longer makes sense so rename
> it to dst. No functional changes.
> 
> v2: fix build with CONFIG_BATMAN_ADV_MCAST

Hi Nikolay,

I don't see a "src" in br_ip in net-next/master at the moment. Or
is that supposed to be added with your IGMPv3 implementation in
the future?

(which btw. is awesome, really looking forward to full IGMPv3(+MLDv2)
support, as source-specific-multicast would allow us to implement
some neat, way more efficient algorithms than with any-source-multicast
for multicast in batman-adv in the future, too)

Regards, Linus
