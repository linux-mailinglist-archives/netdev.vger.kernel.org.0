Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE23563BCB
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 21:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfGITSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 15:18:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44238 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGITSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 15:18:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 46729140246BD;
        Tue,  9 Jul 2019 12:18:41 -0700 (PDT)
Date:   Tue, 09 Jul 2019 12:18:40 -0700 (PDT)
Message-Id: <20190709.121840.2221862332706507841.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        gospo@broadcom.com
Subject: Re: [PATCH net-next] bnxt_en: Add page_pool_destroy() during RX
 ring cleanup.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562658607-30048-1-git-send-email-michael.chan@broadcom.com>
References: <1562658607-30048-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 12:18:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Tue,  9 Jul 2019 03:50:07 -0400

> Add page_pool_destroy() in bnxt_free_rx_rings() during normal RX ring
> cleanup, as Ilias has informed us that the following commit has been
> merged:
> 
> 1da4bbeffe41 ("net: core: page_pool: add user refcnt and reintroduce page_pool_destroy")
> 
> The special error handling code to call page_pool_free() can now be
> removed.  bnxt_free_rx_rings() will always be called during normal
> shutdown or any error paths.
> 
> Fixes: 322b87ca55f2 ("bnxt_en: add page_pool support")
> Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Cc: Andy Gospodarek <gospo@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Applied.
