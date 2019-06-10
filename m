Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9739A3B9B6
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387691AbfFJQie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:38:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58304 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728164AbfFJQid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:38:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1CD88150640A1;
        Mon, 10 Jun 2019 09:38:32 -0700 (PDT)
Date:   Mon, 10 Jun 2019 09:38:30 -0700 (PDT)
Message-Id: <20190610.093830.1398717949744756291.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, dwmw@amazon.com,
        zorik@amazon.com, matua@amazon.com, saeedb@amazon.com,
        msw@amazon.com, aliguori@amazon.com, nafea@amazon.com,
        gtzalik@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, akiyano@amazon.com
Subject: Re: [PATCH V2 net-next 4/6] net: ena: allow queue allocation
 backoff when low on memory
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190610163659.GL28724@lunn.ch>
References: <20190610111918.21397-5-sameehj@amazon.com>
        <20190610.091840.690511717716268814.davem@davemloft.net>
        <20190610163659.GL28724@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Jun 2019 09:38:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Mon, 10 Jun 2019 18:36:59 +0200

> On Mon, Jun 10, 2019 at 09:18:40AM -0700, David Miller wrote:
>> From: <sameehj@amazon.com>
>> Date: Mon, 10 Jun 2019 14:19:16 +0300
>> 
>> > +static inline void set_io_rings_size(struct ena_adapter *adapter,
>> > +				     int new_tx_size, int new_rx_size)
>> 
>> Please do not ever use inline in foo.c files, let the compiler decide.
> 
> Hi David
> 
> It looks like a few got passed review:

I know :-/
