Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6141820FCA2
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgF3TVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgF3TVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 15:21:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B10C061755;
        Tue, 30 Jun 2020 12:21:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D75F1273208E;
        Tue, 30 Jun 2020 12:21:17 -0700 (PDT)
Date:   Tue, 30 Jun 2020 12:21:14 -0700 (PDT)
Message-Id: <20200630.122114.69420116631257185.davem@davemloft.net>
To:     elder@linaro.org
Cc:     kuba@kernel.org, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: ipa: head-of-line block registers
 are RX only
From:   David Miller <davem@davemloft.net>
In-Reply-To: <825816f3-5797-bbcf-571b-c6a7a6821397@linaro.org>
References: <7c438ee3-8ff0-0ee1-2a0a-fa458d982e11@linaro.org>
        <20200629.180305.1550276438848153234.davem@davemloft.net>
        <825816f3-5797-bbcf-571b-c6a7a6821397@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 12:21:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Mon, 29 Jun 2020 20:09:58 -0500

> But the reason I was
> considering it conditional on a config option is that Qualcomm
> has a crash analysis tool that expects a BUG() call to stop the
> system so its instant state can be captured.  I don't use this
> tool, and I might be mistaken about what's required.

A Qualcomm debugging tool with poorly choosen expectations does not
determine how we do things in the kernel.

> What I would *really* like to do is have a way to gracefully
> shut down just the IPA driver when an unexpected condition occurs,
> so I can stop everything without crashing the system.  But doing
> that in a way that works in all cases is Hard.

Users would like their system and the IPA device to continue, even
if in a reduced functionality manner, if possible.

Doing things to make that less likely to be possible is undesirable.
