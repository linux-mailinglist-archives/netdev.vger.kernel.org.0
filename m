Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88455CD39E
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 18:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfJFQr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 12:47:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45312 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfJFQrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 12:47:55 -0400
Received: from localhost (unknown [8.46.76.29])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8536E145F6110;
        Sun,  6 Oct 2019 09:47:44 -0700 (PDT)
Date:   Sun, 06 Oct 2019 18:47:40 +0200 (CEST)
Message-Id: <20191006.184740.105501099485690881.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] net: stmmac: Improvements for -next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1570360411.git.Jose.Abreu@synopsys.com>
References: <cover.1570360411.git.Jose.Abreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 06 Oct 2019 09:47:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Sun,  6 Oct 2019 13:17:11 +0200

> Improvements for -next. More info in commit logs.

Series applied but you have to do better than this in your header
postings.

This is the place where you must describe the high level purpose of
the patch series, what it is implementing, how it is implementing,
and why it is implmenting it that way.

Just "look at the commit logs" is not acceptable.

Thank you.
