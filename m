Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694002ADEE
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 07:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfE0FOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 01:14:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50702 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfE0FOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 01:14:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EFCB6149027CA;
        Sun, 26 May 2019 22:14:17 -0700 (PDT)
Date:   Sun, 26 May 2019 22:14:17 -0700 (PDT)
Message-Id: <20190526.221417.1145781030161269408.davem@davemloft.net>
To:     ruslan@babayev.com
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, xe-linux-external@cisco.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: phy: sfp: enable i2c-bus
 detection on ACPI based systems
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190525005302.27164-2-ruslan@babayev.com>
References: <20190505193435.3248-1-ruslan@babayev.com>
        <20190525005302.27164-2-ruslan@babayev.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 May 2019 22:14:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ruslan Babayev <ruslan@babayev.com>
Date: Fri, 24 May 2019 17:53:02 -0700

> Lookup I2C adapter using the "i2c-bus" device property on ACPI based
> systems similar to how it's done with DT.
> 
> An example DSD describing an SFP on an ACPI based system:

I don't see patch #1.

Please repost with both patches and your cover letter CC:'d to netdev.
