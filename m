Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552DB542828
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 09:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbiFHHYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 03:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235103AbiFHG5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 02:57:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377F51AA16B;
        Tue,  7 Jun 2022 23:44:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2923EB825AB;
        Wed,  8 Jun 2022 06:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB088C34116;
        Wed,  8 Jun 2022 06:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654670671;
        bh=9uI57g5WwTcx50GI4FESw2HeW6aNiYBEucmXEvFRlcQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z24xoyfRgVkYgNms9ujkTKLIaGkg3c6pJ3exyhEV2mM2OYZ1YOI85tFOZ/D3zTVws
         LPQupZrIrjvaGocu+UwtlGRVC6ZpYZ+bvzgdxKyQxcAaIukeToZ50Zpeu9u5sHgLxW
         O7CMst3VMjUZCFxTWydQHU5K2D607koO3LcsKk+o3gRXbiPNxxcc4LCpEFUUExpBeE
         U5G42tKzGvJUUDCCtUKzm5RFQUoWKsSJgWxULMtuesNZ8JLjV5PGVFJ4dvn6evh2jm
         VgpmvvdNsD+uYHD5ju1gYUsUGaLRkmpFWTE6EEsEFI9AZ5KpJj++62TuQYVNXWMEln
         hRcGrp/PSwySw==
Date:   Tue, 7 Jun 2022 23:44:31 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH mlx5-next 1/3] net/mlx5: Introduce header-modify-pattern
 ICM properties
Message-ID: <20220608064431.67k2jec2eue2lccl@sx1>
References: <cover.1654605768.git.leonro@nvidia.com>
 <66f4096ce4d4c8451f0b781284c650f97e545d41.1654605768.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <66f4096ce4d4c8451f0b781284c650f97e545d41.1654605768.git.leonro@nvidia.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07 Jun 15:47, Leon Romanovsky wrote:
>From: Yevgeny Kliteynik <kliteyn@nvidia.com>
>
>Added new fields for device memory capabilities, in order to
>support creation of ICM memory for modify header patterns.
>
>Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
>Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Acked-by: Saeed Mahameed <saeedm@nvidia.com>

