Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2F5569D7C0
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 01:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbjBUAvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 19:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbjBUAvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 19:51:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16AB1E1D8
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 16:51:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56E5B60F47
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 00:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B45EC433D2;
        Tue, 21 Feb 2023 00:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676940698;
        bh=wrXZYparJzG7oC8U0UKQeO/l9qdUMHa4jMikGJhwcwc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BZSSTFTQO5Jel/46Cp86LfpYOiedM6o6Q5ugpFcCWMNkygAiR610tii/+9ZUIeKBI
         9OlKYj1YdJprZsRlblmT5gmtvayPcnLyJ6KrIxelAsZOraOL5kVy2wRU9YwQvFBg1m
         2kTbsePxNaSsK/F+H4ujmYqgg2GjpnSreBDwE7gliIwIZJpzRXTXuDsa3oq4T5ljDs
         B2vruEWnFug2ACPf6bvWPhiqJh9I8+H6mknJSN0oegaYLXTw9Jpqwo/Qp1RsHMwCAg
         WtnujPWVzlraGYPsqgEzPhTsuKQg7e9Yu1OEaEBeZ1cT4SHo1eR4pC3tdUKXxlpCT7
         RQeWM88oACDsw==
Date:   Mon, 20 Feb 2023 16:51:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next 00/14] mlx5 dynamic msix
Message-ID: <20230220165137.7667715b@kernel.org>
In-Reply-To: <20230220061442.403092-1-saeed@kernel.org>
References: <20230220061442.403092-1-saeed@kernel.org>
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

On Sun, 19 Feb 2023 22:14:28 -0800 Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> This patch series adds support for dynamic msix vectors allocation in mlx5.

A bit too late, sorry :(
