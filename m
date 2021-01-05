Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074462EB65C
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbhAEXmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbhAEXmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 18:42:09 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EAEC061574
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 15:41:29 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id B21D04D87FCF9;
        Tue,  5 Jan 2021 15:41:27 -0800 (PST)
Date:   Tue, 05 Jan 2021 15:41:27 -0800 (PST)
Message-Id: <20210105.154127.1429979284828598550.davem@davemloft.net>
To:     loic.poulain@linaro.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: mhi: Add raw IP mode support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1609232694-10858-1-git-send-email-loic.poulain@linaro.org>
References: <1609232694-10858-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 05 Jan 2021 15:41:27 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>
Date: Tue, 29 Dec 2020 10:04:54 +0100

> MHI net is protocol agnostic, the payload protocol depends on the modem
> configuration, which can be either RMNET (IP muxing and aggregation) or
> raw IP. This patch adds support for incomming IPv4/IPv6 packets, that
> was previously unconditionnaly reported as RMNET packets.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>


Applied to net-next, thanks.
