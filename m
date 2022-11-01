Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2359A614E9E
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 16:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiKAPv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 11:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiKAPv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 11:51:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD5D17E04;
        Tue,  1 Nov 2022 08:51:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2342F61584;
        Tue,  1 Nov 2022 15:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECB0C433C1;
        Tue,  1 Nov 2022 15:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667317915;
        bh=4+88DLjvlI3igvKhb5L1IonUQmNERhUeCtjZWJhqOzE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GaYedyTUBkvoSSqQVLGZbGe7lp2SF3UgvxmfqQK5wP92ic4UfGmVVqvO7lTqtviux
         A0mMo3+1UDA2SJCS9e2Q23FxnbM7UJqXz2kefjUH9aOHbo9O3OATb4DRWJsbO32yYn
         K2Uw1JPqlY1FZpsBRce5Wprm/BQ2vCCi+XwazkQxZl3xRV9bWso+Ti19siner96C1P
         E5moscdaMFlrGpEm5cgLsl4VGimajIESc3VlZD4ss3eTErmWrFGjB0ZA8p2FgLIdxl
         lj/MuPFiSTe+plwEHvd2Mi+pdkNnqOMdczlsjbLLrvlb3nk4UBHb2R2VkMmqoQknIJ
         PqQyKYoG/yUnw==
Date:   Tue, 1 Nov 2022 08:51:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        lixiaoyan@google.com, alexanderduyck@fb.com,
        steffen.klassert@secunet.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] gro: avoid checking for a failed search
Message-ID: <20221101085153.12ccae1c@kernel.org>
In-Reply-To: <20221024051744.GA48642@debian>
References: <20221024051744.GA48642@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Oct 2022 07:17:49 +0200 Richard Gobert wrote:
> After searching for a protocol handler in dev_gro_receive, checking for
> failure is redundant. Skip the failure code after finding the 
> corresponding handler.

Why does it matter? You see a measurable perf win?

Please fix the data on your system when you repost.
