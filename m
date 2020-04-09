Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE5C1A3658
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 16:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgDIOzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 10:55:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59988 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbgDIOzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 10:55:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 23F6D127BCFF8;
        Thu,  9 Apr 2020 07:55:39 -0700 (PDT)
Date:   Thu, 09 Apr 2020 07:55:35 -0700 (PDT)
Message-Id: <20200409.075535.443174339328548481.davem@davemloft.net>
To:     wenhu.wang@vivo.com
Cc:     akpm@linux-foundation.org, kuba@kernel.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        bjorn.andersson@linaro.org, hofrat@osadl.org, allison@lohutok.net,
        johannes.berg@intel.com, arnd@arndb.de, cjhuang@codeaurora.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel@vivo.com
Subject: Re: [PATCH RESEND] net: qrtr: support qrtr service and lookup route
From:   David Miller <davem@davemloft.net>
In-Reply-To: <AO2AwwA*CAWlXsmj18xkSqo6.3.1586405936469.Hmail.wenhu.wang@vivo.com>
References: <20200408.143327.2268546094613330028.davem@davemloft.net>
        <AO2AwwA*CAWlXsmj18xkSqo6.3.1586405936469.Hmail.wenhu.wang@vivo.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Apr 2020 07:55:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: 王文虎 <wenhu.wang@vivo.com>
Date: Thu, 9 Apr 2020 12:18:56 +0800 (GMT+08:00)

> See. And seems like the v5.7-rc1 is probably to be released next monday or so.
> I will send a new patch taged with [PATCH net-next] then.

-rc1 being released does not mean that net-next is open.

I explicitly open net-next at the appropriate time and announce it
here on the list, and also the state of net-next is at:

	http://vger.kernel.org/~davem/net-next.html

Thank you.
