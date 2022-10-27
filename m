Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A337D60EE65
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbiJ0DNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234258AbiJ0DNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:13:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B50D12791C
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 20:13:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46E08B82487
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 03:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCFCCC433C1;
        Thu, 27 Oct 2022 03:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666840404;
        bh=XZjSWg/bohMf0syilp3YBhdd3paoYULMVbd9ThzC/YM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KcxW9fBs+H4Rkm7faSyb4fcdSkN6G1yc7RRbMViKMJ5DvMM2RA7yfWSqSVKruBVSs
         U6v0s3Gj7Li1llqOHJ7mfVmo7RuUD87liyoRNmB4lfXRzel961YmzsfeqaB0Invoc9
         wpM3szdsrAXse48fHzffWF64XgglW0GdHwO5wR1zCLTyUzWHdRMO5Q459GqEv3SPxr
         Gv3yUKnFRSf2N44S2G5rCstzWKZWbklrSHn3qF55UGsMrX4D9KNaw+viQSTNxgHemm
         ymo9vL8p96dQ0eUBzUljKYa8DbCFtA1LScDjuRvZH8URVPnKgpGWDrLM1UJF26LirT
         fcbTriieu/fJw==
Date:   Wed, 26 Oct 2022 20:13:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v5 1/3] net: txgbe: Store PCI info
Message-ID: <20221026201323.2dc35c9e@kernel.org>
In-Reply-To: <20221025020217.576501-2-jiawenwu@trustnetic.com>
References: <20221025020217.576501-1-jiawenwu@trustnetic.com>
        <20221025020217.576501-2-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Oct 2022 10:02:15 +0800 Jiawen Wu wrote:
> --- /dev/null
> +++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> @@ -0,0 +1,56 @@

> +/**
> + * register operations
> + **/

./scripts/kernel-doc reports:

drivers/net/ethernet/wangxun/libwx/wx_type.h:49: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
