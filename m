Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF696E58C3
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 07:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjDRFrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 01:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjDRFrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 01:47:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D9D35A0;
        Mon, 17 Apr 2023 22:47:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20BB562370;
        Tue, 18 Apr 2023 05:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26A4C433D2;
        Tue, 18 Apr 2023 05:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681796859;
        bh=cwWINMYZHYJhJ6/TQLVPs8R3L63amSs21QKY2pKwV38=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=VtRsto4xYAHEvzIrzsovwXU4mFooQHtQr7v6//QPjyhIrGci7HWzKZrd+XPsy9qjo
         vbFxri7rHk9xGW0y+vLTIk47ofZrvRoqDd4TjZfnMxCE5/bHVvlLbEpl5BW3Fvec5R
         TUdBgtjzzgKTdpH9rqV89N3dXmj3SdMgf+DrJR/iKjahdntfPcdxvzKfCLlKDdPDv1
         jBn275jmFzwOxqws8VncfWY4MWRfnoG/PbvBXXeINYyz0K3jsBQy3NlrV8UfO0qyGJ
         PXVFS5Jymk83T1J7fpa4yIGJhnF6xfmCJrwiBftiPhyBkcU9Z8rMe25R7/JDaQY/qA
         /2nKxe7Wqhb+g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc:     Mark Bloch <mbloch@nvidia.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <markb@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>
In-Reply-To: <79d7fbe291690128e44672418934256254d93115.1681377114.git.leon@kernel.org>
References: <79d7fbe291690128e44672418934256254d93115.1681377114.git.leon@kernel.org>
Subject: Re: [PATCH rdma-next v1] RDMA/mlx5: Fix flow counter query via DEVX
Message-Id: <168179685621.10125.9453183353993678119.b4-ty@kernel.org>
Date:   Tue, 18 Apr 2023 08:47:36 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, 13 Apr 2023 12:23:09 +0300, Leon Romanovsky wrote:
> Commit cited in "fixes" tag added bulk support for flow counters but it
> didn't account that's also possible to query a counter using a non-base id
> if the counter was allocated as bulk.
> 
> When a user performs a query, validate the flow counter id given in the
> mailbox is inside the valid range taking bulk value into account.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Fix flow counter query via DEVX
      https://git.kernel.org/rdma/rdma/c/3e358ea8614ddf

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
