Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768A6191D92
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 00:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgCXXd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 19:33:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37930 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgCXXd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 19:33:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 225F8159F5B45;
        Tue, 24 Mar 2020 16:33:27 -0700 (PDT)
Date:   Tue, 24 Mar 2020 16:33:26 -0700 (PDT)
Message-Id: <20200324.163326.1433477326280968127.davem@davemloft.net>
To:     andre.przywara@arm.com
Cc:     radhey.shyam.pandey@xilinx.com, michal.simek@xilinx.com,
        hancock@sedsystems.ca, netdev@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH v3 00/14] net: axienet: Update error handling and add
 64-bit DMA support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200324132347.23709-1-andre.przywara@arm.com>
References: <20200324132347.23709-1-andre.przywara@arm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Mar 2020 16:33:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>
Date: Tue, 24 Mar 2020 13:23:33 +0000

> a minor update, fixing the 32-bit build breakage, and brightening up
> Dave's christmas tree. Rebased against latest net-next/master.

Series applied to net-next, thanks.
