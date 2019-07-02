Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 563785C759
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 04:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfGBC3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 22:29:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54200 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfGBC3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 22:29:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D1A4B14DEC5E9;
        Mon,  1 Jul 2019 19:29:46 -0700 (PDT)
Date:   Mon, 01 Jul 2019 19:29:46 -0700 (PDT)
Message-Id: <20190701.192946.619458933774688152.davem@davemloft.net>
To:     hariprasad.kelam@gmail.com
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, gregkh@linuxfoundation.org, yuehaibing@huawei.com,
        tglx@linutronix.de, mcgrof@kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: broadcom: bcm63xx_enet: Remove unneeded
 memset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190630142949.GA7422@hari-Inspiron-1545>
References: <20190630142949.GA7422@hari-Inspiron-1545>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 19:29:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Date: Sun, 30 Jun 2019 19:59:49 +0530

> Remove unneeded memset as alloc_etherdev is using kvzalloc which uses
> __GFP_ZERO flag
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>

Applied to net-next, thanks.
