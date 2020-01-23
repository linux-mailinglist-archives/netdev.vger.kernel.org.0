Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C05C147279
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 21:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAWURg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 15:17:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33726 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAWURg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 15:17:36 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B536E14EA97FD;
        Thu, 23 Jan 2020 12:17:34 -0800 (PST)
Date:   Thu, 23 Jan 2020 21:17:33 +0100 (CET)
Message-Id: <20200123.211733.1373762254655962948.davem@davemloft.net>
To:     madalin.bucur@oss.nxp.com
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net 0/3] net: fsl/fman: address erratum A011043
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1579699229-5948-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1579699229-5948-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 12:17:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@oss.nxp.com>
Date: Wed, 22 Jan 2020 15:20:26 +0200

> This addresses a HW erratum on some QorIQ DPAA devices.
> 
> MDIO reads to internal PCS registers may result in having
> the MDIO_CFG[MDIO_RD_ER] bit set, even when there is no
> error and read data (MDIO_DATA[MDIO_DATA]) is correct.
> Software may get false read error when reading internal
> PCS registers through MDIO. As a workaround, all internal
> MDIO accesses should ignore the MDIO_CFG[MDIO_RD_ER] bit.
> When the issue was present, one could see such errors
> during boot:
> 
>   mdio_bus ffe4e5000: Error while reading PHY0 reg at 3.3

Series applied.
