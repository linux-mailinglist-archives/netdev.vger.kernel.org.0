Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11425ED213
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 02:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbiI1AiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 20:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbiI1AiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 20:38:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A93011267D
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 17:38:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A69F4B81E6D
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 00:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21322C433D6;
        Wed, 28 Sep 2022 00:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664325491;
        bh=eTBs14Kitj2NXDAUfuciY+zuxiz9TzLNB3Ejti5LzEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jpSQyKB7c2efmcwgK7BtH+bB8oTAq7j07xfW2qflW25vjJb3llwZtB0BxvBGCkJ2d
         AN1puRwpehoGVlT0Pa/lTDrYESHVZ4UMd7vG5TWkJ7Y/UTbMFmq4QGmbAQLsOVq3mH
         qouT8o6xjecDL5fLINjR43dd5pA8cJf9LqKcqKlHvhsu9OfBMQ65GRHvEjYTa4b+ii
         Fu+WTZ4g9olMn4Yrk8ZGFZ3QCgzWDdhTBISmC6JlzEwH2lQIugcYu/8fqcfhxnpm8/
         F+S5Sqwud/Phe8vhvZbqK0ExoGUBn4l5dBFwBmUpfkG3Z3PhXswMZiPuQyTfZMBqt8
         yRB9PwgqeOarA==
Date:   Tue, 27 Sep 2022 17:38:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chunhao Lin <hau@realtek.com>
Cc:     <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <nic_swsd@realtek.com>
Subject: Re: [PATCH net-next] r8169: add rtl_disable_rxdvgate()
Message-ID: <20220927173810.6caad4f3@kernel.org>
In-Reply-To: <20220926074813.3619-1-hau@realtek.com>
References: <20220926074813.3619-1-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Sep 2022 15:48:13 +0800 Chunhao Lin wrote:
> rtl_disable_rxdvgate() is used for disable RXDV_GATE.
> It is opposite function of rtl_enable_rxdvgate().

You should mention that you're dropping the udelay() and
if you know why it was there in the first place - why it's
no longer needed.
