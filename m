Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62982640DB1
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbiLBSou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234635AbiLBSn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:43:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33BAAE4FF
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 10:42:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E84262396
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 18:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75179C433D6;
        Fri,  2 Dec 2022 18:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670006575;
        bh=DbcLeJ309mE2FIrtsNoXWG0hMdQWCm9MLdecI5p8O4c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NQFHbkUzjvXXLuvH2h2W3H7QZjJqEcqchW5xzcFxRx1jvqYXZn8edRIAta/V+FF/+
         p5SIb95djulEQzCH+N/hZsnBv21oVWGhecpYHfcamypfEaiYgDaWVC7k+VgiuPbbTA
         uxc64B6EN+FB4VqDn7Dc4UTlkv3vM40ZX4f1iPk7bxYh8oY1c/nEgSQerBzOZMmT0f
         ZNWxivC8I9jMwvzO77nUEZCosuLBtTia7QNqj9PecD0b8Rbvvix7gXNAuDVWHjTMVf
         kTG1zrhaGxS16LSat5Fg+CWxy+7XUbpX6o8mQrFqgJdLfm9Fd7iN7fEYx5yWApytbu
         JOouFPDPqpCow==
Date:   Fri, 2 Dec 2022 10:42:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Drory <shayd@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: Re: [PATCH net-next V2 2/8] devlink: Validate port function request
Message-ID: <20221202104254.0e7a2d34@kernel.org>
In-Reply-To: <20221202082622.57765-3-shayd@nvidia.com>
References: <20221202082622.57765-1-shayd@nvidia.com>
        <20221202082622.57765-3-shayd@nvidia.com>
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

On Fri, 2 Dec 2022 10:26:16 +0200 Shay Drory wrote:
> +		NL_SET_ERR_MSG_MOD(extack, "Port doesn't support function attributes");

NL_SET_ERR_MSG_ATTR(), please
