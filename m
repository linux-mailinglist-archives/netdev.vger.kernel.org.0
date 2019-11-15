Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71118FD287
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 02:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfKOBmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 20:42:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57302 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbfKOBmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 20:42:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 91CCA14B74FCE;
        Thu, 14 Nov 2019 17:42:53 -0800 (PST)
Date:   Thu, 14 Nov 2019 17:42:52 -0800 (PST)
Message-Id: <20191114.174252.958955180535747858.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org
Subject: Re: [PATCH v3 1/2] dt-bindings: net: dp83869: Add TI dp83869 phy
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191113164226.3281-1-dmurphy@ti.com>
References: <20191113164226.3281-1-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 17:42:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Wed, 13 Nov 2019 10:42:25 -0600

> Add dt bindings for the TI dp83869 Gigabit ethernet phy
> device.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Applied to net-next
