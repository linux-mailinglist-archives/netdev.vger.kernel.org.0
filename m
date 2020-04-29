Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BD61BE66D
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgD2Sl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726481AbgD2Sl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 14:41:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4BAC03C1AE;
        Wed, 29 Apr 2020 11:41:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E6951210A3E3;
        Wed, 29 Apr 2020 11:41:57 -0700 (PDT)
Date:   Wed, 29 Apr 2020 11:41:53 -0700 (PDT)
Message-Id: <20200429.114153.1436315951603745606.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, kuba@kernel.org, liuyonglong@huawei.com
Subject: Re: [PATCH V2] net: hns3: adds support for reading module eeprom
 info
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1588131984-27468-1-git-send-email-tanhuazhong@huawei.com>
References: <1588131984-27468-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Apr 2020 11:41:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Wed, 29 Apr 2020 11:46:24 +0800

> From: Yonglong Liu <liuyonglong@huawei.com>
> 
> This patch adds support for reading the optical module eeprom
> info via "ethtool -m".
> 
> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> ---
> V2: replace self-defined macro with the SFF8024_ID_* in sfp.h
>     suggested by Jakub Kicinski.

Applied to net-next, thanks.
