Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4C7FD2A6
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 03:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfKOCAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 21:00:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57472 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfKOCAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 21:00:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB05114B79E01;
        Thu, 14 Nov 2019 18:00:35 -0800 (PST)
Date:   Thu, 14 Nov 2019 18:00:35 -0800 (PST)
Message-Id: <20191114.180035.1786843070993876430.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: use r8168d_modify_extpage in
 rtl8168f_config_eee_phy
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5ebacbf1-f586-25ad-8e19-a23746ded538@gmail.com>
References: <5ebacbf1-f586-25ad-8e19-a23746ded538@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 18:00:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 13 Nov 2019 23:03:26 +0100

> Use r8168d_modify_extpage() also in rtl8168f_config_eee_phy() to
> simplify the code.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
