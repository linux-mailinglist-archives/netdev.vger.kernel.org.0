Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57251194F38
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 03:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbgC0Ctx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 22:49:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57668 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0Ctw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 22:49:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 40A5215CE71D3;
        Thu, 26 Mar 2020 19:49:52 -0700 (PDT)
Date:   Thu, 26 Mar 2020 19:49:51 -0700 (PDT)
Message-Id: <20200326.194951.1495955574093632333.davem@davemloft.net>
To:     tobias@waldekranz.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH net-next v4 0/2] net: phy: marvell usb to mdio
 controller
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200323101414.11505-1-tobias@waldekranz.com>
References: <20200323101414.11505-1-tobias@waldekranz.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 19:49:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>
Date: Mon, 23 Mar 2020 11:14:12 +0100

> Support for an MDIO controller present on development boards for
> Marvell switches from the Link Street (88E6xxx) family.
> 
> v3->v4:
> - Remove unnecessary dependency on OF_MDIO.
> 
> v2->v3:
> - Rename driver smi2usb -> mvusb.
> - Clean up unused USB references.
> 
> v1->v2:
> - Reverse christmas tree ordering of local variables.

Series applied, thanks.
