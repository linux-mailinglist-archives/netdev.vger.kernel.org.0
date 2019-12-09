Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA3C01174DB
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfLIStn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:49:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:34126 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbfLIStn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:49:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CE48F15445C87;
        Mon,  9 Dec 2019 10:49:42 -0800 (PST)
Date:   Mon, 09 Dec 2019 10:49:42 -0800 (PST)
Message-Id: <20191209.104942.918660074223462004.davem@davemloft.net>
To:     johan.hedberg@gmail.com
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2019-12-09
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209124807.GA7309@jhedberg-mac01.local>
References: <20191209124807.GA7309@jhedberg-mac01.local>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 10:49:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Hedberg <johan.hedberg@gmail.com>
Date: Mon, 9 Dec 2019 14:48:07 +0200

> Here's the first bluetooth-next pull request for 5.6:
> 
>  - Devicetree bindings updates for Broadcom controllers
>  - Add support for PCM configuration for Broadcom controllers
>  - btusb: Fixes for Realtek devices
>  - butsb: A few other smaller fixes (mem leak & non-atomic allocation issue)
> 
> Please let me know if there are any issues pulling. Thanks.

Pulled, thanks Johan.
