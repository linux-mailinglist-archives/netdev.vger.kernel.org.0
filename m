Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7693DFA746
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 04:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfKMDaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 22:30:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54224 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbfKMDaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 22:30:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 22A1F154FF18B;
        Tue, 12 Nov 2019 19:30:17 -0800 (PST)
Date:   Tue, 12 Nov 2019 19:30:16 -0800 (PST)
Message-Id: <20191112.193016.444080271745583551.davem@davemloft.net>
To:     johan.hedberg@gmail.com
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: linux-bluetooth 2019-11-11
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191111193249.GA34408@fashcrof-mobl1.ger.corp.intel.com>
References: <20191111193249.GA34408@fashcrof-mobl1.ger.corp.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 19:30:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Hedberg <johan.hedberg@gmail.com>
Date: Mon, 11 Nov 2019 21:32:49 +0200

> Here's one more bluetooth-next pull request for the 5.5 kernel release.
> 
>  - Several fixes for LE advertising
>  - Added PM support to hci_qca driver
>  - Added support for WCN3991 SoC in hci_qca driver
>  - Added DT bindings for BCM43540 module
>  - A few other small cleanups/fixes

Pulled, thank you.
