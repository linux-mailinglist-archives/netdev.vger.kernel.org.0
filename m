Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E035413D696
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 10:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgAPJRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 04:17:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36508 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgAPJRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 04:17:13 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0EBE615B203EF;
        Thu, 16 Jan 2020 01:17:10 -0800 (PST)
Date:   Thu, 16 Jan 2020 01:17:08 -0800 (PST)
Message-Id: <20200116.011708.119845983010961103.davem@davemloft.net>
To:     blackgod016574@gmail.com
Cc:     tglx@linutronix.de, alexios.zavras@intel.com, allison@lohutok.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: nfc: Removing unnecessaey code in
 nci_open_device()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200116025204.GA20032@hunterzg-yangtiant6900c-00>
References: <20200116025204.GA20032@hunterzg-yangtiant6900c-00>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 Jan 2020 01:17:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gen Zhang <blackgod016574@gmail.com>
Date: Thu, 16 Jan 2020 10:52:04 +0800

> In nci_open_device(), since we already call clear_bit(), so set ndev->flags
> to 0 is not needed.
> 
> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>

There are several bits in this flags value, not just the one managed
here in this function (NCI_INIT).

This assignment is harmless and makes the code easier to audit,
therefore I am not applying this patch.
