Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659366E86CA
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 02:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbjDTArW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 20:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbjDTArT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 20:47:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDC330FD
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 17:47:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17F086441C
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 00:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED09C433EF;
        Thu, 20 Apr 2023 00:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681951636;
        bh=CH2Y4Bz6prK0cj+JvrzukX9ARUiQe952KFaN1us54Jc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bsF/hgGF5x4RhjzzxVJgWd5R/mO8DR+pjVDCzdLjjjHgevTd6OUqev3Xi8QHzXuyh
         SAM2ItB6ueU+GRUt60ByXNto0tuZbHfLpWVH+UY3UEdIi6jlah+J0G4RaKT3ZDxh/Y
         QXADfjKol/nXRK1X1LT/cam+tz9kTk+VcPxOsp/Vhwy0uUfd2EuHfo2eCoxB+kEfc4
         ePwFDRNN0aQ1tlOgMOz2RZ6T/c8VRjr0petJzOr+Sy+NkFUUUFrgGPO22wLAjxlCiB
         hOdSV9KZo9mw+HlMkn1c/qdcrxVqhqT+WngWgXDZjhUz/K9vUivHO0XeHh21znMTof
         kJFTKmsXSzB3w==
Date:   Wed, 19 Apr 2023 17:47:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Henning Fehrmann <henning.fehrmann@aei.mpg.de>,
        "Oliver Behnke" <oliver.behnke@aei.mpg.de>
Subject: Re: [PATCH net-next 00/15] net/mlx5e: Extend XDP multi-buffer
 capabilities
Message-ID: <20230419174715.04087083@kernel.org>
In-Reply-To: <20230417121903.46218-1-tariqt@nvidia.com>
References: <20230417121903.46218-1-tariqt@nvidia.com>
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

On Mon, 17 Apr 2023 15:18:48 +0300 Tariq Toukan wrote:
> This series extends the XDP multi-buffer support in the mlx5e driver.
> 
> Patchset breakdown:
> - Infrastructural changes and preparations.
> - Add XDP multi-buffer support for XDP redirect-in.
> - Use TX MPWQE (multi-packet WQE) HW feature for non-linear
>   single-segmented XDP frames.
> - Add XDP multi-buffer support for striding RQ.

This is cd02a1a24897 in net-next, thanks!
