Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1D5F16B4C
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 21:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfEGTZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 15:25:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33232 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfEGTZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 15:25:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1DBDC14B76673;
        Tue,  7 May 2019 12:25:16 -0700 (PDT)
Date:   Tue, 07 May 2019 12:25:15 -0700 (PDT)
Message-Id: <20190507.122515.1580564811216048550.davem@davemloft.net>
To:     esben@geanix.com
Cc:     netdev@vger.kernel.org, michal.simek@xilinx.com, andrew@lunn.ch,
        yuehaibing@huawei.com, yang.wei9@zte.com.cn, mcgrof@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ll_temac: Improve error message on error IRQ
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190507064258.2790-1-esben@geanix.com>
References: <20190507064258.2790-1-esben@geanix.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 May 2019 12:25:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Esben Haabendal <esben@geanix.com>
Date: Tue,  7 May 2019 08:42:57 +0200

> The channel status register value can be very helpful when debugging
> SDMA problems.
> 
> Signed-off-by: Esben Haabendal <esben@geanix.com>

Applied.
