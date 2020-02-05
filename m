Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B509915323C
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 14:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgBENto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 08:49:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47314 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbgBENto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 08:49:44 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2B97D158EDDC9;
        Wed,  5 Feb 2020 05:49:42 -0800 (PST)
Date:   Wed, 05 Feb 2020 14:49:40 +0100 (CET)
Message-Id: <20200205.144940.712557491994145617.davem@davemloft.net>
To:     harini.katakam@xilinx.com
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michal.simek@xilinx.com,
        harinikatakamlinux@gmail.com
Subject: Re: [PATCH v3 0/2] TSO bug fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1580906292-19445-1-git-send-email-harini.katakam@xilinx.com>
References: <1580906292-19445-1-git-send-email-harini.katakam@xilinx.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Feb 2020 05:49:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>
Date: Wed,  5 Feb 2020 18:08:10 +0530

> An IP errata was recently discovered when testing TSO enabled versions
> with perf test tools where a false amba error is reported by the IP.
> Some ways to reproduce would be to use iperf or applications with payload
> descriptor sizes very close to 16K. Once the error is observed TXERR (or
> bit 6 of ISR) will be constantly triggered leading to a series of tx path
> error handling and clean up. Workaround the same by limiting this size to
> 0x3FC0 as recommended by Cadence. There was no performance impact on 1G
> system that I tested with.
> 
> Note on patch 1: The alignment code may be unused but leaving it there
> in case anyone is using UFO.
> 
> Added Fixes tag to patch 1.

Series applied and queued up for -stable, thank you.
