Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0DFC283FC2
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbgJEThM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729302AbgJEThM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 15:37:12 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AB1C0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 12:37:11 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kPWIF-00HOiW-Dn; Mon, 05 Oct 2020 21:37:07 +0200
Message-ID: <519f7f5174b9aab744a3706599c942772bd7d01c.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 5/6] netlink: add mask validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jiri@resnulli.us, andrew@lunn.ch, mkubecek@suse.cz,
        dsahern@gmail.com, pablo@netfilter.org
Date:   Mon, 05 Oct 2020 21:37:06 +0200
In-Reply-To: <20201005123414.2a211b40@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201005155753.2333882-1-kuba@kernel.org>
         <20201005155753.2333882-6-kuba@kernel.org>
         <c28aa386c1a998c1bc1a35580f016e129f58a5e3.camel@sipsolutions.net>
         <20201005122242.48ed17cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <18fc3d1719ce09d5aa145a164bf407fe7a7bbb81.camel@sipsolutions.net>
         <20201005123414.2a211b40@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-05 at 12:34 -0700, Jakub Kicinski wrote:

> > > My thinking is that there are no known uses of the cookie, it'd only

Ahh. I completely misinterpreted the word "uses" here - you meant, I
think (now), "uses of the cookie in the way that it was done in ethtool
before". I read over this because it seemed in a way obviously right and
also obviously wrong (no other uses of the cookie in ethtool and clearly
uses of the cookie elsewhere, respectively)...

> Right, I was commenting on the need to keep the cookie for backward
> compat.

Right ...

> My preference is to do a policy dump to check the capabilities of the
> kernel rather than shoot messages at it and then try to work backward
> based on the info returned in extack.

I guess Michal disagrees ;-)

I can see both points of view though - if you have just a single
attribute it's basically the same, but once you have two or more it's
way less complex to just query before, I'd think.

johannes

