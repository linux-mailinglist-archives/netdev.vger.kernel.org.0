Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5EA936459
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 21:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfFETOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 15:14:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38478 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbfFETOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 15:14:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E40B71510F003;
        Wed,  5 Jun 2019 12:14:50 -0700 (PDT)
Date:   Wed, 05 Jun 2019 12:14:50 -0700 (PDT)
Message-Id: <20190605.121450.2198491088032558315.davem@davemloft.net>
To:     ivan.khoronzhuk@linaro.org
Cc:     grygorii.strashko@ti.com, hawk@kernel.org, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com
Subject: Re: [PATCH v3 net-next 0/7] net: ethernet: ti: cpsw: Add XDP
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190605132009.10734-1-ivan.khoronzhuk@linaro.org>
References: <20190605132009.10734-1-ivan.khoronzhuk@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 12:14:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Date: Wed,  5 Jun 2019 16:20:02 +0300

> This patchset adds XDP support for TI cpsw driver and base it on
> page_pool allocator. It was verified on af_xdp socket drop,
> af_xdp l2f, ebpf XDP_DROP, XDP_REDIRECT, XDP_PASS, XDP_TX.

Jesper et al., please give this a good once over.

Thank you.
