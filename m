Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA4EA302EA
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfE3Tkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:40:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59062 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfE3Tkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:40:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7934D14DA936B;
        Thu, 30 May 2019 12:40:51 -0700 (PDT)
Date:   Thu, 30 May 2019 12:40:50 -0700 (PDT)
Message-Id: <20190530.124050.216182444965542776.davem@davemloft.net>
To:     sameehj@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com
Subject: Re: [PATCH V1 net-next 01/11] net: ena: add handling of llq max tx
 burst size
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529095004.13341-2-sameehj@amazon.com>
References: <20190529095004.13341-1-sameehj@amazon.com>
        <20190529095004.13341-2-sameehj@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 12:40:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sameehj@amazon.com>
Date: Wed, 29 May 2019 12:49:54 +0300

>  static inline int ena_com_write_sq_doorbell(struct ena_com_io_sq *io_sq)
>  {
>  	u16 tail = io_sq->tail;
> +	u16 max_entries_in_tx_burst = io_sq->llq_info.max_entries_in_tx_burst;

Reverse christmas tree please.
