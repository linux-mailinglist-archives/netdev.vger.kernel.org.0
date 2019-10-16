Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9BAED86D5
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbfJPDk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:40:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44108 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfJPDk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:40:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9B7E01266043A;
        Tue, 15 Oct 2019 20:40:26 -0700 (PDT)
Date:   Tue, 15 Oct 2019 20:40:26 -0700 (PDT)
Message-Id: <20191015.204026.278772277454645613.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylink: use more linkmode_*
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1iKK4M-0000bC-AE@rmk-PC.armlinux.org.uk>
References: <E1iKK4M-0000bC-AE@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 20:40:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 15 Oct 2019 11:28:46 +0100

> Use more linkmode_* helpers rather than open-coding the bitmap
> operations.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
