Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5F91961EF
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 00:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgC0XbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 19:31:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41186 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgC0XbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 19:31:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1AB6115BEF9B0;
        Fri, 27 Mar 2020 16:24:02 -0700 (PDT)
Date:   Fri, 27 Mar 2020 16:24:00 -0700 (PDT)
Message-Id: <20200327.162400.1906897622883505835.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, cwhuang@android-x86.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] r8169: fix PHY driver check on platforms w/o
 module softdeps
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d2a7f1f1-cf74-ab63-3361-6adc0576aa89@gmail.com>
References: <40373530-6d40-4358-df58-13622a4512c2@gmail.com>
        <20200327.155753.1558332088898122758.davem@davemloft.net>
        <d2a7f1f1-cf74-ab63-3361-6adc0576aa89@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Mar 2020 16:24:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 28 Mar 2020 00:10:57 +0100

> Somehow that change made it to -stable. See e.g. commit
> 85a19b0e31e256e77fd4124804b9cec10619de5e for 4.19.

This is a serious issue in that it seems that the people maintaining
the older stable release integrate arbitrary patches even if they
haven't been sent to v5.4 and v5.5

And I don't handle -stable backport submissions that far back anyways.

Therefore, I'm not going ot participate in that ongoing problem, so
feel free to contact the folks who integrated those changes into
-stable and ask them to revert.

Thanks.
