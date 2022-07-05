Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29CD5661A6
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 05:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbiGEDDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 23:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbiGEDDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 23:03:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436DF2AEE
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 20:03:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5387618B6
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 03:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD872C3411E;
        Tue,  5 Jul 2022 03:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656990231;
        bh=yrxezKofmK3kLzgGjsvDv3mNL3rZs16OTBiJu7fzt0s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jA4nf5PtWxp6wZJ2THg/flgwoj1n0Q/nwhk1ealNFZR157QuhZ2eBq+GuuXQ6iEDG
         Gj6MDeLfS3RPYDaR4xpO2eaCQhE5/p0mlP564RMDspPfMO2z3CmoMsMnMcr1fTbNtB
         aYR0gLNOKEvwGW07D3ca28YjUFaawVZqXT4ZscMsxGLPDbJ/wrGJon3rzGiBhLAsRF
         xQgwjQ17ULj1xsRlvY1RAqfPDi5tM7iTWgxKCo5loFKJhuZFiBiWGsVLcs9vgUBfAV
         H5reY5lvSd0bs9I68k+4o5CZgyh50q8bm0jXYrm4NnSHFZF1Cv9ju1Ff8wCGbNsxQ3
         lTrjKFNVez8HQ==
Date:   Mon, 4 Jul 2022 20:03:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Jianbo Liu <jianbol@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: Re: [net-next v2 10/15] net/mlx5e: Add support to modify hardware
 flow meter parameters
Message-ID: <20220704200349.7a6073d3@kernel.org>
In-Reply-To: <20220702190213.80858-11-saeed@kernel.org>
References: <20220702190213.80858-1-saeed@kernel.org>
        <20220702190213.80858-11-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  2 Jul 2022 12:02:08 -0700 Saeed Mahameed wrote:
> The policing rate and burst from user are converted to flow meter
> parameters in hardware. These parameters are set or modified by
> ACCESS_ASO WQE, add function to support it.

This broke 32 bit build, please fix ASAP.
