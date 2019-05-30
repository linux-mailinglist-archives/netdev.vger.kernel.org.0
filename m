Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5333042E
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfE3Vxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:53:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60840 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfE3Vxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:53:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C9F9914DB1C6C;
        Thu, 30 May 2019 14:34:38 -0700 (PDT)
Date:   Thu, 30 May 2019 14:34:38 -0700 (PDT)
Message-Id: <20190530.143438.2168815307729525615.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: sja1105: Make
 static_config_check_memory_size static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529143432.19268-1-yuehaibing@huawei.com>
References: <20190529143432.19268-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 14:34:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Wed, 29 May 2019 22:34:32 +0800

> Fix sparse warning:
> 
> drivers/net/dsa/sja1105/sja1105_static_config.c:446:1: warning:
>  symbol 'static_config_check_memory_size' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
