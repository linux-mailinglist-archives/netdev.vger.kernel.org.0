Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F3D5BED92
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 21:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbiITTXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 15:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbiITTXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 15:23:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4535A419B8;
        Tue, 20 Sep 2022 12:22:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECED7B82CA6;
        Tue, 20 Sep 2022 19:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6162AC433C1;
        Tue, 20 Sep 2022 19:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663701767;
        bh=kfIpyROBoZ8yrJKq+vs/PmB1xO92sG3Xj30E9xJMJ7Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KwXKDptMpumbNkk1+kXEy/9YEDq309IWc4VIcejBE2f+aPnBABLhdrIHdOJbUOJDC
         GMFQiatKjbLRkywoHez+Qx9FyI96J2J7jeaH5knjn4W5qGZ1xUR/12PWDX6uOe340V
         8dXQL8bMAPTplJTafL2ALiHUpLaYxSAvfPe9d1Us0i8/eQMqxGhSHSBqR0IqIKcKV1
         C17KCdp6ekmz0cgyC14B8ANEXSedu7iBc27Wx6n8J31/60TcY7SbcDHVp4kHh5SxQt
         lP8gJ/wIn5V0wV2d9w5tNGkyiHPzAaB6qbHyaOHxPdtBZU+xjfB3LaKH8r1kNt9aj0
         lXs7NBLJA2jOg==
Date:   Tue, 20 Sep 2022 12:22:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH net 0/17] pull-request: can 2022-09-20
Message-ID: <20220920122246.00dbe946@kernel.org>
In-Reply-To: <20220920092915.921613-1-mkl@pengutronix.de>
References: <20220920092915.921613-1-mkl@pengutronix.de>
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

On Tue, 20 Sep 2022 11:28:58 +0200 Marc Kleine-Budde wrote:
> The next 15 patches are by Anssi Hannula and Jimmy Assarsson and fix
> various problem in the kvaser_usb CAN driver.

These are large patches which don't clearly justify the classification
as a fix. Patches 6 and 8 for example leave me asking "what does this
fix?" It's good to report errors, but the absence of error reporting
is not necessarily a bug worthy of stable.

Can we get the commit messages beefed up?
