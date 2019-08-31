Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03D6DA415D
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 02:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbfHaAhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 20:37:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44440 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfHaAhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 20:37:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 75DD215506595;
        Fri, 30 Aug 2019 17:37:39 -0700 (PDT)
Date:   Fri, 30 Aug 2019 17:37:36 -0700 (PDT)
Message-Id: <20190830.173736.77815828124625313.davem@davemloft.net>
To:     yzhai003@ucr.edu
Cc:     csong@cs.ucr.edu, zhiyunq@cs.ucr.edu, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, maxime.ripard@free-electrons.com,
        wens@csie.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: Variable "val" in function
 sun8i_dwmac_set_syscon() could be uninitialized
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CABvMjLRzuUVh7FxVQj2O40Sbr+VygwSG8spMv0fW2RZVvaJ8rQ@mail.gmail.com>
References: <20190207174623.16712-1-yzhai003@ucr.edu>
        <20190208.230117.1867217574108955553.davem@davemloft.net>
        <CABvMjLRzuUVh7FxVQj2O40Sbr+VygwSG8spMv0fW2RZVvaJ8rQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 17:37:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yizhuo Zhai <yzhai003@ucr.edu>
Date: Fri, 30 Aug 2019 15:29:07 -0700

> Thanks for your feedback, this patch should work for v4.14.

You must always submit patches against the current tree.
