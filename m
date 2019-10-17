Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B11DB7BE
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440365AbfJQTkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:40:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41204 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437743AbfJQTkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 15:40:16 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4656314049CB2;
        Thu, 17 Oct 2019 12:40:15 -0700 (PDT)
Date:   Thu, 17 Oct 2019 15:40:14 -0400 (EDT)
Message-Id: <20191017.154014.1196156125754339202.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: remove support for RTL8100e
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2b48266a-7fdc-039b-a11d-622da58acf42@gmail.com>
References: <002ad7a5-f1ce-37f4-fa22-e8af1ffa2c18@gmail.com>
        <20191017.151159.1692504406678037890.davem@davemloft.net>
        <2b48266a-7fdc-039b-a11d-622da58acf42@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 12:40:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 17 Oct 2019 21:26:35 +0200

> To be on the safe side, let me check with Realtek directly.

That's a great idea, let us know what you find out.
