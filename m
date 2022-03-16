Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195A64DB813
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357750AbiCPSp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353677AbiCPSpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:45:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A837369F9
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 11:44:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02D3661882
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 18:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F99C340EC;
        Wed, 16 Mar 2022 18:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647456280;
        bh=bE4FpuFV95noyMaJfN/xuhac8qrvWy9jju8fFD55ENo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MJhwcezahr3GbGXh2+cSQwHIjI/jiAm/ahIf6kIkIDs4T670M9wJMXASwpKUZJZMd
         bChBllKVfZ4byrT5UT5AOTqmZZiBij+BhZgEi9mOQN3OwdGX9KHI3sPHi3dXfH0d2L
         jlrYPTbHd/+YXjEJWlKLNhh6UikzU3rxXm+cnnk49187HU1ZgRfYeIkUCVRSfAyWHa
         WTjB1pHXKAwnK46kcW9rpxiyIqkBVsurrgiZhXGFyV8PndpJKUmwxiZDAr/VfWsfsm
         fzq+GQjuyZrK1E0gxHc5xrrtJCsB0qb/zgaun55Qwpn4N6OJ8uulMR5EgQT69iLoD3
         oraGpA/VdIFbQ==
Date:   Wed, 16 Mar 2022 11:44:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>
Subject: Re: pull request (net): ipsec 2022-03-16
Message-ID: <20220316114438.11955749@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220316121142.3142336-1-steffen.klassert@secunet.com>
References: <20220316121142.3142336-1-steffen.klassert@secunet.com>
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

On Wed, 16 Mar 2022 13:11:40 +0100 Steffen Klassert wrote:
> Two last fixes for this release cycle:
> 
> 1) Fix a kernel-info-leak in pfkey.
>    From Haimin Zhang.
> 
> 2) Fix an incorrect check of the return value of ipv6_skip_exthdr.
>    From Sabrina Dubroca.

Excellent, thank you!

> Please pull or let me know if there are problems.

One minor improvement to appease patchwork would be to add / keep the
[PATCH 0/n] prefix on the PR / cover letter when posting the patches
under it. It seems that patchwork is hopeless in delineating the
patches and the PR if that's not there. For whatever reason it grouped
the PR and patch 2 as a series and patch 1 was left separate :S
