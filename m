Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16AF9170DB2
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 02:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgB0BN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 20:13:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35774 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727964AbgB0BN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 20:13:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D066915AE21D4;
        Wed, 26 Feb 2020 17:13:27 -0800 (PST)
Date:   Wed, 26 Feb 2020 17:13:27 -0800 (PST)
Message-Id: <20200226.171327.726312650027889484.davem@davemloft.net>
To:     nsaenzjulienne@suse.de
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, wahrenst@gmx.net,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: bcmgenet: Clear ID_MODE_DIS in
 EXT_RGMII_OOB_CTRL when not needed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200225131159.26602-1-nsaenzjulienne@suse.de>
References: <20200225131159.26602-1-nsaenzjulienne@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 17:13:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Date: Tue, 25 Feb 2020 14:11:59 +0100

> Outdated Raspberry Pi 4 firmware might configure the external PHY as
> rgmii although the kernel currently sets it as rgmii-rxid. This makes
> connections unreliable as ID_MODE_DIS is left enabled. To avoid this,
> explicitly clear that bit whenever we don't need it.
> 
> Fixes: da38802211cc ("net: bcmgenet: Add RGMII_RXID support")
> Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
> ---
> 
> Changes since v1:
>  - Fix tags ordering
>  - Add targeted tree

Applied and queued up for v5.5 -stable.
