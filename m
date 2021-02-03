Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E860230D253
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhBCEIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:08:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:40064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231624AbhBCEIK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 23:08:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED77264E24;
        Wed,  3 Feb 2021 04:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612325249;
        bh=miefNvKjeVLjN1Z5g7rQg56Y1QCwzBxIa/641+I2Bn8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cWyokbi/iQ4ucxexlYPIRgAEq9l0Y4LKcfbiykR3fG7BAarZcP2cVAL0syUGydTGt
         33pxyIbAVWDSktQEaxfGAGfKMQy2wD66nLkeUegv9RFk6qI/lyfr4Q2wk/S8r1VwKp
         9q6xE+ByGLOhjjwOAXcBOGcSrGTC2MxY229Qp6z8ZCTctrC0oTgM7UnT1bFZm2+X4o
         0c7ojs9UEWpSqnkkjKO3qGFKWb8s1zIc4jky7XeicJML5ivx5mIoGugY7ttO/h/yH7
         I3wG9tS/C5BWn2ApzeqLpgTsYw5B3RHIjBi+UhKToj5Shs6yUtV1/JShiggP9eLcIm
         3bnNSOTB7vAVQ==
Date:   Tue, 2 Feb 2021 20:07:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Emil Renner Berthing <kernel@esmil.dk>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mackerras <paulus@samba.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Petko Manolov <petkan@nucleusys.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Oliver Neukum <oneukum@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] drivers: net: update tasklet_init callers
Message-ID: <20210202200727.4641cd7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210130234730.26565-1-kernel@esmil.dk>
References: <20210130234730.26565-1-kernel@esmil.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 31 Jan 2021 00:47:21 +0100 Emil Renner Berthing wrote:
> This updates the remaining callers of tasklet_init() in drivers/net
> to the new API introduced in 
> commit 12cc923f1ccc ("tasklet: Introduce new initialization API")
> 
> All changes are done by coccinelle using the following semantic patch.
> Coccinelle needs a little help parsing drivers/net/arcnet/arcnet.c

Applied, thanks!
