Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EED5018A97F
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 00:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgCRXvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 19:51:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32906 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbgCRXvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 19:51:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 94A9315538DAE;
        Wed, 18 Mar 2020 16:51:31 -0700 (PDT)
Date:   Wed, 18 Mar 2020 16:51:31 -0700 (PDT)
Message-Id: <20200318.165131.1855549754958829928.davem@davemloft.net>
To:     tobias@waldekranz.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] net: phy: marvell smi2usb mdio controller
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200318165232.29680-2-tobias@waldekranz.com>
References: <20200318165232.29680-1-tobias@waldekranz.com>
        <20200318165232.29680-2-tobias@waldekranz.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 16:51:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>
Date: Wed, 18 Mar 2020 17:52:32 +0100

> +static int smi2usb_probe(struct usb_interface *interface,
> +			 const struct usb_device_id *id)
> +{
> +	struct smi2usb *smi;
> +	struct mii_bus *mdio;
> +	struct device *dev = &interface->dev;
> +	int err = -ENOMEM;

Please use reverse christmas tree ordering for local variables.

Thank you.
