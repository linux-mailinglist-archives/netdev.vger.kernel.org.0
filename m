Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F303F0BE5
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730711AbfKFCG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:06:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42044 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFCG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:06:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EED5C15103700;
        Tue,  5 Nov 2019 18:06:55 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:06:55 -0800 (PST)
Message-Id: <20191105.180655.1808546151622207128.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v2 0/2] net: dsa: bcm_sf2: Add support for
 optional reset controller line
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191104215139.17047-1-f.fainelli@gmail.com>
References: <20191104215139.17047-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 18:06:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon,  4 Nov 2019 13:51:37 -0800

> This patch series definest the optional reset controller line for the
> BCM7445/BCM7278 integrated Ethernet switches and updates the driver to
> drive that reset line in lieu of the internal watchdog based reset since
> it does not work on BCM7278.

Series applied, thanks.
