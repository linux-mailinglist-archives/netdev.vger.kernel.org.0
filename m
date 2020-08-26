Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9B9253A65
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgHZWw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgHZWw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:52:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8023C061574;
        Wed, 26 Aug 2020 15:52:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4784A1291E091;
        Wed, 26 Aug 2020 15:36:10 -0700 (PDT)
Date:   Wed, 26 Aug 2020 15:52:55 -0700 (PDT)
Message-Id: <20200826.155255.1387717683126513064.davem@davemloft.net>
To:     vineetha.g.jaya.kumaran@intel.com
Cc:     kuba@kernel.org, mcoquelin.stm32@gmail.com, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        weifeng.voon@intel.com, hock.leong.kweh@intel.com,
        boon.leong.ong@intel.com, lakshmi.bai.raja.subramanian@intel.com
Subject: Re: [PATCH v3 0/2] Add Ethernet support for Intel Keem Bay SoC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1598416422-30796-1-git-send-email-vineetha.g.jaya.kumaran@intel.com>
References: <1598416422-30796-1-git-send-email-vineetha.g.jaya.kumaran@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Aug 2020 15:36:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: vineetha.g.jaya.kumaran@intel.com
Date: Wed, 26 Aug 2020 12:33:40 +0800

> This patch set enables support for Ethernet on the Intel Keem Bay SoC.
> The first patch contains the required Device Tree bindings documentation, 
> while the second patch adds the Intel platform glue layer for the stmmac
> device driver.
> 
> This driver was tested on the Keem Bay evaluation module board.
 ...

Series applied to net-next, thank you.
