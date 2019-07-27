Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB3F77C06
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 23:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfG0VZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 17:25:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40400 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfG0VZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 17:25:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E271B1534E7C4;
        Sat, 27 Jul 2019 14:25:22 -0700 (PDT)
Date:   Sat, 27 Jul 2019 14:25:22 -0700 (PDT)
Message-Id: <20190727.142522.968931353498373029.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] r8169: improve HW csum and TSO handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d347af97-0b46-6c71-37ef-46ce2b46f4df@gmail.com>
References: <d347af97-0b46-6c71-37ef-46ce2b46f4df@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 14:25:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 26 Jul 2019 21:47:30 +0200

> This series:
> - delegates more tasks from the driver to the core
> - enables HW csum and TSO per default
> - copies quirks for buggy chip versions from vendor driver

Series applied, thanks Heiner.
