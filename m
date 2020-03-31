Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F9C198A38
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 04:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbgCaC4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 22:56:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45930 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbgCaC4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 22:56:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 60DD815D15A90;
        Mon, 30 Mar 2020 19:56:05 -0700 (PDT)
Date:   Mon, 30 Mar 2020 19:56:04 -0700 (PDT)
Message-Id: <20200330.195604.82105368376142273.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        kuba@kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH net-next v2 0/9] net: dsa: b53 & bcm_sf2 updates for
 7278
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200330213854.4856-1-f.fainelli@gmail.com>
References: <20200330213854.4856-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 19:56:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 30 Mar 2020 14:38:45 -0700

> Hi David, Andrew, Vivien,
> 
> This patch series contains some updates to the b53 and bcm_sf2 drivers
> specifically for the 7278 Ethernet switch.
> 
> The first patch is technically a bug fix so it should ideally be
> backported to -stable, provided that Dan also agress with my resolution
> on this.
> 
> Patches #2 through #4 are minor changes to the core b53 driver to
> restore VLAN configuration upon system resumption as well as deny
> specific bridge/VLAN operations on port 7 with the 7278 which is special
> and does not support VLANs.
> 
> Patches #5 through #9 add support for matching VLAN TCI keys/masks to
> the CFP code.
> 
> Changes in v2:
> 
> - fixed some code comments and arrange some code for easier reading

Series applied, thanks.
