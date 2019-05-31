Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 553AF31491
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfEaSWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:22:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47648 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbfEaSWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:22:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B91F614FC92A0;
        Fri, 31 May 2019 11:22:08 -0700 (PDT)
Date:   Fri, 31 May 2019 11:22:08 -0700 (PDT)
Message-Id: <20190531.112208.2148170988874389736.davem@davemloft.net>
To:     wsa@the-dreams.de
Cc:     ruslan@babayev.com, mika.westerberg@linux.intel.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [net-next,v4 0/2] Enable SFP on ACPI based systems
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190531125751.GB951@kunai>
References: <20190528230233.26772-1-ruslan@babayev.com>
        <20190530.112759.2023290429676344968.davem@davemloft.net>
        <20190531125751.GB951@kunai>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 11:22:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wolfram Sang <wsa@the-dreams.de>
Date: Fri, 31 May 2019 14:57:52 +0200

>> Series applied.
> 
> Could you make a small immutable branch for me to pull into my I2C tree?
> I have some changes for i2c.h pending and want to minimize merge
> conflicts.

I already put other changes into net-next and also just merged 'net'
into 'net-next' and pushed that out to git.kernel.org, so I don't know
how I can still do that for you.

If it's still possible I'm willing to learn just show me what to do :)
