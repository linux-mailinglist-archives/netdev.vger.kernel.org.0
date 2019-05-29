Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF832E60D
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 22:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfE2U1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 16:27:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41288 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfE2U1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 16:27:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9B27614A6BDA8;
        Wed, 29 May 2019 13:27:19 -0700 (PDT)
Date:   Wed, 29 May 2019 13:27:19 -0700 (PDT)
Message-Id: <20190529.132719.1367123786586447390.davem@davemloft.net>
To:     Jisheng.Zhang@synaptics.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: use dev_info() before netdev is
 registered
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190528145253.21b8abbc@xhacker.debian>
References: <20190528145253.21b8abbc@xhacker.debian>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 May 2019 13:27:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Date: Tue, 28 May 2019 07:02:07 +0000

> Before the netdev is registered, calling netdev_info() will emit
> something as "(unnamed net device) (uninitialized)", looks confusing.
> 
> Before this patch:
> [    3.155028] stmmaceth f7b60000.ethernet (unnamed net_device) (uninitialized): device MAC address 52:1a:55:18:9e:9d
> 
> After this patch:
> [    3.155028] stmmaceth f7b60000.ethernet: device MAC address 52:1a:55:18:9e:9d
> 
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

Applied.
