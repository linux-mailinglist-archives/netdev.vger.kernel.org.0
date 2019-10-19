Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAFDDDAA3
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 21:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfJSTSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 15:18:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42694 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfJSTSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 15:18:44 -0400
Received: from localhost (unknown [64.79.112.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5B65314920917;
        Sat, 19 Oct 2019 12:18:43 -0700 (PDT)
Date:   Sat, 19 Oct 2019 12:18:42 -0700 (PDT)
Message-Id: <20191019.121842.1309061571454342456.davem@davemloft.net>
To:     mans@mansr.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, wens@csie.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: dwmac-sun8i: show message only when
 switching to promisc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191018165658.9752-1-mans@mansr.com>
References: <20191018165658.9752-1-mans@mansr.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 19 Oct 2019 12:18:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mans Rullgard <mans@mansr.com>
Date: Fri, 18 Oct 2019 17:56:58 +0100

> Printing the info message every time more than the max number of mac
> addresses are requested generates unnecessary log spam.  Showing it only
> when the hw is not already in promiscous mode is equally informative
> without being annoying.
> 
> Signed-off-by: Mans Rullgard <mans@mansr.com>
> ---
> Changed in v2:
> - test only RXALL bit

Applied, thanks.
