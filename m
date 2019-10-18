Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A485DDCC05
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409333AbfJRQz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:55:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54790 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405642AbfJRQz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:55:56 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 96A7E14A8C248;
        Fri, 18 Oct 2019 09:55:55 -0700 (PDT)
Date:   Fri, 18 Oct 2019 12:55:54 -0400 (EDT)
Message-Id: <20191018.125554.337602298468767216.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: dsa: sja1105: Switch to hardware
 operations for PTP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191016184102.1335-1-olteanv@gmail.com>
References: <20191016184102.1335-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 18 Oct 2019 09:55:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 16 Oct 2019 21:41:02 +0300

> Adjusting the hardware clock (PTPCLKVAL, PTPCLKADD, PTPCLKRATE) is a
> requirement for the auxiliary PTP functionality of the switch
> (TTEthernet, PPS input, PPS output).
> 
> Therefore we need to switch to using these registers to keep a
> synchronized time in hardware, instead of the timecounter/cyclecounter
> implementation, which is reliant on the free-running PTPTSCLK.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied, thanks.
