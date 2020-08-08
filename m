Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218D923F568
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 02:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgHHARf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 20:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgHHARd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 20:17:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68ADCC061A2E;
        Fri,  7 Aug 2020 17:17:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9DC981276B344;
        Fri,  7 Aug 2020 17:00:41 -0700 (PDT)
Date:   Fri, 07 Aug 2020 17:17:24 -0700 (PDT)
Message-Id: <20200807.171724.13170278259787114.davem@davemloft.net>
To:     schalla@marvell.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, schandran@marvell.com,
        pathreya@marvell.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com
Subject: Re: [PATCH v2 0/3] Add Support for Marvell OcteonTX2 Cryptographic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1596809360-12597-1-git-send-email-schalla@marvell.com>
References: <1596809360-12597-1-git-send-email-schalla@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Aug 2020 17:00:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Srujana Challa <schalla@marvell.com>
Date: Fri, 7 Aug 2020 19:39:17 +0530

> The following series adds support for Marvell Cryptographic Acceleration
> Unit(CPT) on OcteonTX2 CN96XX SoC.
> This series is tested with CRYPTO_EXTRA_TESTS enabled and
> CRYPTO_DISABLE_TESTS disabled.

net-next is closed, please do not submit these feature addition changes
until the net-next tree is open again.

Thank you.
