Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E30B11A1997
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 03:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgDHBfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 21:35:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44352 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbgDHBfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 21:35:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 092BF1210A3E3;
        Tue,  7 Apr 2020 18:35:03 -0700 (PDT)
Date:   Tue, 07 Apr 2020 18:35:03 -0700 (PDT)
Message-Id: <20200407.183503.2239579989424500828.davem@davemloft.net>
To:     l.rubusch@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org
Subject: Re: [PATCH] Documentation: mdio_bus.c - fix warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200406212920.20229-1-l.rubusch@gmail.com>
References: <20200406212920.20229-1-l.rubusch@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Apr 2020 18:35:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Mon,  6 Apr 2020 21:29:20 +0000

> Fix wrong parameter description and related warnings at 'make htmldocs'.
> 
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>

Applied.
