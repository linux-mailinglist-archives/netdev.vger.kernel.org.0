Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4388217B5D
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 00:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgGGWv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 18:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729825AbgGGWv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 18:51:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20FDC061755;
        Tue,  7 Jul 2020 15:51:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 32B58120F19EC;
        Tue,  7 Jul 2020 15:51:26 -0700 (PDT)
Date:   Tue, 07 Jul 2020 15:51:25 -0700 (PDT)
Message-Id: <20200707.155125.1879011782236800529.davem@davemloft.net>
To:     cphealy@gmail.com
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: sfp: add error checking with sfp_irq_name
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200707203205.28592-1-cphealy@gmail.com>
References: <20200707203205.28592-1-cphealy@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 15:51:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Healy <cphealy@gmail.com>
Date: Tue,  7 Jul 2020 13:32:05 -0700

> Add error checking with sfp_irq_name before use.
> 
> Signed-off-by: Chris Healy <cphealy@gmail.com>

Applied.
