Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36BA3367FD
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 00:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbhCJXqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 18:46:09 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46064 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbhCJXpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 18:45:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 3CB7C4D0F5BA6;
        Wed, 10 Mar 2021 15:45:42 -0800 (PST)
Date:   Wed, 10 Mar 2021 15:45:38 -0800 (PST)
Message-Id: <20210310.154538.199786368593752214.davem@davemloft.net>
To:     zajec5@gmail.com
Cc:     kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, rafal@milecki.pl
Subject: Re: [PATCH net-next 2/2] net: broadcom: bcm4908_enet: support TX
 interrupt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210310091410.10164-2-zajec5@gmail.com>
References: <20210310091410.10164-1-zajec5@gmail.com>
        <20210310091410.10164-2-zajec5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 10 Mar 2021 15:45:42 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafa©© Mi©©ecki <zajec5@gmail.com>
Date: Wed, 10 Mar 2021 10:14:10 +0100

>  
> +	if (enet->irq_tx >= 0) {
...
> +	if (enet->irq_tx > 0) {

Tests are not consistent, please fix.

Thank you.
