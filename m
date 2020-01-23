Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 391A0147285
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 21:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgAWUVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 15:21:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33752 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAWUVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 15:21:36 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 01E8C14EAC209;
        Thu, 23 Jan 2020 12:21:33 -0800 (PST)
Date:   Thu, 23 Jan 2020 21:21:32 +0100 (CET)
Message-Id: <20200123.212132.399669663848706371.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        bunk@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Add PHY IDs for DP83825/6
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200122153455.8777-1-dmurphy@ti.com>
References: <20200122153455.8777-1-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 12:21:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Wed, 22 Jan 2020 09:34:53 -0600

> Adding new PHY IDs for the DP83825 and DP83826 TI Ethernet PHYs to
> the DP83822 PHY driver.

Series applied, thanks.
