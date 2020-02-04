Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083E0151917
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 11:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgBDK6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 05:58:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41816 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbgBDK6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 05:58:36 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2EC6A133A87CD;
        Tue,  4 Feb 2020 02:58:34 -0800 (PST)
Date:   Tue, 04 Feb 2020 11:58:32 +0100 (CET)
Message-Id: <20200204.115832.852019347761501397.davem@davemloft.net>
To:     kai.heng.feng@canonical.com
Cc:     hayeswang@realtek.com, kuba@kernel.org, pmalani@chromium.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] r8152: Add MAC passthrough support to new device
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200204053315.21866-1-kai.heng.feng@canonical.com>
References: <20200204053315.21866-1-kai.heng.feng@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Feb 2020 02:58:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Tue,  4 Feb 2020 13:33:13 +0800

> Device 0xa387 also supports MAC passthrough, therefore add it to the
> whitelst.
> 
> BugLink: https://bugs.launchpad.net/bugs/1827961/comments/30
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v2:
>  - Use switch case to match device id.
>  - Use macro instead of hex for device id.

Applied, thank you.
