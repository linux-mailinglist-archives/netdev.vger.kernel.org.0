Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 735AA60DCA
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 00:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbfGEW2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 18:28:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43524 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbfGEW2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 18:28:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 74DAE150420B4;
        Fri,  5 Jul 2019 15:28:09 -0700 (PDT)
Date:   Fri, 05 Jul 2019 15:28:08 -0700 (PDT)
Message-Id: <20190705.152808.1175306947779966525.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     jaswinder.singh@linaro.org, ast@kernel.org,
        ilias.apalodimas@linaro.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3 net-next] net: socionext: remove set but not used
 variable 'pkts'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190704033745.1758-1-yuehaibing@huawei.com>
References: <20190704032129.169282-1-yuehaibing@huawei.com>
        <20190704033745.1758-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jul 2019 15:28:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 4 Jul 2019 03:37:45 +0000

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ethernet/socionext/netsec.c: In function 'netsec_clean_tx_dring':
> drivers/net/ethernet/socionext/netsec.c:637:15: warning:
>  variable 'pkts' set but not used [-Wunused-but-set-variable]
> 
> It is not used since commit ba2b232108d3 ("net: netsec: add XDP support")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Applied to net-next.
