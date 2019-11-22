Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBABA107675
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 18:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKVRbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 12:31:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37928 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVRbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 12:31:39 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6EC491526A747;
        Fri, 22 Nov 2019 09:31:38 -0800 (PST)
Date:   Fri, 22 Nov 2019 09:31:35 -0800 (PST)
Message-Id: <20191122.093135.32405983321803856.davem@davemloft.net>
To:     helmut.grohne@intenta.de
Cc:     yuehaibing@huawei.com, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] mdio_bus: revert inadvertent error code change
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191122091711.GA31495@laureti-dev>
References: <20191122091711.GA31495@laureti-dev>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Nov 2019 09:31:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Helmut Grohne <helmut.grohne@intenta.de>
Date: Fri, 22 Nov 2019 10:17:13 +0100

> The fixed commit inadvertently changes the error code from ENOTSUPP to
> ENOSYS. Doing so breaks (among other things) probing of macb, which
> returns -ENOTSUPP as it is now returned from mdiobus_register_reset.
> 
> Fixes: 1d4639567d97 ("mdio_bus: Fix PTR_ERR applied after initialization to constant")
> Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>

You should always generate networking bug fixes against the networking
GIT tree, which had you done you would have seen that this bug is
fixed there already.

Thank you.
