Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097F060DE8
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 00:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfGEWit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 18:38:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43700 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfGEWis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 18:38:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EA2ED150428B0;
        Fri,  5 Jul 2019 15:38:47 -0700 (PDT)
Date:   Fri, 05 Jul 2019 15:38:45 -0700 (PDT)
Message-Id: <20190705.153845.1823378152620818460.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH net] r8152: set RTL8152_UNPLUG only for real
 disconnection
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-288-albertk@realtek.com>
References: <1394712342-15778-288-albertk@realtek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jul 2019 15:38:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 4 Jul 2019 17:36:32 +0800

> Set the flag of RTL8152_UNPLUG if and only if the device is unplugged.
> Some error codes sometimes don't mean the real disconnection of usb device.
> For those situations, set the flag of RTL8152_UNPLUG causes the driver skips
> some flows of disabling the device, and it let the device stay at incorrect
> state.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied.
