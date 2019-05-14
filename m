Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26CA81E525
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 00:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfENWYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 18:24:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59500 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfENWYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 18:24:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BED3B14BFF810;
        Tue, 14 May 2019 15:24:13 -0700 (PDT)
Date:   Tue, 14 May 2019 15:24:13 -0700 (PDT)
Message-Id: <20190514.152413.759642243023046997.davem@davemloft.net>
To:     biao.huang@mediatek.com
Cc:     joabreu@synopsys.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, mcoquelin.stm32@gmail.com,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, yt.shen@mediatek.com,
        jianguo.zhang@mediatek.comi, boon.leong.ong@intel.com
Subject: Re: [v3, PATCH 0/4] fix some bugs in stmmac
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557805046-306-1-git-send-email-biao.huang@mediatek.com>
References: <1557805046-306-1-git-send-email-biao.huang@mediatek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 May 2019 15:24:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This series doesn't apply to my 'net' tree, mainly because something like
patch #3 is already in my tree.

