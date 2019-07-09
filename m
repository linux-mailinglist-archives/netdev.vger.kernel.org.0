Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67A0563D5A
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 23:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbfGIV3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 17:29:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45892 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGIV3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 17:29:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E7BF01420F59B;
        Tue,  9 Jul 2019 14:29:44 -0700 (PDT)
Date:   Tue, 09 Jul 2019 14:29:44 -0700 (PDT)
Message-Id: <20190709.142944.544358620632880764.davem@davemloft.net>
To:     xiaojiangfeng@huawei.com
Cc:     robh+dt@kernel.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, mark.rutland@arm.com,
        dingtianhong@huawei.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        leeyou.li@huawei.com, nixiaoming@huawei.com,
        jianping.liu@huawei.com, xiekunxun@huawei.com
Subject: Re: [PATCH v2 00/10] net: hisilicon: Add support for HI13X1 to
 hip04_eth
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562643071-46811-1-git-send-email-xiaojiangfeng@huawei.com>
References: <1562643071-46811-1-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 14:29:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Date: Tue, 9 Jul 2019 11:31:01 +0800

> The main purpose of this patch series is to extend the
> hip04_eth driver to support HI13X1_GMAC.
> 
> The offset and bitmap of some registers of HI13X1_GMAC
> are different from hip04_eth common soc. In addition,
> the definition of send descriptor and parsing descriptor
> are different from hip04_eth common soc. So the macro
> of the register offset is redefined to adapt the HI13X1_GMAC.
> 
> Clean up the sparse warning by the way.
> 
> Change since v1:
> * Add a cover letter.

Series applied, thanks.
