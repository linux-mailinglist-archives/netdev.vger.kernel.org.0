Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0B7CC71B
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 03:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfJEBLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 21:11:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60722 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJEBLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 21:11:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C80714F35C58;
        Fri,  4 Oct 2019 18:11:54 -0700 (PDT)
Date:   Fri, 04 Oct 2019 18:11:53 -0700 (PDT)
Message-Id: <20191004.181153.2010310277773272397.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        tinywrkb@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 0/4] Fix regression with AR8035 speed downgrade
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191004160525.GZ25745@shell.armlinux.org.uk>
References: <20191004160525.GZ25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 18:11:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Fri, 4 Oct 2019 17:05:25 +0100

> The following series attempts to address an issue spotted by tinywrkb
> with the AR8035 on the Cubox-i2 in a situation where the PHY downgrades
> the negotiated link.
 ...

Series applied.
