Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 170F0627750
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236272AbiKNITS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiKNITR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:19:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341B62DD8;
        Mon, 14 Nov 2022 00:19:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E84CFB80D2B;
        Mon, 14 Nov 2022 08:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C204EC433D7;
        Mon, 14 Nov 2022 08:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668413954;
        bh=IpqxtKYy8fB+4tkOtqYyskkSLY6Jq8DjMI40DthW6yU=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=HygpfE4BdeZjIJf/DgPk/N9atO89eZok3ES3ubjhm+uEcDJMxNGnHgaUlP1L0LBdl
         fE7UVxJzBajUqHs2HajwUOLdsdcdG+I/oMqvNRuoml+jPM5mJuIKyKDtC3i7TmaaNa
         v9Y4g63Sjt/IuhTc64S3KqaemKjMVr35NLmSji4N1Bykw3ZucD2wkPqHQvVMCFulcc
         Bq1eq53PclDZEThfDbUct7xcGC+OZa9+JZVkIw7hWPyhuS3qivbTcM40DCV1euO81w
         g9+zvHxyCiFIR3lkixYRKY1SVQDRpyz2Df8xgJt/chJupOt0I2iolL1JgAPRXDsQEw
         Lola4MKO64IoA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Long Li <longli@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, netdev@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Leon Romanovsky <leon@kernel.org>,
        linux-hyperv@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        linux-rdma@vger.kernel.org
In-Reply-To: <3c1e821279e6a165d058655d2343722d6650e776.1668160486.git.leonro@nvidia.com>
References: <3c1e821279e6a165d058655d2343722d6650e776.1668160486.git.leonro@nvidia.com>
Subject: Re: [PATCH rdma-next] RDMA/mana: Remove redefinition of basic u64 type
Message-Id: <166841395000.1334860.9832196394158155110.b4-ty@kernel.org>
Date:   Mon, 14 Nov 2022 10:19:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-87e0e
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Nov 2022 11:55:29 +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> gdma_obj_handle_t is no more than redefinition of basic
> u64 type. Remove such obfuscation.
> 
> 

Applied, thanks!

[1/1] RDMA/mana: Remove redefinition of basic u64 type
      https://git.kernel.org/rdma/rdma/c/3574cfdca28543

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
