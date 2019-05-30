Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE73D30482
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 00:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfE3WCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 18:02:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32836 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfE3WCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 18:02:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7ECCA14DD36C5;
        Thu, 30 May 2019 15:02:50 -0700 (PDT)
Date:   Thu, 30 May 2019 15:02:50 -0700 (PDT)
Message-Id: <20190530.150250.778083419143499260.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] net: phy: improve handling of more
 complex C45 PHY's
From:   David Miller <davem@davemloft.net>
In-Reply-To: <52f1a566-9c1d-2a3d-ce7b-e9284eed65cb@gmail.com>
References: <52f1a566-9c1d-2a3d-ce7b-e9284eed65cb@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 15:02:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 30 May 2019 15:08:09 +0200

> This series tries to address few problematic aspects raised by
> Russell. Concrete example is the Marvell 88x3310, the changes
> should be helpful for other complex C45 PHY's too.
> 
> v2:
> - added patch enabling interrupts also if phylib state machine
>   isn't started
> - removed patch dealing with the double link status read
>   This one needs little bit more thinking and will go separately.

Series applied.
