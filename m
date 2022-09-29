Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0395EEBDA
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbiI2CgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234320AbiI2Cf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:35:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD079167E9
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 19:35:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79C9861F95
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AE2C433D7;
        Thu, 29 Sep 2022 02:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664418941;
        bh=kqVMICwk08xcdpiRRbqdP+9PgC/pkcquzSrE+FwqLkw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d/sgxnshbFQQE877WJ/5H9N0SgtS33t7wXPfEGkU4IBlILOlgYEgnqf1Q5o5j73Zt
         7SuzJ0GAT0QtotQardeBQN0QBjhXLPDwPlrOUO0EuRlBod9r8APBqCm1itBXbDcsqC
         dz4Ol6zs79wWhGclH/kdQnU1oapsLBzhBf4kbdi2x3duNShXKwzeyKpKV8uDKrxoOP
         bgKwh2z8HjYuBec4KhGF7GKQVMGG8PkUr9ym1+3UZImnvsvXwZCDeybqOV8Msjtnse
         fwUaPdOG8dkpNI3+Pt9pDT9ExH+JBRSx5s/xyb/cO3Dt2wO/7vSmvkUXfRuKwNZkxy
         Shm+mdmmXJ/KQ==
Date:   Wed, 28 Sep 2022 19:35:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [pull request][net-next 00/16] mlx5 updates 2022-09-27
Message-ID: <20220928193540.29445d20@kernel.org>
In-Reply-To: <20220927203611.244301-1-saeed@kernel.org>
References: <20220927203611.244301-1-saeed@kernel.org>
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

On Tue, 27 Sep 2022 13:35:55 -0700 Saeed Mahameed wrote:
> XSK buffer improvements, This is part #1 of 4 parts series.
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

You're missing your s-o-bs in your tree.
I'll apply from the list, you'd have to rebase anyway.
