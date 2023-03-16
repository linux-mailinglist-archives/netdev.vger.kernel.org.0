Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698FB6BC56B
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 05:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjCPE4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 00:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCPE4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 00:56:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970786B322
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 21:56:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34443B81FCA
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 04:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91361C433EF;
        Thu, 16 Mar 2023 04:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678942602;
        bh=gf5lYMbsr+VUZ1qlHxtgc6FyWGqk1KIdmM+A+mlDPuI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=okYQNS1RqMTnuIdCfE5TJh6J5YH39x2nO3uqusEXbze4dB6lt7hW3uXtSSP5Rhqpb
         61Enu0dtizeZp07WKG1Dtf6UB5jOYFVSb/kUsmEcwmB4ut7NdwKilrpqNd600PEQn+
         Bi8WAGdfxBt7qWH5vz6Y4U7GoIiGEYzYQA2nlZYRATTAzH9FOC/BIQrDERgVURzMpF
         H1AIPy7ucQ9MwXWjZq500ykGj9zbOGqHNDQF0CrveEkDt7VJ2A7OaumqDkwtJYGBUk
         skssszbVhBCjKGAjr6EizxOxp34nLm5kBARk/UTu+EAkr25Vb2a3Cxz8shwOVz1+eA
         PHb/3BnN22eqQ==
Date:   Wed, 15 Mar 2023 21:56:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>
Subject: Re: [net-next 05/15] net/mlx5e: Correct SKB room check to use all
 room in the fifo
Message-ID: <20230315215641.24119b38@kernel.org>
In-Reply-To: <20230314054234.267365-6-saeed@kernel.org>
References: <20230314054234.267365-1-saeed@kernel.org>
        <20230314054234.267365-6-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Mar 2023 22:42:24 -0700 Saeed Mahameed wrote:
> Subject: [net-next 05/15] net/mlx5e: Correct SKB room check to use all room in the fifo

net/mlx5e: utilize the entire fifo

> From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> 
> Previous check was comparing against the fifo mask. The mask is size of the
> fifo (power of two) minus one, so a less than or equal comparator should be
> used for checking if the fifo has room for the SKB.
> 
> Fixes: 19b43a432e3e ("net/mlx5e: Extend SKB room check to include PTP-SQ")

no fixes tag

I thought we've been over this.
