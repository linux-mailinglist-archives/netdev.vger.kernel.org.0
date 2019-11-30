Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F5310DF43
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 21:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfK3UZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 15:25:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44848 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfK3UZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 15:25:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3:a597:786a:2aef:1599])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BE0DE144B439A;
        Sat, 30 Nov 2019 12:25:42 -0800 (PST)
Date:   Sat, 30 Nov 2019 12:25:42 -0800 (PST)
Message-Id: <20191130.122542.96674139694641357.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, sathya.perla@broadcom.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com
Subject: Re: [PATCH] net: emulex: benet: indent a Kconfig depends
 continuation line
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cb47882b-7417-ca32-41ac-70b76fae0ff2@infradead.org>
References: <cb47882b-7417-ca32-41ac-70b76fae0ff2@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 Nov 2019 12:25:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Thu, 28 Nov 2019 14:17:59 -0800

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Indent a Kconfig continuation line to improve readability.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied.
