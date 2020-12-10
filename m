Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130A02D69ED
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 22:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404976AbgLJVcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 16:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404854AbgLJVbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 16:31:52 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D82C0613D3
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 13:31:11 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id A32F34D2ED6E3;
        Thu, 10 Dec 2020 13:31:10 -0800 (PST)
Date:   Thu, 10 Dec 2020 13:31:10 -0800 (PST)
Message-Id: <20201210.133110.1904824872690353093.davem@davemloft.net>
To:     subashab@codeaurora.org
Cc:     loic.poulain@linaro.org, kuba@kernel.org, netdev@vger.kernel.org,
        stranche@codeaurora.org
Subject: Re: [PATCH net-next] net: qualcomm: rmnet: Update rmnet device MTU
 based on real device
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1607579506-3153-1-git-send-email-subashab@codeaurora.org>
References: <1607579506-3153-1-git-send-email-subashab@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 10 Dec 2020 13:31:10 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Date: Wed,  9 Dec 2020 22:51:46 -0700

> Packets sent by rmnet to the real device have variable MAP header
> lengths based on the data format configured. This patch adds checks
> to ensure that the real device MTU is sufficient to transmit the MAP
> packet comprising of the MAP header and the IP packet. This check
> is enforced when rmnet devices are created and updated and during
> MTU updates of both the rmnet and real device.
> 
> Additionally, rmnet devices now have a default MTU configured which
> accounts for the real device MTU and the headroom based on the data
> format.
> 
> Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

Applied.
