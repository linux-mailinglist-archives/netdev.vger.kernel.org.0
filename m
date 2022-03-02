Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2DC4C9A4F
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 02:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238844AbiCBBQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 20:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiCBBQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 20:16:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72214996A7;
        Tue,  1 Mar 2022 17:16:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 275A3B81BFB;
        Wed,  2 Mar 2022 01:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92128C340EE;
        Wed,  2 Mar 2022 01:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646183757;
        bh=ewUPkTFlUsosBWd4IqYZppZy3zDmtXuv9MukBGKEvd8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yqp+tW7QNVHPNrg8/T3ZAqdjE0QauXRdEcVCbn6zqkUoT1m6rnOk39ks5sIYfpx7y
         Z2vcCo1B5pPbspkoOogPj1VeMmgzszuBYglsY+L7jGQkqQcsM1f1+FqtpdCGXdVvrg
         ceolLOjg9cxkv2lYILVGEfPLriE0iqRE6KdRvcezEVnuff9tXLTDQod27phOt+Lr7Z
         wAZSQrk7GZSKtY8iXiS6e6hz9UTe3oLp4gPyf+4K02zE5/LSMxdz0mosWJZFpHMS7C
         TTH3cCLUMCLCEDT1C1ljHEyNoIvMJcXFJGinkPAYxGK+7R9MC0a9bbQ9T/xnZoz2kX
         yirILZIL9vHmA==
Date:   Tue, 1 Mar 2022 17:15:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Dust Li <dust.li@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20220301171556.7fcb6eeb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220302115646.422e29cd@canb.auug.org.au>
References: <20220302115646.422e29cd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Mar 2022 11:56:46 +1100 Stephen Rothwell wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> 
> Caused by commit
> 
>   12bbb0d163a9 ("net/smc: add sysctl for autocorking")
> 
> ( or maybe commit
> 
>   dcd2cf5f2fc0 ("net/smc: add autocorking support")
> )
> 
> I have used the net-next tree from next-20220301 for today.

Probably fixed by just pushed commit ef739f1dd3ac ("net: smc: fix
different types in min()") ? Sorry about that.
