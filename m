Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108AE2241DA
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgGQRdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 13:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgGQRdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 13:33:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70E9C0619D2;
        Fri, 17 Jul 2020 10:33:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C7F58135E9FF1;
        Fri, 17 Jul 2020 10:33:19 -0700 (PDT)
Date:   Fri, 17 Jul 2020 10:33:18 -0700 (PDT)
Message-Id: <20200717.103318.681710805820706586.davem@davemloft.net>
To:     cphealy@gmail.com
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: sfp: Cotsworks SFF module EEPROM
 fixup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200714175910.1358-1-cphealy@gmail.com>
References: <20200714175910.1358-1-cphealy@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 10:33:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Healy <cphealy@gmail.com>
Date: Tue, 14 Jul 2020 10:59:10 -0700

> Some Cotsworks SFF have invalid data in the first few bytes of the
> module EEPROM.  This results in these modules not being detected as
> valid modules.
> 
> Address this by poking the correct EEPROM values into the module
> EEPROM when the model/PN match and the existing module EEPROM contents
> are not correct.
> 
> Signed-off-by: Chris Healy <cphealy@gmail.com>

Applied, thank you.
