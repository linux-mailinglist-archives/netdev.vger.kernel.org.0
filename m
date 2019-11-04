Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43E1DEE8D7
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387420AbfKDTgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:36:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50624 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387401AbfKDTgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:36:02 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B5202151D7255;
        Mon,  4 Nov 2019 11:36:01 -0800 (PST)
Date:   Mon, 04 Nov 2019 11:36:01 -0800 (PST)
Message-Id: <20191104.113601.407489006150341765.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: add missed clk_disable_unprepare in remove
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191104155000.8993-1-hslester96@gmail.com>
References: <20191104155000.8993-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Nov 2019 11:36:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Mon,  4 Nov 2019 23:50:00 +0800

> This driver forgets to disable and unprepare clks when remove.
> Add calls to clk_disable_unprepare to fix it.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Applied.
