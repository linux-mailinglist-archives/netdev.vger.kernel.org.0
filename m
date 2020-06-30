Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB0120E9E2
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgF3AGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgF3AGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:06:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77139C061755;
        Mon, 29 Jun 2020 17:06:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ACA44127BC932;
        Mon, 29 Jun 2020 17:06:41 -0700 (PDT)
Date:   Mon, 29 Jun 2020 17:06:40 -0700 (PDT)
Message-Id: <20200629.170640.390077323221460172.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        m-karicheri2@ti.com, vigneshr@ti.com, jan.kiszka@siemens.com
Subject: Re: [PATCH net-next 0/6] net: ethernet: ti: am65-cpsw: update and
 enable sr2.0 soc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200626181709.22635-1-grygorii.strashko@ti.com>
References: <20200626181709.22635-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jun 2020 17:06:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Fri, 26 Jun 2020 21:17:03 +0300

> This series contains set of improvements for TI AM654x/J721E CPSW2G driver and
> adds support for TI AM654x SR2.0 SoC.
> 
> Patch 1: adds vlans restoration after "if down/up"
> Patches 2-5: improvments
> Patch 6: adds support for TI AM654x SR2.0 SoC which allows to disable errata i2027 W/A.
> By default, errata i2027 W/A (TX csum offload disabled) is enabled on AM654x SoC
> for backward compatibility, unless SR2.0 SoC is identified using SOC BUS framework.

Series applied to net-next, thank you.
