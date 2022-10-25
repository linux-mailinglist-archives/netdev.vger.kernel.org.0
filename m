Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435D960CA79
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbiJYLAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbiJYLAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C692DDA
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13665B81CEF
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 11:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B772C433C1;
        Tue, 25 Oct 2022 11:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666695615;
        bh=PqmLIsKELrYRPuMuxtFIkCO3e2udW55lE/qQ8jRROPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ukehbVp3DvIR8I0mbeKzgWICqqqastOz94D8JGx/FwhMtsspaJ1IgyjxrCvzRv/gy
         ubXX0ohui+DjDSfEPTTosb0adDxLzZ76p8KHhzqR95csBllFrm0Ix6BUfk4gI1ShOi
         vSaXJGkkJ2VaLiwYC3I6gTVvzT8aFCKedXY+iUvX9/KqgmBKOcEtnU8IXFJsY3Fi5y
         bVWLN/Cvs9IDTeBQuY1Px1M2Jhu2cow0nTCxFURncXx+/nxlmhiVF4xr7JS6adp8Ej
         HsNNha7ERUgp7oS6ZbCYZ/tYG11LUeyt/6bIEPxtmI/ZMOE50IjWgAAcYHfW9vCHWT
         gSTfyvXVZz27A==
Date:   Tue, 25 Oct 2022 12:00:11 +0100
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next v1 0/6] Various cleanups for mlx5
Message-ID: <20221025110011.rurzxqqig4bdhhq5@sx1>
References: <cover.1666630548.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <cover.1666630548.git.leonro@nvidia.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24 Oct 19:59, Leon Romanovsky wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>Changelog:
>v1:
>Patch #1:
> * Removed extra blank line
> * Removed ipsec initialization for uplink

This will break functionality, ipsec should only be enabled on nic and
uplink but not on other vport representors.

Leon let's finish review internally, this series has to go through my trees
anyways.


