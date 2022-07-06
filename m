Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6921A567B12
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 02:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiGFALR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 20:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiGFALQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 20:11:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA25018349
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 17:11:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B2796126B
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 00:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6B3C341C7;
        Wed,  6 Jul 2022 00:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657066274;
        bh=k/6g917rq8chJ5dxpwrRufIL4jTwpCuZn+YAyZsgTxs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jkCPULa26g59TVrLt6hrQDfEYL+YsA/7o+919HpXg3I3ckFXfgdZsB0XPX/NGBBru
         O+0TIWhSjj7dAe8O2dyo5LpUWv6eGbLdP1V8BafLjO9doPXmjxcBGuJ7DhIH3Jnoxt
         MeR89OT3ceeZm651q5MocA6g+vcLzAVai9Y4/TLEGlbIabXZYmxGVPnIiPzn/KhqFA
         S/RnTMHVyyXjJ/hcacR3MMTckpXBx2XcU3afiEKflvrIkORP5cp7PSzcFCTFUUQmy9
         ptR8FYk/36KbliuOFrr32fRGA2g3diwTOD2/5XHe/rIp+I9G+ToIxvsXLjEuVs0Dw4
         n3A4NL4cwdcgg==
Date:   Tue, 5 Jul 2022 17:11:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <saeedm@nvidia.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>, <davem@davemloft.net>,
        <jianbol@nvidia.com>, <idosch@nvidia.com>,
        <xiyou.wangcong@gmail.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <netdev@vger.kernel.org>, <maord@nvidia.com>
Subject: Re: [PATCH net 0/2] Fix police 'continue' action offload
Message-ID: <20220705171113.690109ee@kernel.org>
In-Reply-To: <20220704204405.2563457-1-vladbu@nvidia.com>
References: <20220704204405.2563457-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Jul 2022 22:44:03 +0200 Vlad Buslov wrote:
> TC act_police with 'continue' action had been supported by mlx5 matchall
> classifier offload implementation for some time. However, 'continue' was
> assumed implicitly and recently got broken in multiple places. Fix it in
> both TC hardware offload validation code and mlx5 driver.

Saeed, ack or should they go via your tree? 

The signals are a little mixed since the tree in the subject is "net"
which makes sense but there's no ack / sob from Saeed.
