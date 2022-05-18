Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D100252AF51
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 02:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbiERAov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 20:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiERAou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 20:44:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD6153A7C
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 17:44:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 155DD614DB
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 00:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FAEC385B8;
        Wed, 18 May 2022 00:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652834688;
        bh=UhWXxeohQruDSiX+KBRiH+UxcY0WRtdTsjJl+yuq1eY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mqe8o3lkNKctGLwHymKuwIzC04SJgx7RmFHhgs/LMLQ+tYblv6tbCmu1K+LLlZrGr
         jKS2JMXnUKjszoJ5GyJ4yTagZyTUB14gJcqHWlHXWq9pN0itS3pNrjK/9KbyWN0Ic2
         vWO+ncEKiklCQIIAgML/NQsOEqo7CMKE8zieBFe1d6VQzhJhXBYS2C/6I9gxz+QDlp
         5GCUQbn9qEIdGe6+Tmj5j36lprrAliPfnN48nwjkeTkEm5VZGqHjy57MoA5xpyWGCx
         dplFblAyRNFoPgfL8xXdUx9iXzBIqKNSHrHHY1PvxeppqUpDqFFhVRHDeX8jk136N6
         ajZtHNbz5X5Tw==
Date:   Tue, 17 May 2022 17:44:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Bartschies <thomas.bartschies@cvk.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [Patch] net: af_key: check encryption module availability
 consistency
Message-ID: <20220517174447.0e596e4f@kernel.org>
In-Reply-To: <20220516125730.4446D160219F3@cvk027.cvk.de>
References: <20220516125730.4446D160219F3@cvk027.cvk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 May 2022 14:57:30 +0200 (CEST) Thomas Bartschies wrote:
> Since the recent introduction supporting the SM3 and SM4 hash algos for IPsec, the kernel 
> produces invalid pfkey acquire messages, when these encryption modules are disabled. This 
> happens because the availability of the algos wasn't checked in all necessary functions. 
> This patch adds these checks.
> 
> Signed-off-by: Thomas Bartschies <thomas.bartschies@cvk.de>

This has not made it into patchwork.

Did you put the list on BCC or something? If so how would people 
on the list see replies to this patch?

Please repost it with appropriate To: and CC: lists.
To: davem@davemloft.net
CC: everyone from scripts/get_maintainer
