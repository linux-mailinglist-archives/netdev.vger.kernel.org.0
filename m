Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05DBF15AF2D
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 18:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgBLRzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 12:55:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33600 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbgBLRzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 12:55:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5DE2113B3AC2A;
        Wed, 12 Feb 2020 09:55:22 -0800 (PST)
Date:   Wed, 12 Feb 2020 09:55:21 -0800 (PST)
Message-Id: <20200212.095521.599546777045445297.davem@davemloft.net>
To:     hayashi.kunihiko@socionext.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        masami.hiramatsu@linaro.org, jaswinder.singh@linaro.org
Subject: Re: [PATCH net v2] net: ethernet: ave: Add capability of rgmii-id
 mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1581504934-19540-1-git-send-email-hayashi.kunihiko@socionext.com>
References: <1581504934-19540-1-git-send-email-hayashi.kunihiko@socionext.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Feb 2020 09:55:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Date: Wed, 12 Feb 2020 19:55:34 +0900

> This allows you to specify the type of rgmii-id that will enable phy
> internal delay in ethernet phy-mode.
> 
> This adds all RGMII cases to all of get_pinmode() except LD11, because LD11
> SoC doesn't support RGMII due to the constraint of the hardware. When RGMII
> phy mode is specified in the devicetree for LD11, the driver will abort
> with an error.
> 
> Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> ---
> Changes since v1:
> - Add description about LD11 to the commit message

Applied, thank you.
