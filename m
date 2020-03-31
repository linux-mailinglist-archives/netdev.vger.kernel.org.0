Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEF7199C7E
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 19:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbgCaRFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 13:05:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53058 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCaRFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 13:05:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 188D115D0C580;
        Tue, 31 Mar 2020 10:04:59 -0700 (PDT)
Date:   Tue, 31 Mar 2020 10:04:58 -0700 (PDT)
Message-Id: <20200331.100458.1797953021425845119.davem@davemloft.net>
To:     codrin.ciubotariu@microchip.com
Cc:     UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, woojung.huh@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        cristian.birsan@microchip.com
Subject: Re: [PATCH] net: dsa: ksz: Select KSZ protocol tag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200331093651.23365-1-codrin.ciubotariu@microchip.com>
References: <20200331093651.23365-1-codrin.ciubotariu@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 31 Mar 2020 10:04:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Date: Tue, 31 Mar 2020 12:36:51 +0300

> KSZ protocol tag is needed by the KSZ DSA drivers.
> 
> Fixes: 0b9f9dfbfab4 ("dsa: Allow tag drivers to be built as modules")
> Tested-by: Cristian Birsan <cristian.birsan@microchip.com>
> Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

Applied, thanks.
