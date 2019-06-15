Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E4246DB5
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfFOCKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:10:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57184 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfFOCKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:10:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 72B09133E9BF6;
        Fri, 14 Jun 2019 19:10:41 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:10:41 -0700 (PDT)
Message-Id: <20190614.191041.1548776767733994510.davem@davemloft.net>
To:     hancock@sedsystems.ca
Cc:     netdev@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
Subject: Re: [PATCH net] net: dsa: microchip: Don't try to read stats for
 unused ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560371612-31848-1-git-send-email-hancock@sedsystems.ca>
References: <1560371612-31848-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:10:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Hancock <hancock@sedsystems.ca>
Date: Wed, 12 Jun 2019 14:33:32 -0600

> If some of the switch ports were not listed in the device tree, due to
> being unused, the ksz_mib_read_work function ended up accessing a NULL
> dp->slave pointer and causing an oops. Skip checking statistics for any
> unused ports.
> 
> Fixes: 7c6ff470aa867f53 ("net: dsa: microchip: add MIB counter reading
> support")
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>

Applied and queued up for -stable.
