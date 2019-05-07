Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09D9016B90
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 21:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfEGTlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 15:41:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33540 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfEGTlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 15:41:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4C9C414B8BFE1;
        Tue,  7 May 2019 12:41:24 -0700 (PDT)
Date:   Tue, 07 May 2019 12:41:23 -0700 (PDT)
Message-Id: <20190507.124123.199163020047319757.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: improve pause mode reporting in
 phy_print_status
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1ea97344-6971-44dd-2191-9a8db0d2c10d@gmail.com>
References: <1ea97344-6971-44dd-2191-9a8db0d2c10d@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 May 2019 12:41:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 5 May 2019 19:03:51 +0200

> So far we report symmetric pause only, and we don't consider the local
> pause capabilities. Let's properly consider local and remote
> capabilities, and report also asymmetric pause.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

It looks like Florian and Heiner are sort-of almost in agreement
here so I'll apply this and we can make whatever minor tweaks
are still necessary.

Thanks.
