Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD8B0194F5A
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 04:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgC0DBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 23:01:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgC0DBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 23:01:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A389715CE7211;
        Thu, 26 Mar 2020 20:01:37 -0700 (PDT)
Date:   Thu, 26 Mar 2020 20:01:36 -0700 (PDT)
Message-Id: <20200326.200136.1601946994817303021.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     peter.ujfalusi@ti.com, robh@kernel.org, t-kristo@ti.com,
        netdev@vger.kernel.org, rogerq@ti.com, devicetree@vger.kernel.org,
        kuba@kernel.org, m-karicheri2@ti.com, nsekhar@ti.com,
        kishon@ti.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v6 00/11] net: ethernet: ti: add networking
 support for k3 am65x/j721e soc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200323225254.12759-1-grygorii.strashko@ti.com>
References: <20200323225254.12759-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 20:01:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Tue, 24 Mar 2020 00:52:43 +0200

> This v6 series adds basic networking support support TI K3 AM654x/J721E SoC which
> have integrated Gigabit Ethernet MAC (Media Access Controller) into device MCU
> domain and named MCU_CPSW0 (CPSW2G NUSS).
 ...

Series applied, thank you.
