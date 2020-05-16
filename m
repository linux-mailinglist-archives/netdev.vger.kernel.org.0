Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFB51D64C6
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 01:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgEPXri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 19:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726670AbgEPXri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 19:47:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3659BC061A0C;
        Sat, 16 May 2020 16:47:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6C85D1272E7E3;
        Sat, 16 May 2020 16:47:37 -0700 (PDT)
Date:   Sat, 16 May 2020 16:47:36 -0700 (PDT)
Message-Id: <20200516.164736.2218916569876451147.davem@davemloft.net>
To:     elder@linaro.org
Cc:     evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: ipa: sc7180 suspend/resume
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200515200731.2931-1-elder@linaro.org>
References: <20200515200731.2931-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 May 2020 16:47:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Fri, 15 May 2020 15:07:29 -0500

> This series permits suspend/resume to work for the IPA driver
> on the Qualcomm SC7180 SoC.  The IPA version on this SoC requires
> interrupts to be enabled when the suspend and resume callbacks are
> made, and the first patch moves away from using the noirq variants.
> The second patch fixes a problem with resume that occurs because
> pending interrupts were being cleared before starting a channel.

Series applied, thanks Alex.
