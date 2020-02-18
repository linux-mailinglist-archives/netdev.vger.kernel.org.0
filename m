Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4AB16331F
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgBRUcR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Feb 2020 15:32:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36888 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgBRUcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:32:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B851512357E86;
        Tue, 18 Feb 2020 12:32:16 -0800 (PST)
Date:   Tue, 18 Feb 2020 12:32:16 -0800 (PST)
Message-Id: <20200218.123216.1125507172937094745.davem@davemloft.net>
To:     j.neuschaefer@gmx.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: broadcom: Fix a typo ("firsly")
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200218154701.1639-1-j.neuschaefer@gmx.net>
References: <20200218154701.1639-1-j.neuschaefer@gmx.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Feb 2020 12:32:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Date: Tue, 18 Feb 2020 16:47:01 +0100

> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

Applied.
