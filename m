Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9D0CD86A2
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403919AbfJPDeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:34:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44010 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403909AbfJPDeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:34:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9170A12B88C22;
        Tue, 15 Oct 2019 20:34:00 -0700 (PDT)
Date:   Tue, 15 Oct 2019 20:34:00 -0700 (PDT)
Message-Id: <20191015.203400.1263499886536164599.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, phil@raspberrypi.org,
        jonathan@raspberrypi.org, matthias.bgg@kernel.org,
        linux-rpi-kernel@lists.infradead.org, wahrenst@gmx.net,
        nsaenzjulienne@suse.de, opendmb@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: bcmgenet: Generate a random MAC if
 none is valid
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191014212000.27712-1-f.fainelli@gmail.com>
References: <20191014212000.27712-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 20:34:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 14 Oct 2019 14:20:00 -0700

> Instead of having a hard failure and stopping the driver's probe
> routine, generate a random Ethernet MAC address to keep going.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied to net-next, thank you.
