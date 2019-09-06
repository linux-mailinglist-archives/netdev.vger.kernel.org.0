Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B040AAB874
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 14:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404815AbfIFMyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 08:54:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59686 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404811AbfIFMyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 08:54:10 -0400
Received: from localhost (unknown [88.214.184.128])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BF8E5152F52ED;
        Fri,  6 Sep 2019 05:54:06 -0700 (PDT)
Date:   Fri, 06 Sep 2019 14:54:03 +0200 (CEST)
Message-Id: <20190906.145403.657322945046640538.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        vinicius.gomes@intel.com, vedang.patel@intel.com,
        richardcochran@gmail.com, weifeng.voon@intel.com,
        jiri@mellanox.com, m-karicheri2@ti.com, Jose.Abreu@synopsys.com,
        ilias.apalodimas@linaro.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, kurt.kanzenbach@linutronix.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1 net-next 00/15] tc-taprio offload for SJA1105 DSA
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190902162544.24613-1-olteanv@gmail.com>
References: <20190902162544.24613-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Sep 2019 05:54:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon,  2 Sep 2019 19:25:29 +0300

> This is the first attempt to submit the tc-taprio offload model for
> inclusion in the net tree.

Someone really needs to review this.

I'm not applying this patch series until someone knowledgable in this
area does some kind of review.

Thanks.
