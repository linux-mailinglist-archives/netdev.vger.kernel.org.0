Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3F713D9E2
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 13:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgAPM0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 07:26:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38036 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgAPM0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 07:26:22 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9AEB515B52F02;
        Thu, 16 Jan 2020 04:26:19 -0800 (PST)
Date:   Thu, 16 Jan 2020 04:26:17 -0800 (PST)
Message-Id: <20200116.042617.270163669922168566.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, jakub.kicinski@netronome.com,
        linyunsheng@huawei.com
Subject: Re: [PATCH net] net: hns3: pad the short frame before sending to
 the hardware
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1579056405-30385-1-git-send-email-tanhuazhong@huawei.com>
References: <1579056405-30385-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 Jan 2020 04:26:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Wed, 15 Jan 2020 10:46:45 +0800

> From: Yunsheng Lin <linyunsheng@huawei.com>
> 
> The hardware can not handle short frames below or equal to 32
> bytes according to the hardware user manual, and it will trigger
> a RAS error when the frame's length is below 33 bytes.
> 
> This patch pads the SKB when skb->len is below 33 bytes before
> sending it to hardware.
> 
> Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

Applied and queued up for -stable.
