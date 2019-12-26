Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20DFC12AEE1
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 22:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfLZVWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 16:22:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43580 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZVWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 16:22:37 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 927D91513DD33;
        Thu, 26 Dec 2019 13:22:36 -0800 (PST)
Date:   Thu, 26 Dec 2019 13:22:35 -0800 (PST)
Message-Id: <20191226.132235.1870219915908299554.davem@davemloft.net>
To:     martin.blumenstingl@googlemail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] RTL8211F: RGMII RX/TX delay configuration
 improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191226185148.3764251-1-martin.blumenstingl@googlemail.com>
References: <20191226185148.3764251-1-martin.blumenstingl@googlemail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 13:22:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Thu, 26 Dec 2019 19:51:46 +0100

> In discussion with Andrew [0] we figured out that it would be best to
> make the RX delay of the RTL8211F PHY configurable (just like the TX
> delay is already configurable).
> 
> While here I took the opportunity to add some logging to the TX delay
> configuration as well.
 ...

Series applied to net-next, thank you.
