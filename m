Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7160421782F
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 21:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbgGGTpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 15:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgGGTpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 15:45:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F75DC061755;
        Tue,  7 Jul 2020 12:45:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A8F9E120F19EC;
        Tue,  7 Jul 2020 12:45:34 -0700 (PDT)
Date:   Tue, 07 Jul 2020 12:45:33 -0700 (PDT)
Message-Id: <20200707.124533.441490036034384806.davem@davemloft.net>
To:     cphealy@gmail.com
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: sfp: Unique GPIO interrupt names
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200707012707.13267-1-cphealy@localhost.localdomain>
References: <20200707012707.13267-1-cphealy@localhost.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 12:45:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Healy <cphealy@gmail.com>
Date: Mon,  6 Jul 2020 18:27:07 -0700

> From: Chris Healy <cphealy@gmail.com>
> 
> Dynamically generate a unique GPIO interrupt name, based on the
> device name and the GPIO name.  For example:
> 
> 103:          0   sx1503q  12 Edge      sff2-los
> 104:          0   sx1503q  13 Edge      sff2-tx-fault
> 
> The sffX indicates the SFP the los and tx-fault are associated with.
> 
> Signed-off-by: Chris Healy <cphealy@gmail.com>
> 
> v3:
> - reverse Christmas tree new variable
> - fix spaces vs tabs
> v2:
> - added net-next to PATCH part of subject line
> - switched to devm_kasprintf()

Applied.
