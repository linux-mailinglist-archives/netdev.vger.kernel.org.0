Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E8F6E03DF
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 03:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjDMBxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 21:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDMBxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 21:53:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E88527A
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 18:53:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CB2D62104
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34BCC433D2;
        Thu, 13 Apr 2023 01:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681350808;
        bh=R/HFoDaPV1d1qIy2duWclrCQWtRV9RjNnsbpNTnfCns=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HBYEZjtxDDCaT2W+oUX1MGGWvow9vUd/7mPHbhcqRx1+SiZLo6UM8FCDUbm9HQKd4
         nLZ20O2EwYChDh2buZqsuO3QK6WuHWgkDJJSrndjmYyCPkjZKhncTFaRK1J1/yyB35
         DwOJj6i1OQIEg/tTsA4MeYL8+OSUzqXxclKKO06Ox9ePHBdQ+I128fYXwsjHTfgycR
         XLbnB3dANwaPsvW4DWdWHWvga2IXKsXZuMpDWPtI2a2QUlGeVGFPvwKJ25MKQPUkZT
         brpvoTvKCcTQUQA9yRfW+QtQS4R04nKvbJVuPIcGftKRaUs4rI7fdGQrh2JJQN7O/y
         JHD0aC5bjmo5g==
Date:   Wed, 12 Apr 2023 18:53:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <edward.cree@amd.com>
Cc:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: Re: [RFC PATCH v2 net-next 4/7] net: ethtool: let the core choose
 RSS context IDs
Message-ID: <20230412185326.3b07201e@kernel.org>
In-Reply-To: <7a18d0588e8596ad9cc83234488bebe22ba3d328.1681236653.git.ecree.xilinx@gmail.com>
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
        <7a18d0588e8596ad9cc83234488bebe22ba3d328.1681236653.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Apr 2023 19:26:12 +0100 edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Add a new API to create/modify/remove RSS contexts, that passes in the
>  newly-chosen context ID (not as a pointer) rather than leaving the
>  driver to choose it on create.  Also pass in the ctx, allowing drivers
>  to easily use its private data area to store their hardware-specific
>  state.
> Keep the existing .set_rxfh_context API for now as a fallback, but
>  deprecate it.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
