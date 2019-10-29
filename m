Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 213FBE93CE
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfJ2Xna convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 29 Oct 2019 19:43:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33026 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfJ2Xna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 19:43:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AEAE914EBE2E6;
        Tue, 29 Oct 2019 16:43:29 -0700 (PDT)
Date:   Tue, 29 Oct 2019 16:43:29 -0700 (PDT)
Message-Id: <20191029.164329.118952224718141233.davem@davemloft.net>
To:     Thomas.Haemmerle@wolfvision.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, m.tretter@pengutronix.de
Subject: Re: [PATCH v3] net: phy: dp83867: support Wake on LAN
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572250079-17677-1-git-send-email-thomas.haemmerle@wolfvision.net>
References: <1571742645-13800-1-git-send-email-thomas.haemmerle@wolfvision.net>
        <1572250079-17677-1-git-send-email-thomas.haemmerle@wolfvision.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 16:43:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Hämmerle <Thomas.Haemmerle@wolfvision.net>
Date: Mon, 28 Oct 2019 08:08:14 +0000

> From: Thomas Haemmerle <thomas.haemmerle@wolfvision.net>
> 
> This adds WoL support on TI DP83867 for magic, magic secure, unicast and
> broadcast.
> 
> Signed-off-by: Thomas Haemmerle <thomas.haemmerle@wolfvision.net>

Applied to net-next, thanks Thomas.
