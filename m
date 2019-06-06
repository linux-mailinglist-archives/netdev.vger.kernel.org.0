Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C545437C5E
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 20:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbfFFShF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 14:37:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55598 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfFFShF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 14:37:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7648014DE4E27;
        Thu,  6 Jun 2019 11:37:04 -0700 (PDT)
Date:   Thu, 06 Jun 2019 11:37:04 -0700 (PDT)
Message-Id: <20190606.113704.124662408950162788.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: mscc: ocelot: remove unused variable
 'vcap_data_t'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190606144649.21368-1-yuehaibing@huawei.com>
References: <20190606144649.21368-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 11:37:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 6 Jun 2019 22:46:49 +0800

> Fix sparse warning:
> 
> drivers/net/ethernet/mscc/ocelot_ace.c:96:3:
>  warning: symbol 'vcap_data_t' was not declared. Should it be static?
> 
> 'vcap_data_t' never used so can be removed
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.  I am pretty sure this was meant to be a typedef.
