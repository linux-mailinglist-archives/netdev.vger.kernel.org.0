Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A31C3A2BA8
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfH3Aro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:47:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56076 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbfH3Aro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:47:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 055B4153D175C;
        Thu, 29 Aug 2019 17:47:43 -0700 (PDT)
Date:   Thu, 29 Aug 2019 17:47:41 -0700 (PDT)
Message-Id: <20190829.174741.721492402548072868.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org, hau@realtek.com
Subject: Re: [PATCH net-next v2 0/9] r8169: add support for RTL8125
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
References: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 29 Aug 2019 17:47:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 28 Aug 2019 22:23:22 +0200

> This series adds support for the 2.5Gbps chip RTl8125. It can be found
> on PCIe network cards, and on an increasing number of consumer gaming
> mainboards. Series is partially based on the r8125 vendor driver.
> Tested with a Delock 89531 PCIe card against a Netgear GS110MX
> Multi-Gig switch.
> Firmware isn't strictly needed, but on some systems there may be
> compatibility issues w/o firmware. Firmware has been submitted to
> linux-firmware.
> 
> v2:
> - split first patch into 6 smaller ones to facilitate bisecting

Series applied, thanks Heiner.
