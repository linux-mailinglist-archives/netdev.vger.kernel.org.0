Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8E02D4FED
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 01:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbgLJAxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 19:53:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53524 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728668AbgLJAxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 19:53:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id C71F94D259C19;
        Wed,  9 Dec 2020 16:52:53 -0800 (PST)
Date:   Wed, 09 Dec 2020 16:52:53 -0800 (PST)
Message-Id: <20201209.165253.120704618605367403.davem@davemloft.net>
To:     bongsu.jeon2@gmail.com
Cc:     krzk@kernel.org, linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        bongsu.jeon@samsung.com
Subject: Re: [PATCH v2 net-next 0/2] nfc: s3fwrn5: Change I2C interrupt
 trigger to EDGE_RISING
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201208141012.6033-1-bongsu.jeon@samsung.com>
References: <20201208141012.6033-1-bongsu.jeon@samsung.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 16:52:54 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon2@gmail.com>
Date: Tue,  8 Dec 2020 23:10:10 +0900

> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> For stable Samsung's I2C interrupt handling, I changed the interrupt 
> trigger from IRQ_TYPE_LEVEL_HIGH to IRQ_TYPE_EDGE_RISING and removed 
> the hard coded interrupt trigger type in the i2c module for the flexible 
> control.
> 
> 1/2 is the changed dt binding for the edge rising trigger.
> 2/2 is to remove the hard coded interrupt trigger type in the i2c module.
> 
> ChangeLog:
>  v2:
>   2/2
>    - remove the hard coded interrupt trigger type.

Series applied, thanks.
