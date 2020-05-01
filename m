Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEC41C0CA3
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgEADbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728078AbgEADbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:31:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAD9C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 20:31:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7B0A1274F71A;
        Thu, 30 Apr 2020 20:31:39 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:31:38 -0700 (PDT)
Message-Id: <20200430.203138.1114831051783542857.davem@davemloft.net>
To:     fugang.duan@nxp.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, cphealy@gmail.com,
        martin.fuzzey@flowbird.group
Subject: Re: [RESENT PATCH net--stat 1/1] net: ethernet: fec: Revert "net:
 ethernet: fec: Replace interrupt driven MDIO with polled IO"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587996484-3504-1-git-send-email-fugang.duan@nxp.com>
References: <1587996484-3504-1-git-send-email-fugang.duan@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 20:31:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>
Date: Mon, 27 Apr 2020 22:08:04 +0800

> This reverts commit 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef.
> 
> The commit breaks ethernet function on i.MX6SX, i.MX7D, i.MX8MM,
> i.MX8MQ, and i.MX8QXP platforms. Boot yocto system by NFS mounting
> rootfs will be failed with the commit.
> 
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>

Applied.
