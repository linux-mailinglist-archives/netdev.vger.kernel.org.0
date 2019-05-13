Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB8AF1BA6D
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 17:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbfEMPxd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 May 2019 11:53:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39004 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728291AbfEMPxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 11:53:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0E6FC14E11A1D;
        Mon, 13 May 2019 08:53:32 -0700 (PDT)
Date:   Mon, 13 May 2019 08:53:31 -0700 (PDT)
Message-Id: <20190513.085331.1462639042534804530.davem@davemloft.net>
To:     ynezz@true.cz
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        robh+dt@kernel.org, frowand.list@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of_net: Fix missing of_find_device_by_node ref count
 drop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557740500-2479-1-git-send-email-ynezz@true.cz>
References: <1557740500-2479-1-git-send-email-ynezz@true.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 May 2019 08:53:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr ¦tetiar <ynezz@true.cz>
Date: Mon, 13 May 2019 11:41:39 +0200

> of_find_device_by_node takes a reference to the embedded struct device
> which needs to be dropped after use.
> 
> Fixes: d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> Signed-off-by: Petr ¦tetiar <ynezz@true.cz>

Applied, thank you.
