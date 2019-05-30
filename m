Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B3E30468
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfE3V6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:58:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60916 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbfE3V6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:58:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 05B1714DB2CB5;
        Thu, 30 May 2019 14:40:07 -0700 (PDT)
Date:   Thu, 30 May 2019 14:40:07 -0700 (PDT)
Message-Id: <20190530.144007.2231211101631554283.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] r8169: decouple firmware handling code
 from actual driver code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <57c46ad0-f086-7321-aeca-8744a607b622@gmail.com>
References: <57c46ad0-f086-7321-aeca-8744a607b622@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 14:40:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 29 May 2019 21:13:05 +0200

> These two patches are a step towards eventually factoring out firmware
> handling code to a separate source file.

Series applied.
