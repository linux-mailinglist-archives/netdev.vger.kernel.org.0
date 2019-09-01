Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2B00A4B5F
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 21:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbfIATZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 15:25:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58878 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728930AbfIATZ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Sep 2019 15:25:59 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6924B30832C8;
        Sun,  1 Sep 2019 19:25:59 +0000 (UTC)
Received: from localhost (ovpn-112-7.rdu2.redhat.com [10.10.112.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7686D5D6B7;
        Sun,  1 Sep 2019 19:25:57 +0000 (UTC)
Date:   Sun, 01 Sep 2019 12:25:56 -0700 (PDT)
Message-Id: <20190901.122556.145081194403610246.davem@redhat.com>
To:     vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, marek.behun@nic.cz, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next 00/10] net: dsa: mv88e6xxx: centralize SERDES
 IRQ handling
From:   David Miller <davem@redhat.com>
In-Reply-To: <20190831201836.19957-1-vivien.didelot@gmail.com>
References: <20190831201836.19957-1-vivien.didelot@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Sun, 01 Sep 2019 19:25:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Sat, 31 Aug 2019 16:18:26 -0400

> Following Marek's work on the abstraction of the SERDES lanes mapping, this
> series trades the .serdes_irq_setup and .serdes_irq_free callbacks for new
> .serdes_irq_mapping, .serdes_irq_enable and .serdes_irq_status operations.
> 
> This has the benefit to limit the various SERDES implementations to simple
> register accesses only; centralize the IRQ handling and mutex locking logic;
> as well as reducing boilerplate in the driver.

Looks good, series applied.
