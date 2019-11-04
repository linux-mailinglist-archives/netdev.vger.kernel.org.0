Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC1CED7FC
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 04:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbfKDDLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 22:11:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41090 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728781AbfKDDLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 22:11:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4BADB1503943D;
        Sun,  3 Nov 2019 19:11:32 -0800 (PST)
Date:   Sun, 03 Nov 2019 19:11:31 -0800 (PST)
Message-Id: <20191103.191131.1356892695062232524.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: davinci-mdio: convert bindings to
 json-schema
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191101164502.19089-1-grygorii.strashko@ti.com>
References: <20191101164502.19089-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 03 Nov 2019 19:11:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Fri, 1 Nov 2019 18:45:02 +0200

> Now that we have the DT validation in place, let's convert the device tree
> bindings for the TI SoC Davinci/OMAP/Keystone2 MDIO Controllerr over to a
> YAML schemas.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
> changes since rfc:
>  - removed old bindings
>  - bus_freq defined as "required" for davinci_mdio
> rfc: https://lkml.org/lkml/2019/10/24/300

I am assume the devicetree folks will pick this up.
