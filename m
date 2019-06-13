Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8869E44DF1
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 22:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730060AbfFMU7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 16:59:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60142 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728543AbfFMU7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 16:59:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A99C2149B0A3E;
        Thu, 13 Jun 2019 13:59:16 -0700 (PDT)
Date:   Thu, 13 Jun 2019 13:59:13 -0700 (PDT)
Message-Id: <20190613.135913.137368160395815937.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: sja1105: Make two functions static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190611135834.21080-1-yuehaibing@huawei.com>
References: <20190611135834.21080-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Jun 2019 13:59:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 11 Jun 2019 21:58:34 +0800

> Fix sparse warnings:
> 
> drivers/net/dsa/sja1105/sja1105_main.c:1848:6:
>  warning: symbol 'sja1105_port_rxtstamp' was not declared. Should it be static?
> drivers/net/dsa/sja1105/sja1105_main.c:1869:6:
>  warning: symbol 'sja1105_port_txtstamp' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
