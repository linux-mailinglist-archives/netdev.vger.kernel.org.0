Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD825C0096
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 17:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiIUPAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 11:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiIUPAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 11:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694DECD9
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 07:59:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 048CC62BB2
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 14:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35E7C433D6;
        Wed, 21 Sep 2022 14:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663772369;
        bh=IiSFUttt6EEGTDVJvnsGTcJVEaol+CZw/CqPSBPtsVI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VkDarSLQ0S4xlTgdaPVD0JCsaFSJM9DmdcI3P7UOJaHvcmTwQwJ+U/hhXFuWYp8oH
         9fh3teMWYFJ/9AUCm0vo/sXJ15VFd3R/bnIILwR2RZp0M+jDS0YDIRzEWcTbi1o0vY
         LYi/SLxRJRrSoclVxQym8zkqQY3YcMV3h6m+8yEb4aOoTCPoCUX2zPpWQhOusI/pgb
         8bKWZM9gxm29/P4EBql1Y1jbyr/nW5ACXiPyBpB8Y7FS+/NX6Hoh6Zv3Wzq0thqajm
         ZEAizwMH46ivYfx7a7tFwg0eG6a4fJntVQ99/8DisXttd6jqgPgAZkaM1iRMPu37Pa
         J1Y7Pvik3Yr6g==
Date:   Wed, 21 Sep 2022 07:59:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 0/8] Extend XFRM core to allow full
 offload configuration
Message-ID: <20220921075927.3ace0307@kernel.org>
In-Reply-To: <Yxm8QFvtMcpHWzIy@unreal>
References: <cover.1662295929.git.leonro@nvidia.com>
        <Yxm8QFvtMcpHWzIy@unreal>
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

On Thu, 8 Sep 2022 12:56:16 +0300 Leon Romanovsky wrote:
> I have TX traces too and can add if RX are not sufficient. 

The perf trace is good, but for those of us not intimately familiar
with xfrm, could you provide some analysis here?
