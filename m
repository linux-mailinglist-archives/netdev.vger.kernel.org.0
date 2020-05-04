Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6F31C4693
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 21:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgEDTC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 15:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726441AbgEDTC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 15:02:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227C1C061A0E;
        Mon,  4 May 2020 12:02:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 592D311F5F61A;
        Mon,  4 May 2020 12:02:25 -0700 (PDT)
Date:   Mon, 04 May 2020 12:02:24 -0700 (PDT)
Message-Id: <20200504.120224.600801033778032707.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     richardcochran@gmail.com, m-karicheri2@ti.com, robh+dt@kernel.org,
        t-kristo@ti.com, lokeshvutla@ti.com, netdev@vger.kernel.org,
        nsekhar@ti.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nm@ti.com
Subject: Re: [PATCH net-next 0/7] net: ethernet: ti: k3: introduce common
 platform time sync driver - cpts
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200501205011.14899-1-grygorii.strashko@ti.com>
References: <20200501205011.14899-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 12:02:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Fri, 1 May 2020 23:50:04 +0300

> This series introduced support for significantly upgraded TI A65x/J721E Common
> platform time sync (CPTS) modules which are part of AM65xx Time Synchronization
> Architecture [1].
 ...

Series applied, thank you.
