Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A186C10F197
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 21:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfLBUdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 15:33:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40292 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727418AbfLBUde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 15:33:34 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 123F914CE0861;
        Mon,  2 Dec 2019 12:33:34 -0800 (PST)
Date:   Mon, 02 Dec 2019 12:33:31 -0800 (PST)
Message-Id: <20191202.123331.362147479344769092.davem@davemloft.net>
To:     victorien.molle@wifirst.fr
Cc:     netdev@vger.kernel.org, florent.fourcot@wifirst.fr
Subject: Re: [PATCH] sch_cake: Add missing NLA policy entry
 TCA_CAKE_SPLIT_GSO
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191202141138.26194-1-victorien.molle@wifirst.fr>
References: <20191202141138.26194-1-victorien.molle@wifirst.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Dec 2019 12:33:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Victorien Molle <victorien.molle@wifirst.fr>
Date: Mon,  2 Dec 2019 15:11:38 +0100

> This field has never been checked since introduction in mainline kernel
> 
> Signed-off-by: Victorien Molle <victorien.molle@wifirst.fr>
> Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
> Fixes: 2db6dc2662ba "sch_cake: Make gso-splitting configurable from userspace"

Applied, thanks.
