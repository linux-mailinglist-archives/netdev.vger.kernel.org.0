Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B662747DA
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 19:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgIVRzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 13:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgIVRzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 13:55:22 -0400
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:171:314c::100:a1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6003C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 10:55:21 -0700 (PDT)
Date:   Tue, 22 Sep 2020 19:55:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c0d3.blue; s=2018;
        t=1600797320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WAT+1Bo7DvbvxFHYUbGR9cD0AOeb3oC01HODpW8Xb6A=;
        b=TLH6Fo6N2Za+3cD+15QuafRAkWk1liFkrXfyRYyOW+pMMGuaZcKk6Dp87xpRdwtgnVt3fJ
        qUKOHmPhFMnT6IGE4Rp4jaci5CQ2gj7PuWdtd+wWovffdk0SjbdZxjuJbzPBvFwn0eKK5c
        fsyKQfsaGzU1rmrHayQmkepxiyY47kuxIUiI74zs8JEwpzNvGRKuVMS3fXjJ8O4/HqTSJy
        bOIKoP6/l0uGYeFK5gi6/uPCPwwifdOxKNGUiFjFBXlrOTJ5apNC29T8cv7EZYGS/lmpFh
        SNvqSqcnbb5mDlIfgBQWYYzbuvID+DGchz/fN/6o8cPYIwpMrWUX+VKS0bukzQ==
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
Message-ID: <20200922175519.GB10212@otheros>
References: <20200922073027.1196992-1-razor@blackwall.org>
 <20200922073027.1196992-7-razor@blackwall.org>
 <20200922175119.GA10212@otheros>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200922175119.GA10212@otheros>
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=linus.luessing@c0d3.blue smtp.mailfrom=linus.luessing@c0d3.blue
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 07:51:19PM +0200, Linus Lüssing wrote:
> I don't see a "src" in br_ip in net-next/master at the moment. Or
> is that supposed to be added with your IGMPv3 implementation in
> the future?

Ah, sorry, found the according patch (*) it in my other inbox.
Nevermind.

(*): [PATCH net-next v2 04/16] net: bridge: add src field to br_ip 
https://patchwork.ozlabs.org/project/netdev/patch/20200922073027.1196992-5-razor@blackwall.org/
