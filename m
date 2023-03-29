Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FFB6CD2AA
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 09:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjC2HJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 03:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjC2HJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 03:09:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508FF137;
        Wed, 29 Mar 2023 00:09:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B069DB820CA;
        Wed, 29 Mar 2023 07:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003E0C433D2;
        Wed, 29 Mar 2023 07:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680073794;
        bh=mv36Q6rubWqizgAKGk0ONtnaEc6x+Na33/hRaN9TfFw=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=gQ0Ic5F9cQlCdxL7rPGBm3xNM6HBUzh/kRN3tplBe0sAKmqHjw5Dy8rCTrFMN36/n
         367UUODgzsEK0944DhfzPMdAg9NxC26xJKY/GEYo9vIPNb6qW3uw7fiThFLlEb7FO6
         jnYLSzjBeaLUuUEl4JfRAp+kOYZ4pmMt2J7opIVqcvbi7Ufsy7bagBTDptGVI8+SSR
         1XS7KzmIlLaZbtP4wpu7GORVhSAdpAEXbEtg2NjXxgarAbpMa5H6JhDPsuP23KDjY5
         kyhU6fmsO7MPnrX9m3aAC3NBN1x2vKbG1yYkqlQkFq/ePn/Mg7nkr2ZOBjIMzSisV8
         R5yCUxZ+0WfQw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc:     linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Patrisious Haddad <phaddad@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
In-Reply-To: <cover.1679566038.git.leon@kernel.org>
References: <cover.1679566038.git.leon@kernel.org>
Subject: Re: (subset) [PATCH rdma-next v1 0/2] Add Q-counters for representors
Message-Id: <168007379060.938793.1513443971003859888.b4-ty@kernel.org>
Date:   Wed, 29 Mar 2023 10:09:50 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, 23 Mar 2023 12:13:50 +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v1:
>  * Properly separated between uplink and representors counters
> v0: https://lore.kernel.org/all/cover.1678974109.git.leon@kernel.org
> ----------------------------------------------------------------------
> 
> [...]

Applied, thanks!

[2/2] RDMA/mlx5: Expand switchdev Q-counters to expose representor statistics
      https://git.kernel.org/rdma/rdma/c/d22467a71ebe96

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
