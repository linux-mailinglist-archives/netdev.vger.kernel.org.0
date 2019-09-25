Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B48BDD96
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 14:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405226AbfIYMA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 08:00:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34892 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405217AbfIYMA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 08:00:26 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B9F5D100A1EF2;
        Wed, 25 Sep 2019 05:00:24 -0700 (PDT)
Date:   Wed, 25 Sep 2019 14:00:23 +0200 (CEST)
Message-Id: <20190925.140023.901609288912735040.davem@davemloft.net>
To:     shubhrajyoti.datta@xilinx.com
Cc:     netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        shubhrajyoti.datta@gmail.com
Subject: Re: [RFC PATCH] net: macb: Remove dead code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1569226782-19635-1-git-send-email-shubhrajyoti.datta@xilinx.com>
References: <1569226782-19635-1-git-send-email-shubhrajyoti.datta@xilinx.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Sep 2019 05:00:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Date: Mon, 23 Sep 2019 13:49:42 +0530

> macb_64b_desc is always called when HW_DMA_CAP_64B is defined.
> So the return NULL can never be reached. Remove the dead code.
> 
> Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>

Applied.
