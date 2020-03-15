Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70A931859E7
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 04:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbgCODzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 23:55:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35228 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727447AbgCODza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 23:55:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D245815B75279;
        Sat, 14 Mar 2020 20:55:29 -0700 (PDT)
Date:   Sat, 14 Mar 2020 20:55:29 -0700 (PDT)
Message-Id: <20200314.205529.1083905174692087370.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: phy: XLGMII define and usage in
 PHYLINK
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1584031294.git.Jose.Abreu@synopsys.com>
References: <cover.1584031294.git.Jose.Abreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 14 Mar 2020 20:55:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Thu, 12 Mar 2020 18:10:08 +0100

> Adds XLGMII defines and usage in PHYLINK.
> 
> Patch 1/2, adds the define for it, whilst 2/2 adds the usage of it in
> PHYLINK.

Series applied, thanks Jose.
