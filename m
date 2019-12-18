Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E38E1252A4
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbfLRUGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:06:09 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55738 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbfLRUGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:06:09 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AE094153CA138;
        Wed, 18 Dec 2019 12:06:08 -0800 (PST)
Date:   Wed, 18 Dec 2019 12:06:08 -0800 (PST)
Message-Id: <20191218.120608.957923763169948073.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3 0/9] net: stmmac: Fixes for -net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1576664155.git.Jose.Abreu@synopsys.com>
References: <cover.1576664155.git.Jose.Abreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Dec 2019 12:06:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Wed, 18 Dec 2019 11:17:34 +0100

> Fixes for stmmac.

Series applied.

But realistically I doubt you'll ever find a configuration where
SMP_CACHE_BYTES is less than 16 (seriously, it is so non-sensible to
build a cpu like that).  So you could have done something like:

#if SMP_CACHE_BYTES < 16
#error SMP_CACHE_BYTES too small
#endif

and then add the funky double alignment code if that ever triggered.

But again it never will.
