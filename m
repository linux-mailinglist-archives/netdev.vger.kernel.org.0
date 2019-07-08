Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F9A628DC
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390012AbfGHTBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:01:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56546 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389848AbfGHTBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:01:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF038133E97B7;
        Mon,  8 Jul 2019 12:01:07 -0700 (PDT)
Date:   Mon, 08 Jul 2019 12:00:54 -0700 (PDT)
Message-Id: <20190708.120054.345281811995965751.davem@davemloft.net>
To:     ilias.apalodimas@linaro.org
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org
Subject: Re: [PATCH] net: netsec: Sync dma for device on buffer allocation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562570741-25108-1-git-send-email-ilias.apalodimas@linaro.org>
References: <1562570741-25108-1-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 12:01:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Mon,  8 Jul 2019 10:25:41 +0300

> cd1973a9215a ("net: netsec: Sync dma for device on buffer allocation")
> was merged on it's v1 instead of the v3.
> Merge the proper patch version
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Applied to net-next, thanks.
