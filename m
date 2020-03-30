Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5934F197392
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 06:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbgC3Eug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 00:50:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33090 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgC3Eug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 00:50:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 906C715C44B68;
        Sun, 29 Mar 2020 21:50:35 -0700 (PDT)
Date:   Sun, 29 Mar 2020 21:50:34 -0700 (PDT)
Message-Id: <20200329.215034.1695213150132841251.davem@davemloft.net>
To:     kda@linux-powerpc.org
Cc:     netdev@vger.kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v2 net-next] net: page pool: allow to pass zero flags
 to page_pool_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1585168528-2445-1-git-send-email-kda@linux-powerpc.org>
References: <1585168528-2445-1-git-send-email-kda@linux-powerpc.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 21:50:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Kirjanov <kda@linux-powerpc.org>
Date: Wed, 25 Mar 2020 23:35:28 +0300

> page pool API can be useful for non-DMA cases like
> xen-netfront driver so let's allow to pass zero flags to
> page pool flags.
> 
> v2: check DMA direction only if PP_FLAG_DMA_MAP is set
> 
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>

Applied.
