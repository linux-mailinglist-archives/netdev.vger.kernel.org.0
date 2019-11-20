Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C643C10443B
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 20:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfKTTZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 14:25:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58498 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbfKTTZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 14:25:48 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0226914BF1AE1;
        Wed, 20 Nov 2019 11:25:46 -0800 (PST)
Date:   Wed, 20 Nov 2019 11:25:46 -0800 (PST)
Message-Id: <20191120.112546.328555100014052910.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        andrew@lunn.ch, ivan.khoronzhuk@linaro.org, jiri@resnulli.us,
        f.fainelli@gmail.com, nsekhar@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, m-karicheri2@ti.com,
        ivecera@redhat.com, robh+dt@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v7 net-next 00/13] net: ethernet: ti: introduce new
 cpsw switchdev based driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191119221925.28426-1-grygorii.strashko@ti.com>
References: <20191119221925.28426-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 11:25:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Wed, 20 Nov 2019 00:19:12 +0200

> Thank you All for review of v6.
> 
> There are no significant changes in this version, just fixed comments to v6.
 ...

Series applied, thank you.
