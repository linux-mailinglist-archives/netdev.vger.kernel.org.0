Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAEB4F20BA
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 04:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiDEB1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 21:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiDEB11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 21:27:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6D428E355;
        Mon,  4 Apr 2022 17:39:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D5036178D;
        Tue,  5 Apr 2022 00:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316ADC2BBE4;
        Tue,  5 Apr 2022 00:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649118903;
        bh=TUQDwA5oUvOfBLmcRPZvF7xp3TjIfEeV0e2XgtHJnNA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bBOBsxplszIf67QVQqJ2EwfPQE2M++fqNb0Yd9NSZYsD64yfsVRI23HkorAj44+/6
         nN+8zCrCS2N+vShsAajbtP5upMOvbtN7SkmdAYGWSlPTNztsXnQE2KJUsVH4D7J0lS
         s2Pgn358HZklqe2q+sb6ghbMuRuyDOoy2UdYW1LaQHWx1yGYIPGmaqP69+myVoXqua
         CCAmqKxbHH0ccC/Mrv2Voa/pyGHRIjR07f8okE6r+1ycyX3pYjXQVmkAYx5+76+8NY
         eN6UNZj6YYvg8gmoNie2mSf0ek8etHckuc6FGyiImZC9HN6Zv8GIhX8eEBgcV1lIp1
         equbS+z19xUwg==
Date:   Mon, 4 Apr 2022 17:35:00 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH mlx5-next 0/5] Drop Mellanox FPGA TLS support from the
 kernel
Message-ID: <20220405003500.duivahirienxrkuk@sx1>
References: <cover.1649073691.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <cover.1649073691.git.leonro@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04 Apr 15:08, Leon Romanovsky wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>Mellanox INNOVA TLS cards are EOL in May, 2018 [1]. As such, the code
>is unmaintained, untested and not in-use by any upstream/distro oriented
>customers. In order to reduce code complexity, drop the kernel code,
>clean build config options and delete useless kTLS vs. TLS separation.
>
>[1] https://network.nvidia.com/related-docs/eol/LCR-000286.pdf
>
>Thanks
>
>BTW, the target of this series is mlx5-next, as other series removes
>FPGA IPsec together with relevant cleanup in RDMA side.
>

Other than the renaming ktls => tls comment, which is not a big deal
anyhow. The series looks great.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com> 

