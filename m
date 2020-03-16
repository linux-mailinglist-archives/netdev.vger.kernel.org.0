Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 767A018754F
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 23:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732766AbgCPWES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 18:04:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48548 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732709AbgCPWER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 18:04:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C9A10156D3FE7;
        Mon, 16 Mar 2020 15:04:16 -0700 (PDT)
Date:   Mon, 16 Mar 2020 15:04:16 -0700 (PDT)
Message-Id: <20200316.150416.703162062113777580.davem@davemloft.net>
To:     wei.zheng@vivo.com
Cc:     catalin.marinas@arm.com, will@kernel.org, jdmason@kudzu.us,
        yeyunfeng@huawei.com, guohanjun@huawei.com, tglx@linutronix.de,
        info@metux.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel@vivo.com, wenhu.wang@vivo.com
Subject: Re: [PATCH] net: vxge: fix wrong __VA_ARGS__ usage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200316142354.95201-1-wei.zheng@vivo.com>
References: <20200316142354.95201-1-wei.zheng@vivo.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 15:04:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Wei <wei.zheng@vivo.com>
Date: Mon, 16 Mar 2020 22:23:47 +0800

> printk in macro vxge_debug_ll uses __VA_ARGS__ without "##" prefix,
> it causes a build error when there is no variable 
> arguments(e.g. only fmt is specified.).
> 
> Signed-off-by: Zheng Wei <wei.zheng@vivo.com>

Does this even happen right now?  Anyways, applied.
