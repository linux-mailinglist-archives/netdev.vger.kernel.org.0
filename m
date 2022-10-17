Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46E0601707
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 21:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiJQTJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 15:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiJQTJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 15:09:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3115C27CFF
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 12:09:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BB196120F
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 19:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5506DC433C1;
        Mon, 17 Oct 2022 19:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666033788;
        bh=Fu5C9Ly/c1ErezPcK7/ee3AfAgBTQsQP1JHTD1P7d7A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N0k2Zf9+g5CKcOKC/nuL1e5QQULzsZyFpTs0qCXzkhr96UfIZEvFPF4ive3m7u4KK
         xVA6/MaWRwftIQSvekv7NjPHZpJ8MUFBr78oLFeutF3Ut6q//7OmImKSD6aPHLlm95
         VXT4O7W63J1mm4PWe3+z6Q3+MSBc09m3ycHOHTzpJDYtVhr4CCEb3EmmHgv62RvBm/
         dE8d/cgCr19EQOArNR12MHNlWm0fJfvr3W9zSy1dMkzviAYUT9hF5u4kkjSn6k62nE
         0dOJ2haFY4bStdqwr02FLbChB6grCjbiXLDEkGfPsDBNHvqSEnr5m3S+J3aieHfzTr
         FZ3mMQvQxA3Sw==
Date:   Mon, 17 Oct 2022 12:09:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [pull request][net 00/16] mlx5 fixes 2022-10-14
Message-ID: <20221017120947.5d4b1bd6@kernel.org>
In-Reply-To: <20221014234621.304330-1-saeed@kernel.org>
References: <20221014234621.304330-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Oct 2022 16:46:21 -0700 Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> This series provides bug fixes to mlx5 driver.
> Please pull and let me know if there is any problem.

The patches didn't come out? The PR is marked as Accepted in patchwork,
although I don't see it in the tree...
