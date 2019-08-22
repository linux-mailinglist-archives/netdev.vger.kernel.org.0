Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED6049A36B
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390683AbfHVXBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:01:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50184 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732297AbfHVXBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 19:01:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8ACCF15396DC7;
        Thu, 22 Aug 2019 16:00:59 -0700 (PDT)
Date:   Thu, 22 Aug 2019 16:00:59 -0700 (PDT)
Message-Id: <20190822.160059.826437145937841870.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     aaro.koskinen@iki.fi, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: r8169: regression on MIPS/Loongson
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d76b0614-188e-885c-b346-b131cc1d9688@gmail.com>
References: <20190822222549.GF30291@darkstar.musicnaut.iki.fi>
        <d76b0614-188e-885c-b346-b131cc1d9688@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 16:00:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 23 Aug 2019 00:52:34 +0200

> Typically the Realtek chips are used on Intel platforms and I haven't
> seen any such report yet, so it seems to be platform-specific.
> Which board (DT config) is it, and can you provide a full dmesg?

Unfortunately on Intel you're not going to be testing the DMA syncing
very much except with full debugging enabled where it'll use bounce
buffers which give a reasonable simulation of what the non-cache-coherent
systems will be dealing with.
