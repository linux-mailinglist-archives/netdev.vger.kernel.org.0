Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64CB299F37
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 20:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391142AbfHVSwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 14:52:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47116 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387460AbfHVSwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 14:52:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 449921533FE79;
        Thu, 22 Aug 2019 11:52:46 -0700 (PDT)
Date:   Thu, 22 Aug 2019 11:52:43 -0700 (PDT)
Message-Id: <20190822.115243.1891232287056279825.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: saving the settings of EEE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-304-Taiwan-albertk@realtek.com>
References: <1394712342-15778-304-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 11:52:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 22 Aug 2019 16:07:18 +0800

> +	if (tp->eee_en) {
> +		r8152_eee_en(tp, true);
> +		r8152_mmd_write(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV, tp->eee_adv);
> +	} else {
> +		r8152_eee_en(tp, false);
> +		r8152_mmd_write(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0);
> +	}

I see this same exact code sequence at least 4 times in your patch, please
make a helper function.
