Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE021191DF6
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 01:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgCYAVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 20:21:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38394 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgCYAVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 20:21:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2ECA9159FB7E4;
        Tue, 24 Mar 2020 17:21:12 -0700 (PDT)
Date:   Tue, 24 Mar 2020 17:21:09 -0700 (PDT)
Message-Id: <20200324.172109.2235442797829637868.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] r8169: re-enable MSI on RTL8168c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d99291a4-aea0-6670-0a64-1103337c2906@gmail.com>
References: <d99291a4-aea0-6670-0a64-1103337c2906@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Mar 2020 17:21:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 24 Mar 2020 20:58:29 +0100

> The original change fixed an issue on RTL8168b by mimicking the vendor
> driver behavior to disable MSI on chip versions before RTL8168d.
> This however now caused an issue on a system with RTL8168c, see [0].
> Therefore leave MSI disabled on RTL8168b, but re-enable it on RTL8168c.
> 
> [0] https://bugzilla.redhat.com/show_bug.cgi?id=1792839
> 
> Fixes: 003bd5b4a7b4 ("r8169: don't use MSI before RTL8168d")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied and queued up for -stable, thanks.
