Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0033B9A3C5
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390375AbfHVXXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:23:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50602 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730029AbfHVXXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 19:23:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF6051539DF80;
        Thu, 22 Aug 2019 16:23:39 -0700 (PDT)
Date:   Thu, 22 Aug 2019 16:23:39 -0700 (PDT)
Message-Id: <20190822.162339.831735149510227752.davem@davemloft.net>
To:     Markus.Elfring@web.de
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        intel-wired-lan@lists.osuosl.org,
        bcm-kernel-feedback-list@broadcom.com,
        UNGLinuxDriver@microchip.com, alexandre.torgue@st.com,
        alexios.zavras@intel.com, allison@lohutok.net,
        bryan.whitehead@microchip.com, claudiu.manoil@nxp.com,
        opendmb@gmail.com, dougmill@linux.ibm.com, f.fainelli@gmail.com,
        peppe.cavallaro@st.com, gregkh@linuxfoundation.org,
        jeffrey.t.kirsher@intel.com, opensource@jilayne.com,
        jonathan.lemon@gmail.com, joabreu@synopsys.com,
        kstewart@linuxfoundation.org, mcgrof@kernel.org,
        mcoquelin.stm32@gmail.com, michael.heimpold@i2se.com,
        nico@fluxnic.net, ynezz@true.cz, shannon.nelson@oracle.com,
        stefan.wahren@i2se.com, swinslow@gmail.com, tglx@linutronix.de,
        weiyongjun1@huawei.com, wsa+renesas@sang-engineering.com,
        yang.wei9@zte.com.cn, yuehaibing@huawei.com, zhongjiang@huawei.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ethernet: Delete unnecessary checks before the macro
 call =?iso-2022-jp?B?GyRCIUgbKEJkZXZfa2ZyZWVfc2tiGyRCIUkbKEI=?=
From:   David Miller <davem@davemloft.net>
In-Reply-To: <af1ae1cf-4a01-5e3a-edc2-058668487137@web.de>
References: <af1ae1cf-4a01-5e3a-edc2-058668487137@web.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 16:23:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <Markus.Elfring@web.de>
Date: Thu, 22 Aug 2019 20:30:15 +0200

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 22 Aug 2019 20:02:56 +0200
> 
> The dev_kfree_skb() function performs also input parameter validation.
> Thus the test around the shown calls is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Applied.
