Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAF43B7884
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 13:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389895AbfISLcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 07:32:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55150 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388181AbfISLcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 07:32:55 -0400
Received: from localhost (unknown [86.58.254.34])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AB563154FB2DF;
        Thu, 19 Sep 2019 04:32:52 -0700 (PDT)
Date:   Thu, 19 Sep 2019 13:32:50 +0200 (CEST)
Message-Id: <20190919.133250.1851009450153650293.davem@davemloft.net>
To:     poeschel@lemonage.de
Cc:     swinslow@gmail.com, tglx@linutronix.de,
        kstewart@linuxfoundation.org, allison@lohutok.net,
        opensource@jilayne.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, johan@kernel.org, horms@verge.net.au
Subject: Re: [PATCH v8 1/7] nfc: pn533: i2c: "pn532" as dt compatible string
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190919091645.16439-1-poeschel@lemonage.de>
References: <20190919091645.16439-1-poeschel@lemonage.de>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Sep 2019 04:32:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


As we are in the merge window, the net-next tree is closed, as shown
also at:

	http://vger.kernel.org/~davem/net-next.html

Please resubmit this after the merge window when the net-next tree opens
back up.

Please also provide an appropriate "[PATCH 0/N]" header posting
explaining what the patch series is doing, how it is doing it, and
why it is doing it that way.

Thank you.
