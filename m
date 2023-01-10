Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18C26637E7
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 04:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjAJDqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 22:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjAJDqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 22:46:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF135117B
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 19:46:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 42692CE091D
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B197EC433EF;
        Tue, 10 Jan 2023 03:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673322388;
        bh=zY8HYL3kAdk17E6dqD9+bwfiGth7S6djjmSVBECXj+s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UlXKc/BehVabkC3O8Nt5hIr5YUqGDiTNpGzUr5xHq4LEgVueT5oDrtcY8Uw1m/oCC
         7fZ7HEOB1Ldr+p7tHOrl052oLpBsoPW9zwvCeKeKBbqGAaryOv0CjGXbq8F4OL6jo2
         XBusIa2U24UnKc0dVHZLGxl2k0PCrGWh4X6MGL8DZHCRx2xK4hGLhiFyks3f/fw5dY
         1SX99Sv7Gb3Cst83HhjqFc+5wXdYkPRBtU6dpWGHodv4bGZR5EfSPHoiTUANxdwmgV
         X/JvnH1aEc+mXndtW8j5/VJU92OvgxRHMRfySJ2cUlVvt6/XudxguOlvvIcqn0inS2
         A3EhkJFfp+UCQ==
Date:   Mon, 9 Jan 2023 19:46:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <jerinj@marvell.com>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        "Dave Kleikamp" <dave.kleikamp@oracle.com>,
        Henry Willard <henry.willard@oracle.com>
Subject: Re: [PATCH net-next,1/9] octeontx2-af: Fix interrupt name strings
 completely
Message-ID: <20230109194626.6d6fac04@kernel.org>
In-Reply-To: <20230109073603.861043-2-schalla@marvell.com>
References: <20230109073603.861043-1-schalla@marvell.com>
        <20230109073603.861043-2-schalla@marvell.com>
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

On Mon, 9 Jan 2023 13:05:55 +0530 Srujana Challa wrote:
> From: Dave Kleikamp <dave.kleikamp@oracle.com>
> 
> The earlier commit: ("octeontx2-af: Fix interrupt name strings") fixed
>
> one instance of a stack address being saved as if it were static.
> This patch fixes another instance.

This is a fix, fixes need to be posted for net and with the Fixes tag.
