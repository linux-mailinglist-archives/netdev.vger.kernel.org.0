Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C331C4721F
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 22:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfFOUnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 16:43:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39464 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfFOUnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 16:43:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A042214EB903F;
        Sat, 15 Jun 2019 13:43:21 -0700 (PDT)
Date:   Sat, 15 Jun 2019 13:43:21 -0700 (PDT)
Message-Id: <20190615.134321.740066323733871726.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        robh+dt@kernel.org, shawnguo@kernel.org, andrew@lunn.ch,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: Re: [v2, 0/6] Reuse ptp_qoriq driver for dpaa2-ptp
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190614104055.43998-1-yangbo.lu@nxp.com>
References: <20190614104055.43998-1-yangbo.lu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 15 Jun 2019 13:43:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>
Date: Fri, 14 Jun 2019 18:40:49 +0800

> Although dpaa2-ptp.c driver is a fsl_mc_driver which
> is using MC APIs for register accessing, it's same IP
> block with eTSEC/DPAA/ENETC 1588 timer.
> This patch-set is to convert to reuse ptp_qoriq driver by
> using register ioremap and dropping related MC APIs.
> However the interrupts could only be handled by MC which
> fires MSIs to ARM cores. So the interrupt enabling and
> handling still rely on MC APIs. MC APIs for interrupt
> and PPS event support are also added by this patch-set.
> 
> ---
> Changes for v2:
> 	- Allowed to compile with COMPILE_TEST.

Series applied, thanks.
