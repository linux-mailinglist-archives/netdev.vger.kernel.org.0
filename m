Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBFB970E9F
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 03:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732020AbfGWBXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 21:23:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52554 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727748AbfGWBXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 21:23:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 332D315305A2A;
        Mon, 22 Jul 2019 18:23:46 -0700 (PDT)
Date:   Mon, 22 Jul 2019 18:23:45 -0700 (PDT)
Message-Id: <20190722.182345.1929981445585560230.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] net: stmmac: Two fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1563784666.git.joabreu@synopsys.com>
References: <cover.1563784666.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jul 2019 18:23:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Mon, 22 Jul 2019 10:39:29 +0200

> Two fixes targeting -net.

Series applied.
