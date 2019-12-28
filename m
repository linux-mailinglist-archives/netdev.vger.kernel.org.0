Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D2312BBFA
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 01:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfL1Adu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 19:33:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53752 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfL1Adu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 19:33:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 39CAE154D1158;
        Fri, 27 Dec 2019 16:33:49 -0800 (PST)
Date:   Fri, 27 Dec 2019 16:33:48 -0800 (PST)
Message-Id: <20191227.163348.1668601477335834984.davem@davemloft.net>
To:     martin.blumenstingl@googlemail.com
Cc:     linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        khilman@baylibre.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbes-150@yandex.ru,
        ingrassia@epigenesys.com, jbrunet@baylibre.com,
        linus.luessing@c0d3.blue
Subject: Re: [PATCH 0/3] Meson8b/8m2: Ethernet RGMII TX delay fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191225005655.1502037-1-martin.blumenstingl@googlemail.com>
References: <20191225005655.1502037-1-martin.blumenstingl@googlemail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Dec 2019 16:33:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Wed, 25 Dec 2019 01:56:52 +0100

> The Ethernet TX performance has been historically bad on Meson8b and
> Meson8m2 SoCs because high packet loss was seen. Today I (presumably)
> found out why this is: the input clock (which feeds the RGMII TX clock)
> has to be at least 4 times 125MHz. With the fixed "divide by 2" in the
> clock tree this means that m250_div needs to be at least 2.
 ...

It looks there needs to be more discussion on this series, please respin
once the discussions are resolved.

Thank you.
