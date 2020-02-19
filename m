Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3D4164EC7
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 20:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgBSTWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 14:22:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46662 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBSTWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 14:22:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1659D15AE0877;
        Wed, 19 Feb 2020 11:22:03 -0800 (PST)
Date:   Wed, 19 Feb 2020 11:22:02 -0800 (PST)
Message-Id: <20200219.112202.41545263500542131.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, jcliburn@gmail.com, chris.snook@gmail.com,
        rmody@marvell.com, skalluru@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, benve@cisco.com, _govind@gmx.com,
        pkaustub@cisco.com, jeffrey.t.kirsher@intel.com,
        cooldavid@cooldavid.org, snelson@pensando.io, drivers@pensando.io,
        timur@kernel.org, jaswinder.singh@linaro.org,
        ilias.apalodimas@linaro.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        doshir@vmware.com, pv-drivers@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-hyperv@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/13] net: core: add helper
 tcp_v6_gso_csum_prep
From:   David Miller <davem@davemloft.net>
In-Reply-To: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
References: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 11:22:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 18 Feb 2020 20:55:18 +0100

> Several network drivers for chips that support TSO6 share the same code
> for preparing the TCP header, so let's factor it out to a helper.
> A difference is that some drivers reset the payload_len whilst others
> don't do this. This value is overwritten by TSO anyway, therefore
> the new helper resets it in general.

Series applied, thanks Heiner.
