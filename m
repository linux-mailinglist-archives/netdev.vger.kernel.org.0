Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E9969263A
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbjBJTWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbjBJTWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:22:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5C57164E
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:22:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54DC761DFE
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 19:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD1DC433EF;
        Fri, 10 Feb 2023 19:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676056923;
        bh=OcmdfuNbhpB+vMJRMEpO6uB0TxhkoUp8P4HCr88E6L8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V41zrqoXn46vd2qF3KD2a972MMGkOpuQYZGeqatOPVqGtH+62apSEwUVZIptUR3Xq
         Loi5zO1EfMPpwtxVY+QE15kQP1emjDNoekpx8caKXixMsAiuYPgAylUJWAxoE+37XA
         qAkSGs9RON88M8CWOqSlDKKfjuY128HhiYXe49GdoiafNR99Dwe0+O0PgjxBwFfvgM
         qEDfZGWoBvBXuzjMZyZHqprfWsWEqjC8jJyfZ1RUSkU2rhxKXeu8P+Ur5AUn9mxMxl
         sZOG6iu+aksd7XIl156md4RKKARRMsCvZ3LwiDFM/WTV5rAfMSFtVpTcF4IQ3UWLnw
         gvFd2Il5cLP5Q==
Date:   Fri, 10 Feb 2023 11:22:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Harsh Jain <h.jain@amd.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <thomas.lendacky@amd.com>, <Raju.Rangoju@amd.com>,
        <Shyam-sundar.S-k@amd.com>, <harshjain.prof@gmail.com>,
        <abhijit.gangurde@amd.com>, <puneet.gupta@amd.com>,
        <nikhil.agarwal@amd.com>, <tarak.reddy@amd.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH  0/6] net: ethernet: efct Add x3 ethernet driver
Message-ID: <20230210112202.6a4d6b9f@kernel.org>
In-Reply-To: <20230210130321.2898-1-h.jain@amd.com>
References: <20230210130321.2898-1-h.jain@amd.com>
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

On Fri, 10 Feb 2023 18:33:15 +0530 Harsh Jain wrote:
> This patch series adds new ethernet network driver for Alveo X3522[1].
> X3 is a low-latency NIC with an aim to deliver the lowest possible
> latency. It accelerates a range of diverse trading strategies
> and financial applications.

Please get this reviewed by people within AMD who know something 
about netdev. Ed, Martin, Alejandro, etc.. This driver seems to 
share similarities with SFC and you haven't even CCed them.

This pile a 23kLoC has the same issues the community has been 
raising in reviews of other drivers from your organization.
We don't have the resources to be engaging with badly behaving,
throw-the-code-over-the-wall-open-source vendors.
