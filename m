Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D39ACB4133
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 21:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbfIPTgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 15:36:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50512 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfIPTgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 15:36:39 -0400
Received: from localhost (80-167-222-154-cable.dk.customer.tdc.net [80.167.222.154])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E9793153E6F43;
        Mon, 16 Sep 2019 12:36:33 -0700 (PDT)
Date:   Mon, 16 Sep 2019 21:36:27 +0200 (CEST)
Message-Id: <20190916.213627.1150593408219168339.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        vinicius.gomes@intel.com, vedang.patel@intel.com,
        richardcochran@gmail.com, weifeng.voon@intel.com,
        jiri@mellanox.com, m-karicheri2@ti.com, jose.abreu@synopsys.com,
        ilias.apalodimas@linaro.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, kurt.kanzenbach@linutronix.de,
        joergen.andreasen@microchip.com, netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 0/6] tc-taprio offload for SJA1105 DSA
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190915020003.27926-1-olteanv@gmail.com>
References: <20190915020003.27926-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 12:36:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 15 Sep 2019 04:59:57 +0300

> This is the third attempt to submit the tc-taprio offload model for
> inclusion in the networking tree. The sja1105 switch driver will provide
> the first implementation of the offload. Only the bare minimum is added:
> 
> - The offload model and a DSA pass-through
> - The hardware implementation
> - The interaction with the netdev queues in the tagger code
> - Documentation
> 
> What has been removed from previous attempts is support for
> PTP-as-clocksource in sja1105, as well as configuring the traffic class
> for management traffic.  These will be added as soon as the offload
> model is settled.

Series applied, thanks.
