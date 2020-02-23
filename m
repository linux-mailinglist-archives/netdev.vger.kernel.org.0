Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E058A169658
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 06:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgBWF4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 00:56:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52150 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWF4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 00:56:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5BDE6141C8E3E;
        Sat, 22 Feb 2020 21:56:43 -0800 (PST)
Date:   Sat, 22 Feb 2020 21:56:42 -0800 (PST)
Message-Id: <20200222.215642.351808172724201513.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: remove RTL_EVENT_NAPI constants
From:   David Miller <davem@davemloft.net>
In-Reply-To: <497bd68c-712e-20cc-facd-3c9a1bd22124@gmail.com>
References: <497bd68c-712e-20cc-facd-3c9a1bd22124@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Feb 2020 21:56:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 21 Feb 2020 19:27:00 +0100

> These constants are used in one place only, so we can remove them and
> use the values directly.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks.
