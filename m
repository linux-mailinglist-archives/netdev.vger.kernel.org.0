Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9D5F276B
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfKGFvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:51:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:34308 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfKGFu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:50:59 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2B7B215140754;
        Wed,  6 Nov 2019 21:50:59 -0800 (PST)
Date:   Wed, 06 Nov 2019 21:50:58 -0800 (PST)
Message-Id: <20191106.215058.729629893992439180.davem@davemloft.net>
To:     bianpan2016@163.com
Cc:     tglx@linutronix.de, allison@lohutok.net,
        kstewart@linuxfoundation.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: st21nfca: fix double free
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573090400-23570-1-git-send-email-bianpan2016@163.com>
References: <1573090400-23570-1-git-send-email-bianpan2016@163.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 21:50:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>
Date: Thu,  7 Nov 2019 09:33:20 +0800

> The variable nfcid_skb is not changed in the callee nfc_hci_get_param()
> if error occurs. Consequently, the freed variable nfcid_skb will be
> freed again, resulting in a double free bug. Set nfcid_skb to NULL after
> releasing it to fix the bug.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>

Applied and queued up for -stable.
