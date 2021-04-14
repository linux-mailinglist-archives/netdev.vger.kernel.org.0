Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6362135FD04
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 23:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhDNVL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 17:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbhDNVL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 17:11:26 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49420C061574;
        Wed, 14 Apr 2021 14:11:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 74643500A2425;
        Wed, 14 Apr 2021 14:11:01 -0700 (PDT)
Date:   Wed, 14 Apr 2021 14:10:58 -0700 (PDT)
Message-Id: <20210414.141058.340492716482572451.davem@davemloft.net>
To:     tsbogend@alpha.franken.de
Cc:     kuba@kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/9] net: Korina improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210414152946.12517-1-tsbogend@alpha.franken.de>
References: <20210414152946.12517-1-tsbogend@alpha.franken.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 14 Apr 2021 14:11:01 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Date: Wed, 14 Apr 2021 17:29:36 +0200

> While converting Mikrotik RB532 support to use device tree I stumbled
> over the korina ethernet driver, which used way too many MIPS specific
> hacks. This series cleans this all up and adds support for device tree.
> 
> Changes in v2:
>   - added device tree support to get rid of idt_cpu_freq
>   - fixed compile test on 64bit archs
>   - fixed descriptor current address handling by storing/using mapped
>     dma addresses (dma controller modifies current address)

The last patch causes compile failures.  Incorrect number of
arguments to of_get_mac_address(), please fix this and resubmit,
thanks.
