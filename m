Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE22301EB
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfE3S2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:28:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56756 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfE3S2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:28:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF1B314D92C6E;
        Thu, 30 May 2019 11:27:59 -0700 (PDT)
Date:   Thu, 30 May 2019 11:27:59 -0700 (PDT)
Message-Id: <20190530.112759.2023290429676344968.davem@davemloft.net>
To:     ruslan@babayev.com
Cc:     mika.westerberg@linux.intel.com, wsa@the-dreams.de,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [net-next,v4 0/2] Enable SFP on ACPI based systems
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190528230233.26772-1-ruslan@babayev.com>
References: <20190528230233.26772-1-ruslan@babayev.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 11:28:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ruslan Babayev <ruslan@babayev.com>
Date: Tue, 28 May 2019 16:02:31 -0700

> Changes:
> v2:
> 	- more descriptive commit body
> v3:
> 	- made 'i2c_acpi_find_adapter_by_handle' static inline
> v4:
> 	- don't initialize i2c_adapter to NULL. Instead see below...
> 	- handle the case of neither DT nor ACPI present as invalid.
> 	- alphabetical includes.
> 	- use has_acpi_companion().
> 	- use the same argument name in i2c_acpi_find_adapter_by_handle()
> 	  in both stubbed and non-stubbed cases.

Series applied.
