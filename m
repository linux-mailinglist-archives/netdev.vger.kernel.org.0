Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 425A746DB8
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfFOCNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:13:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57220 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfFOCNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:13:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0E8FF133F9EC7;
        Fri, 14 Jun 2019 19:13:00 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:12:59 -0700 (PDT)
Message-Id: <20190614.191259.1875934949994235070.davem@davemloft.net>
To:     hancock@sedsystems.ca
Cc:     netdev@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
Subject: Re: [PATCH net-next 0/2] Microchip KSZ driver enhancements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560372546-3153-1-git-send-email-hancock@sedsystems.ca>
References: <1560372546-3153-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:13:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Hancock <hancock@sedsystems.ca>
Date: Wed, 12 Jun 2019 14:49:04 -0600

> A couple of enhancements to the Microchip KSZ switch driver: one to add
> PHY register settings for errata workarounds for more stable operation, and
> another to add a device tree option to change the output clock rate as
> required by some board designs.

Series applied.
