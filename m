Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5757617A9
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 23:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfGGVQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 17:16:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42644 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727595AbfGGVQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 17:16:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 91D1215280193;
        Sun,  7 Jul 2019 14:16:58 -0700 (PDT)
Date:   Sun, 07 Jul 2019 14:16:58 -0700 (PDT)
Message-Id: <20190707.141658.287409083361510441.davem@davemloft.net>
To:     paweldembicki@gmail.com
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, robh+dt@kernel.org, mark.rutland@arm.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] net: dsa: Add Vitesse VSC73xx parallel mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190704222907.2888-1-paweldembicki@gmail.com>
References: <20190704222907.2888-1-paweldembicki@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Jul 2019 14:16:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pawel Dembicki <paweldembicki@gmail.com>
Date: Fri,  5 Jul 2019 00:29:03 +0200

> Main goal of this patch series is to add support for CPU attached parallel
> bus in Vitesse VSC73xx switches. Existing driver supports only SPI mode.
> 
> Second change is needed for devices in unmanaged state.
> 
> V3:
> - fix commit messages and descriptions about memory-mapped I/O mode
> 
> V2:
> - drop changes in compatible strings
> - make changes less invasive
> - drop mutex in platform part and move mutex from core to spi part
> - fix indentation 
> - fix devm_ioremap_resource result check
> - add cover letter 

Series applied to net-next, thank you.
