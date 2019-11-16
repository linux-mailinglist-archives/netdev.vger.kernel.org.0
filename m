Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF4DFF5A5
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 21:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfKPUyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 15:54:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53662 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfKPUyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 15:54:53 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 47CE61518AA79;
        Sat, 16 Nov 2019 12:54:53 -0800 (PST)
Date:   Sat, 16 Nov 2019 12:54:52 -0800 (PST)
Message-Id: <20191116.125452.1162177656820757922.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: gemini: add missed free_netdev
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191115062454.7025-1-hslester96@gmail.com>
References: <20191115062454.7025-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 12:54:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Fri, 15 Nov 2019 14:24:54 +0800

> This driver forgets to free allocated netdev in remove like
> what is done in probe failure.
> Add the free to fix it.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Applied and queued up for -stable, thank you.
