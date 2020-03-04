Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F39F179BDB
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 23:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388472AbgCDWjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 17:39:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46952 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388281AbgCDWjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 17:39:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D6FE015ADAAEA;
        Wed,  4 Mar 2020 14:39:51 -0800 (PST)
Date:   Wed, 04 Mar 2020 14:39:51 -0800 (PST)
Message-Id: <20200304.143951.1102411401290807167.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     m-karicheri2@ti.com, kishon@ti.com, t-kristo@ti.com,
        nsekhar@ti.com, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [for-next PATCH v2 0/5] phy: ti: gmii-sel: add support for
 am654x/j721e soc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200303160029.345-1-grygorii.strashko@ti.com>
References: <20200303160029.345-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Mar 2020 14:39:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Tue, 3 Mar 2020 18:00:24 +0200

> Hi Kishon,
> 
> This series adds support for TI K3 AM654x/J721E SoCs in TI phy-gmii-sel PHY
> driver, which is required for future adding networking support.
> 
> depends on:
>  [PATCH 0/2] phy: ti: gmii-sel: two fixes
>  https://lkml.org/lkml/2020/2/14/2510
> 
> Changes in v2:
>  - fixed comments
> 
> v1: https://lkml.org/lkml/2020/2/22/100

This is mostly DT updates and not much networking code changes, will some other
tree take this?
