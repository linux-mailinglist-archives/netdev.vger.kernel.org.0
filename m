Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7354D8E77
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 21:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245212AbiCNUxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 16:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245182AbiCNUwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 16:52:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89173C49A;
        Mon, 14 Mar 2022 13:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5659F612FF;
        Mon, 14 Mar 2022 20:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873F3C340E9;
        Mon, 14 Mar 2022 20:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647291102;
        bh=B53m5nf1W/6668dpYM5HCPdESzBVgDQg+1asnPm/GJk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a8v//73IOb8+QcFbwzLFsYxocO52d+VUC1de1OOZdtHRS/YVH0oZ+jY4D0F7JYg2K
         dDF77VgAxMCG15vqKgK0DgkE9XG7/67aaiJ8BpOqjZqyJWIBVAWtulLN8iFNmczwUF
         ZGFnIJdJZW+rh9o79w4Qrd2u4bMnRKV+9MVQPR3kKMwNQgaR5fwkhRFcSppTV7YelY
         mI6cTsZjssg1djx9jn+pFATI+na0v9MamIgrBek6+3ahQVnPuHboDwBMuQFK0DwrdI
         2RniPUVDHexvzX7jGxnX40CV0gXxCIfjZmLGWpdeagTM61it5asaVGPprMzR/oyoJ6
         qhvN9PAEJZdgQ==
Date:   Mon, 14 Mar 2022 13:51:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2022-03-11
Message-ID: <20220314135141.1cf36e3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3e9e10f34215b4d6b3a7361971df3c93d4b25419.camel@sipsolutions.net>
References: <20220311124029.213470-1-johannes@sipsolutions.net>
        <164703362988.31502.5602906395973712308.git-patchwork-notify@kernel.org>
        <20220311170625.4a3a626b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220311170833.34d44c24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87sfrkwg1q.fsf@tynnyri.adurom.net>
        <20220314113738.640ea10b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6d37b8c3415b88ff6da1b88f0c6dfb649824311c.camel@sipsolutions.net>
        <20220314134146.20fef5b9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3e9e10f34215b4d6b3a7361971df3c93d4b25419.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 21:45:11 +0100 Johannes Berg wrote:
> On Mon, 2022-03-14 at 13:41 -0700, Jakub Kicinski wrote:
> > 
> > Depends on what you mean. The bot currently understands the netdev +
> > bpf pw instance so it determines the target tree between those four.  
> 
> Makes sense, that's what it was written for :)
> 
> On the linux-wireless patchwork instance
> (https://patchwork.kernel.org/project/linux-wireless/) there are only
> two trees now, I think, wireless/main and wireless-next/main. Perhaps
> mt76 but maybe we'll just bring those into the fold too. Oh, I guess
> Kalle has some ath* trees too, not sure now.

Plus you need to know which series to ignore so that the occasional
cross-posted 50-patch series touching kernel.h doesn't take the build
bot out for 2 days :)

> > We'd need to teach it how to handle more trees, which would be a great
> > improvement, but requires coding.  
> 
> Right. Do you have it out in the open somewhere? Maybe we could even
> take it and run our own instance somewhere.

Oh yeah:

https://github.com/kuba-moo/nipa
