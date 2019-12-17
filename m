Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A384122298
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 04:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbfLQDV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 22:21:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59288 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727377AbfLQDU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 22:20:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C5E11424DB58;
        Mon, 16 Dec 2019 19:20:57 -0800 (PST)
Date:   Mon, 16 Dec 2019 19:20:56 -0800 (PST)
Message-Id: <20191216.192056.35037297631020063.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     andrew@lunn.ch, chris.snook@gmail.com, f.fainelli@gmail.com,
        jhogan@kernel.org, jcliburn@gmail.com, mark.rutland@arm.com,
        paul.burton@mips.com, ralf@linux-mips.org, robh+dt@kernel.org,
        vivien.didelot@gmail.com, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux@armlinux.org.uk
Subject: Re: [PATCH v5 0/5] add dsa switch support for ar9331
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191216074403.313-1-o.rempel@pengutronix.de>
References: <20191216074403.313-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 19:20:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This patch series does not apply to the net-next tree.
