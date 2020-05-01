Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7971C0B4D
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 02:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgEAAj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 20:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726384AbgEAAj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 20:39:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628A1C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 17:39:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D35DE1273C076;
        Thu, 30 Apr 2020 17:39:57 -0700 (PDT)
Date:   Thu, 30 Apr 2020 17:39:54 -0700 (PDT)
Message-Id: <20200430.173954.200983894807518974.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     hkallweit1@gmail.com, nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] r8169: refactor and improve interrupt
 coalescing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430145110.0ce8f89d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <d660cf81-2d8d-010e-9d5c-3f8c71c833ed@gmail.com>
        <20200430145110.0ce8f89d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 17:39:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu, 30 Apr 2020 14:51:10 -0700

> On Thu, 30 Apr 2020 21:54:43 +0200 Heiner Kallweit wrote:
>> Refactor and improve interrupt coalescing.
> 
> Looks like a nice clean up!
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Series applied, thanks everyone.
