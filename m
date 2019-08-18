Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C52C1919A0
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 23:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfHRVCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 17:02:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49136 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbfHRVCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 17:02:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 50DC1145BF67A;
        Sun, 18 Aug 2019 14:02:23 -0700 (PDT)
Date:   Sun, 18 Aug 2019 14:02:22 -0700 (PDT)
Message-Id: <20190818.140222.1089520558303497828.davem@davemloft.net>
To:     stephen@networkplumber.org
Cc:     yuehaibing@huawei.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: cavium: fix driver name
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190815194949.10630-1-stephen@networkplumber.org>
References: <20190815194949.10630-1-stephen@networkplumber.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 Aug 2019 14:02:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Thu, 15 Aug 2019 12:49:49 -0700

> The driver name gets exposed in sysfs under /sys/bus/pci/drivers
> so it should look like other devices. Change it to be common
> format (instead of "Cavium PTP").
> 
> This is a trivial fix that was observed by accident because
> Debian kernels were building this driver into kernel (bug).
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

Applied.
