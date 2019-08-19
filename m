Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F225B94EAD
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 22:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbfHSUFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 16:05:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35638 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727970AbfHSUFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 16:05:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6AA1E145F524A;
        Mon, 19 Aug 2019 13:05:16 -0700 (PDT)
Date:   Mon, 19 Aug 2019 13:05:15 -0700 (PDT)
Message-Id: <20190819.130515.356522723819678837.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: phy: realtek: support NBase-T MMD
 EEE registers on RTL8125
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d2669c95-9861-df53-2e37-6ebfde11c4c9@gmail.com>
References: <d2669c95-9861-df53-2e37-6ebfde11c4c9@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Aug 2019 13:05:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 16 Aug 2019 21:55:40 +0200

> Add missing EEE-related constants, including the new MMD EEE registers
> for NBase-T / 802.3bz. Based on that emulate the new 802.3bz MMD EEE
> registers for 2.5Gbps EEE on RTL8125.

Series applied.
