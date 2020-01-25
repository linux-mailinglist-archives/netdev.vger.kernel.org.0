Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA42149427
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 10:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgAYJdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 04:33:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48784 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgAYJdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 04:33:02 -0500
Received: from localhost (unknown [147.229.117.36])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F266C15A1BD63;
        Sat, 25 Jan 2020 01:33:00 -0800 (PST)
Date:   Sat, 25 Jan 2020 10:32:59 +0100 (CET)
Message-Id: <20200125.103259.643052191132337073.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, opendmb@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: bcmgenet: Use netif_tx_napi_add() for TX NAPI
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200123174934.29500-1-f.fainelli@gmail.com>
References: <20200123174934.29500-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Jan 2020 01:33:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 23 Jan 2020 09:49:34 -0800

> Before commit 7587935cfa11 ("net: bcmgenet: move NAPI initialization to
> ring initialization") moved the code, this used to be
> netif_tx_napi_add(), but we lost that small semantic change in the
> process, restore that.
> 
> Fixes: 7587935cfa11 ("net: bcmgenet: move NAPI initialization to ring initialization")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks Florian.
