Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704B5128648
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 02:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfLUBGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 20:06:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55806 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfLUBGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 20:06:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DB5DE1530723A;
        Fri, 20 Dec 2019 17:06:12 -0800 (PST)
Date:   Fri, 20 Dec 2019 17:06:12 -0800 (PST)
Message-Id: <20191220.170612.2223126119021628551.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     andrew@lunn.ch, chris.snook@gmail.com, f.fainelli@gmail.com,
        jhogan@kernel.org, jcliburn@gmail.com, mark.rutland@arm.com,
        paul.burton@mips.com, ralf@linux-mips.org, robh+dt@kernel.org,
        vivien.didelot@gmail.com, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux@armlinux.org.uk
Subject: Re: [PATCH v7 0/4] add dsa switch support for ar9331
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191218080215.2151-1-o.rempel@pengutronix.de>
References: <20191218080215.2151-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 17:06:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Series applied to net-next, thanks.
