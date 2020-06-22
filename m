Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38570204465
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 01:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgFVX0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 19:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbgFVX0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 19:26:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B11C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 16:26:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ACF1A12971B56;
        Mon, 22 Jun 2020 16:26:16 -0700 (PDT)
Date:   Mon, 22 Jun 2020 16:26:15 -0700 (PDT)
Message-Id: <20200622.162615.1623935232443385496.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     hkallweit1@gmail.com, nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] r8169: mark device as detached in PCI D3
 and improve locking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200622152704.429c5d19@kicinski-fedora-PC1C0HJN>
References: <2e68df85-4f64-d45b-3c4c-bb8cb9a4411d@gmail.com>
        <20200622152704.429c5d19@kicinski-fedora-PC1C0HJN>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 16:26:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 22 Jun 2020 15:27:04 -0700

> On Sat, 20 Jun 2020 22:33:39 +0200 Heiner Kallweit wrote:
>> Mark the netdevice as detached whenever parent is in PCI D3hot and not
>> accessible. This mainly applies to runtime-suspend state.
>> In addition take RTNL lock in suspend calls, this allows to remove
>> the driver-specific mutex and improve PM callbacks in general.
> 
> Not an expert on PM but looks like a nice improvement to me:
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Series applied, thanks everyone.
