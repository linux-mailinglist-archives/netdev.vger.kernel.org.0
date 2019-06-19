Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7BA74BB78
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 16:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730196AbfFSO3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 10:29:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34976 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfFSO3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 10:29:04 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E11A152474A2;
        Wed, 19 Jun 2019 07:29:03 -0700 (PDT)
Date:   Wed, 19 Jun 2019 10:29:02 -0400 (EDT)
Message-Id: <20190619.102902.987299091903565700.davem@davemloft.net>
To:     ilias.apalodimas@linaro.org
Cc:     jaswinder.singh@linaro.org, netdev@vger.kernel.org,
        ard.biesheuvel@linaro.org, masahisa.kojima@linaro.org
Subject: Re: [net-next, PATCH 2/2, v2] net: netsec: remove loops in napi Rx
 process
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560938641-16778-2-git-send-email-ilias.apalodimas@linaro.org>
References: <1560938641-16778-1-git-send-email-ilias.apalodimas@linaro.org>
        <1560938641-16778-2-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 07:29:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Wed, 19 Jun 2019 13:04:01 +0300

> netsec_process_rx was running in a loop trying to process as many packets
> as possible before re-enabling interrupts. With the recent DMA changes
> this is not needed anymore as we manage to consume all the budget without
> looping over the function.
> Since it has no performance penalty let's remove that and simplify the Rx
> path a bit
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Applied.
