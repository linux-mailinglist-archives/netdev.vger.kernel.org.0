Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 313968F3EB
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 20:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731022AbfHOSt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 14:49:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48198 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728579AbfHOSt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 14:49:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 55C3D13EA3218;
        Thu, 15 Aug 2019 11:49:59 -0700 (PDT)
Date:   Thu, 15 Aug 2019 11:49:58 -0700 (PDT)
Message-Id: <20190815.114958.1161642464604015440.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: sync EEE handling for RTL8168h with
 vendor driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <79a1db61-3aab-065b-9e18-0094c5023300@gmail.com>
References: <79a1db61-3aab-065b-9e18-0094c5023300@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 11:49:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 15 Aug 2019 14:21:30 +0200

> Sync EEE init for RTL8168h with vendor driver and add two writes to
> vendor-specific registers.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
