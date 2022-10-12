Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAA35FC8A8
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 17:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiJLPtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 11:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiJLPtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 11:49:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282A55F9A
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 08:49:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C21BC61540
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 15:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BC9C433D6;
        Wed, 12 Oct 2022 15:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665589778;
        bh=OKkqStktlDGmiWeHcO0P/AI8RcA2AnRbBoqghzigCBE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EW7xrbEvd43T4abihnuUgf/qhmqSonox/rgg76IZB+OxHHuBdc1JvdwgQOuMgTmFs
         xEn0ArF02YILzBqZFfmGQEaX09PXjAUBglpT5E7xShJ/xnw/AmjsddhRwWQ/yYuZoh
         MGILWinKidvLQVST1un5F5P+1ie82f8+rYeVzDqpUsqV8znOulbgejq+IXtGRD/V9Y
         EIb+eni0vrcwbjq+6L7qSBdIaCupQbmdMdlAgPmKwQrr79f24SsyLgp0Y+z6KbJYJ/
         3JL5RxxZ0m7Ehtmhq3soVVB1mjCwoyHpvvtGNj03gkKSRYvm/oovhXIa/v+zWgTlL6
         TIYpnYRPnFz4g==
Date:   Wed, 12 Oct 2022 08:49:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v4 0/3] net: WangXun txgbe ethernet driver
Message-ID: <20221012084936.1533387d@kernel.org>
In-Reply-To: <20221012103533.738954-1-jiawenwu@trustnetic.com>
References: <20221012103533.738954-1-jiawenwu@trustnetic.com>
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

On Wed, 12 Oct 2022 18:35:30 +0800 Jiawen Wu wrote:
> This patch series adds support for WangXun 10 gigabit NIC, to initialize
> hardware, set mac address, and register netdev.

# Form letter - net-next is closed

We have already sent the networking pull request for 6.1
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 6.1-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.

