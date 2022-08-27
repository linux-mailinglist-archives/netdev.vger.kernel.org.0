Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AEC5A333C
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 02:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344716AbiH0Atb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 20:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245107AbiH0At3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 20:49:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F0BEA89E
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 17:49:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86D7361C60
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 00:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC0CC433D6;
        Sat, 27 Aug 2022 00:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661561367;
        bh=Je4qxl3hkehFNlzslHxj9FGWX/vZcJHw3826dKQLXZk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LR2vKL9XamtIw0+itdgO/uylu5X57atECMaKXwMRepalrjjQX7BPRal3n6TwnR/VA
         1AedFF09xZoz3lH9eBDQqmcwBSm5+aBvPxCjqQ59kYZqF3DK4WaLhHHxCSwo9dkLQX
         ZHuG93zndKQqlM1nm3oOrOdkmf5gBeU5Gz6mDsYsdHT/0MoLK2qD0iaXsyprZo/E0K
         ai1DRVq6c5zL7o69/nTCMUFUIoyF7WBwwsTSLcvuFobKMl2+Qr/Lo/w14dNcC4kBrw
         S0O5qZbai1bQ8A/3m0qCUUJGDcg/Hr6GC6ed70YkczpG84nGxOlMbsGwM7sc70VQO9
         nKtBCy8+kjBfg==
Date:   Fri, 26 Aug 2022 17:49:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Romain Naour <romain.naour@smile.fr>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        arun.ramadoss@microchip.com, Romain Naour <romain.naour@skf.com>
Subject: Re: [PATCH 1/2] net: dsa: microchip: add KSZ9896 switch support
Message-ID: <20220826174926.60347d43@kernel.org>
In-Reply-To: <7e5ac683-130e-2a00-79c5-b5ec906d41d1@smile.fr>
References: <20220825213943.2342050-1-romain.naour@smile.fr>
        <Ywfx5ZpqQ3b1GMBn@lunn.ch>
        <7e5ac683-130e-2a00-79c5-b5ec906d41d1@smile.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Aug 2022 09:31:00 +0200 Romain Naour wrote:
> >> Signed-off-by: Romain Naour <romain.naour@skf.com>
> >> Signed-off-by: Romain Naour <romain.naour@smile.fr>  
> > 
> > Two signed-off-by from the same person is unusual :-)  
> 
> Indeed, but my customer (skf) asked me to use the skf.com address for the patch
> but I use my smile.fr (my employer) git/email setup for mailing list.

It's pretty common to use a different email server than what's
on the From and S-o-b lines. You can drop the second S-o-b.
