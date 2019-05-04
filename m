Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6CC51372C
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 05:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbfEDDyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 23:54:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55552 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfEDDyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 23:54:23 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BFE9714D6EACD;
        Fri,  3 May 2019 20:54:18 -0700 (PDT)
Date:   Fri, 03 May 2019 23:54:13 -0400 (EDT)
Message-Id: <20190503.235413.772771030475108766.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH net-next 0/2] mv88e6xxx: Disable ports to save power
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190430220831.19505-1-andrew@lunn.ch>
References: <20190430220831.19505-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 20:54:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Wed,  1 May 2019 00:08:29 +0200

> Save some power by disabling ports. The first patch fully disables a
> port when it is runtime disabled. The second disables any ports which
> are not used at all.
> 
> Depending on configuration strapping, this can lower the temperature
> of an idle switch a few degrees.

Series applied, thanks Andrew.
