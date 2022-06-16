Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C9B54D8A3
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 04:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350610AbiFPCxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 22:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiFPCw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 22:52:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7046552
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 19:52:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C159B82270
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 02:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7799C3411A;
        Thu, 16 Jun 2022 02:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655347976;
        bh=3tnd+CIlkgXeJGO5PJvVzvDhWXSjCqUrZB0TxSNRCuw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E4rOOqMwmymw+EOCLskfCyt2G6+bo+qydp7vqrRjFwzdWRwoEQtBiMJ6oBBnxJx41
         b+ZiOa+TfBAaCtYlZUsc81oU7XYRBAlQV0TV3dK2mlr0+5xTaqFWrt5hxe8/PWc42l
         grr60h5VOvEqd8U4DtAPwjV8d7i/8eyd+AhKtFqbPJ8+QP810+ia1m9ljvYTi2J8Qm
         D+YMKabO1bZy1F8imhXYw+e/3OYEHySuR4/NiAAo2M8mmfKRXkdGrMxCkqtD4cT8BU
         2E477SeGCYhys0D1nimjXm/06cd1h+9LNHxsJVZGcWAalM95j3nyPeAgwNtHS1Fpw1
         18Uj0/COjrPCQ==
Date:   Wed, 15 Jun 2022 19:52:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5] net: txgbe: Add build support for txgbe
Message-ID: <20220615195254.638b0c00@kernel.org>
In-Reply-To: <20220615030430.390304-1-jiawenwu@trustnetic.com>
References: <20220615030430.390304-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jun 2022 11:04:30 +0800 Jiawen Wu wrote:
> Add doc build infrastructure for txgbe driver.
> Initialize PCI memory space for WangXun 10 Gigabit Ethernet devices.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>

Please make it build cleanly with W=1 C=1. See

https://www.kernel.org/doc/html/latest/dev-tools/sparse.html

to understand what C=1 requires.
