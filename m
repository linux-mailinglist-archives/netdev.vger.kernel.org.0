Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 390B5A2975
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 00:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfH2WKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 18:10:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54324 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbfH2WKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 18:10:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9B14D153AC248;
        Thu, 29 Aug 2019 15:10:13 -0700 (PDT)
Date:   Thu, 29 Aug 2019 15:10:13 -0700 (PDT)
Message-Id: <20190829.151013.914089727377629020.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     idosch@idosch.org, jiri@resnulli.us, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        allan.nielsen@microchip.com, ivecera@redhat.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to
 dev->promiscuity.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190829182957.GA17530@lunn.ch>
References: <20190829143732.GB17864@lunn.ch>
        <20190829175759.GA19471@splinter>
        <20190829182957.GA17530@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 29 Aug 2019 15:10:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Thu, 29 Aug 2019 20:29:57 +0200

> We should also think about the different classes of users. Somebody
> using a TOR switch with a NOS is very different to a user of a SOHO
> switch in their WiFi access point. The first probably knows tc very
> well, the second has probably never heard of it, and just wants
> tcpdump to work like on their desktop.

+1
