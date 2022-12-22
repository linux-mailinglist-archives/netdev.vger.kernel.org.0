Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB63B6548B3
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 23:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiLVWqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 17:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiLVWqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 17:46:03 -0500
X-Greylist: delayed 1201 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 22 Dec 2022 14:46:00 PST
Received: from peace.netnation.com (peace.netnation.com [204.174.223.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C8415805;
        Thu, 22 Dec 2022 14:46:00 -0800 (PST)
Received: from sim by peace.netnation.com with local (Exim 4.92)
        (envelope-from <sim@hostway.ca>)
        id 1p8Tkr-0001sH-Sp; Thu, 22 Dec 2022 14:09:33 -0800
Date:   Thu, 22 Dec 2022 14:09:33 -0800
From:   Simon Kirby <sim@hostway.ca>
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: "nft list hooks" in older kernels?
Message-ID: <20221222220933.GA18964@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

I'm once again running into some fun with IPVS and nftables NAT, and I
was curious if there's any way in earlier kernel to get a list similar to
"nft list hooks" provided by e2cf17d3774c323ef6dab6e9f7c0cfc5e742afd9
(in >= 5.14), as I'm attempting to compare with 4.14 (LTS) which we're
still stuck on in some instances (see "Inability to IPVS DR with nft dnat
since 9971a514ed26").

I attempted to backport this commit to v4.14, but it relies on quite a
lot of changes since then.

Also, where do the priorities for "type nat" chains actually end up being
stored? Are they printable?

Simon-
