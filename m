Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B85917D8B5
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 06:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgCIFEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 01:04:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54182 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCIFEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 01:04:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4BFE6158B8427;
        Sun,  8 Mar 2020 22:04:04 -0700 (PDT)
Date:   Sun, 08 Mar 2020 22:04:03 -0700 (PDT)
Message-Id: <20200308.220403.2013988891795466479.davem@davemloft.net>
To:     bay@hackerdom.ru
Cc:     oliver@neukum.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
        info@metux.net, allison@lohutok.net, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cdc_ncm: Implement the 32-bit version of NCM Transfer
 Block
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200305203318.8980-1-bay@hackerdom.ru>
References: <20200305203318.8980-1-bay@hackerdom.ru>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 08 Mar 2020 22:04:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Bersenev <bay@hackerdom.ru>
Date: Fri,  6 Mar 2020 01:33:16 +0500

> The NCM specification defines two formats of transfer blocks: with 16-bit
> fields (NTB-16) and with 32-bit fields (NTB-32). Currently only NTB-16 is
> implemented.
> 
> This patch adds the support of NTB-32. The motivation behind this is that
> some devices such as E5785 or E5885 from the current generation of Huawei
> LTE routers do not support NTB-16. The previous generations of Huawei
> devices are also use NTB-32 by default.
> 
> Also this patch enables NTB-32 by default for Huawei devices.
> 
> During the 2019 ValdikSS made five attempts to contact Huawei to add the
> NTB-16 support to their router firmware, but they were unsuccessful.
> 
> Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>

Oliver et al., please review.

Thank you.
