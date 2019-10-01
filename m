Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07C5DC2BB3
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 03:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbfJABdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 21:33:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41194 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbfJABdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 21:33:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 00BE4154FB625;
        Mon, 30 Sep 2019 18:33:36 -0700 (PDT)
Date:   Mon, 30 Sep 2019 18:33:33 -0700 (PDT)
Message-Id: <20190930.183333.1418048214373077538.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] net: sched: taprio: Fix potential integer
 overflow in taprio_set_picos_per_byte
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190928230139.4027-1-olteanv@gmail.com>
References: <20190928230139.4027-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Sep 2019 18:33:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 29 Sep 2019 02:01:39 +0300

> The speed divisor is used in a context expecting an s64, but it is
> evaluated using 32-bit arithmetic.
> 
> To avoid that happening, instead of multiplying by 1,000,000 in the
> first place, simplify the fraction and do a standard 32 bit division
> instead.
> 
> Fixes: f04b514c0ce2 ("taprio: Set default link speed to 10 Mbps in taprio_set_picos_per_byte")
> Reported-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied and queued up for -stable, thanks.
