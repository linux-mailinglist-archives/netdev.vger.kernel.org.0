Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2171FBBB6
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 23:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfKMWic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 17:38:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39432 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfKMWib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 17:38:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 06C55128F3876;
        Wed, 13 Nov 2019 14:38:30 -0800 (PST)
Date:   Wed, 13 Nov 2019 14:38:30 -0800 (PST)
Message-Id: <20191113.143830.141205006149266294.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     oliver@neukum.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: cdc_ncm: Signedness bug in
 cdc_ncm_set_dgram_size()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191113182831.yjbmhwacirh6kgzr@kili.mountain>
References: <20191113182831.yjbmhwacirh6kgzr@kili.mountain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 Nov 2019 14:38:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 13 Nov 2019 21:28:31 +0300

> This code is supposed to test for negative error codes and partial
> reads, but because sizeof() is size_t (unsigned) type then negative
> error codes are type promoted to high positive values and the condition
> doesn't work as expected.
> 
> Fixes: 332f989a3b00 ("CDC-NCM: handle incomplete transfer of MTU")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
