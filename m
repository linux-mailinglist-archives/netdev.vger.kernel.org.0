Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05ABE2676D7
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgILAfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgILAfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:35:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6976EC061757;
        Fri, 11 Sep 2020 17:35:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6E0501226F541;
        Fri, 11 Sep 2020 17:18:17 -0700 (PDT)
Date:   Fri, 11 Sep 2020 17:35:03 -0700 (PDT)
Message-Id: <20200911.173503.2013046040329976699.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, vigneshr@ti.com,
        m-karicheri2@ti.com, nsekhar@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/9] net: ethernet: ti: ale: add static
 configuration 
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910202807.17473-1-grygorii.strashko@ti.com>
References: <20200910202807.17473-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 17:18:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Thu, 10 Sep 2020 23:27:58 +0300

> As existing, as newly introduced CPSW ALE versions have differences in 
> supported features and ALE table formats. Especially it's actual for the
> recent AM65x/J721E/J7200 and future AM64x SoCs, which supports more
> features like: auto-aging, classifiers, Link aggregation, additional HW
> filtering, etc.
> 
> The existing ALE configuration interface is not practical in terms of 
> adding new features and requires consumers to program a lot static
> parameters. And any attempt to add new features will case endless adding
> and maintaining different combination of flags and options. Because CPSW
> ALE configuration is static and fixed for SoC (or set of SoC), It is
> reasonable to add support for static ALE configurations inside ALE module.
> 
> This series introduces static ALE configuration table for different ALE 
> variants and provides option for consumers to select required ALE
> configuration by providing ALE const char *dev_id identifier (Patch 2).
> And all existing driver have been switched to use new approach (Patches 3-6).
> 
> After this ALE HW auto-ageing feature can be enabled for AM65x CPSW ALE 
> variant (Patch 7).
> 
> Finally, Patches 8-9 introduces tables to describe the ALE VLAN entries 
> fields as the ALE VLAN entries are too much differ between different TI
> CPSW ALE versions. So, handling them using flags, defines and get/set
> functions are became over-complicated.
 ...

Series applied, thank you.
