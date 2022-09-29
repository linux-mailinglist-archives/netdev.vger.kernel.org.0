Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F21B5EF926
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbiI2PfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235973AbiI2Pdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:33:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0219125186
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:33:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B3C2B824F2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 15:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8390FC433D6;
        Thu, 29 Sep 2022 15:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664465586;
        bh=yg14YPAwfz+TyHhDQbc+O7Cz2HleOLEebYGvlIDPU9c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iWhQ2qPTU6x/B4RVg1x1qMTQ3Aoa9x2ZQTv+RpiGunsfweP0bcqg1kKPifu4Fq2gR
         oeRo3Dtr2ykGxdJoXlAjYML/xgTOyZ+rMkUK7OPq+oLz3itF9PorlCQydlypVhTz/Q
         LZZLVYlZ9dfFA1FBSTviCnn+Y4CoHySo+jFOhknp2QosiNKYo+3RMI+0Z1I99dRAkQ
         1s5AM+ScJv1MNmNnGgn7PjRBAeZwWR5xhQbRoeYgzbzyvmwMrCLlkYSEVutNAt80AQ
         P/rv1Al+/fikChjfrENsrCklLQgMmJucxl5NclxYCY4VtCI5Sccde7bPaIci5Uwa0p
         /634q4IJeMGEA==
Date:   Thu, 29 Sep 2022 08:33:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [pull request][net-next 00/16] mlx5 updates 2022-09-27
Message-ID: <20220929083305.7b40b595@kernel.org>
In-Reply-To: <20220929072043.etp5f7bcne2q5pf6@dhcp-10-2-57-92.baseline-sap.scl-ca.nvidia.com>
References: <20220927203611.244301-1-saeed@kernel.org>
        <20220928193540.29445d20@kernel.org>
        <20220929072043.etp5f7bcne2q5pf6@dhcp-10-2-57-92.baseline-sap.scl-ca.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Sep 2022 00:20:43 -0700 Saeed Mahameed wrote:
> I would appreciate it if you expedite acceptance so I can post part3
> and 4 in this cycle, and get mlx5's XSK issues behind me once and for all.

Don't think it's gonna make it if Linus cuts final on Sunday :(
I'll look at the mlx5 patches as soon as you post but I don't
see any real reason to circumvent the normal list wait time.
