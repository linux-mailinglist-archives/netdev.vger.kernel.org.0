Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2EF456295E
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 05:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbiGADJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 23:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiGADJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 23:09:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D512C248CC
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 20:09:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EC5E62241
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 03:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7734AC34115;
        Fri,  1 Jul 2022 03:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656644952;
        bh=nOUSb/kzw2+hQhMBey4GePsZ71awhqsXWbrhMf8rEnw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ABksMqY4Pi2o3jhEGzTWUUGGqopmnwJDjuXHG5MmoSyg1fdvIvCRF5yDZO+Uz/nAw
         MTpgPYqb4R2eMfXZ1GvDjvKifWuMBAEF0cEeFKjz/or633iSKagR44l6NSbwWqop5m
         0r0J74nEmF1dJsd7MtJQ9SnoWT/OdGWTl+qjmzfxf2iJSFlkUU+NlMin/YwVfmLhox
         spoHvVQvMLNk/wi+yi5K/Y9MHFIEuSJ80iBpuOkuH7Kg0jxJ2NJYnQxT+z4Am5sFkB
         t7996sg5EczKlFKPaHi5fg/MSNfjRoviNKVd6d9par74TAA7b2lY88ctU+nBZpcSC/
         UWfX5wqqZ21ZA==
Date:   Thu, 30 Jun 2022 20:09:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Jianbo Liu <jianbol@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: Re: [net-next 09/15] net/mlx5e: Prepare for flow meter offload if
 hardware supports it
Message-ID: <20220630200911.3d168685@kernel.org>
In-Reply-To: <20220630010005.145775-10-saeed@kernel.org>
References: <20220630010005.145775-1-saeed@kernel.org>
        <20220630010005.145775-10-saeed@kernel.org>
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

On Wed, 29 Jun 2022 17:59:59 -0700 Saeed Mahameed wrote:
> From: Jianbo Liu <jianbol@nvidia.com>
> 
> If flow meter aso object is supported, set the allocated range, and
> initialize aso wqe.
> 
> The allocated range is indicated by log_meter_aso_granularity in HW
> capabilities, and currently is 6.

Build gets broken here, patch 11 fixes the build for 64b but 32b
remains broken.
