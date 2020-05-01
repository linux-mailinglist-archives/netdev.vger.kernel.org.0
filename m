Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2082B1C211C
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 01:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgEAXIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 19:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726045AbgEAXIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 19:08:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F01C061A0C;
        Fri,  1 May 2020 16:08:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8DF8315039425;
        Fri,  1 May 2020 16:08:45 -0700 (PDT)
Date:   Fri, 01 May 2020 16:08:44 -0700 (PDT)
Message-Id: <20200501.160844.331842930548177984.davem@davemloft.net>
To:     Po.Liu@nxp.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, vlad@buslov.dev, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        leon@kernel.org, jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org
Subject: Re: [v5,net-next 0/4] Introduce a flow gate control action and
 apply IEEE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200501005318.21334-1-Po.Liu@nxp.com>
References: <20200428033453.28100-5-Po.Liu@nxp.com>
        <20200501005318.21334-1-Po.Liu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 16:08:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <Po.Liu@nxp.com>
Date: Fri,  1 May 2020 08:53:14 +0800

 ...
> These patches add stream gate action policing in IEEE802.1Qci (Per-Stream
> Filtering and Policing) software support and hardware offload support in
> tc flower, and implement the stream identify, stream filtering and
> stream gate filtering action in the NXP ENETC ethernet driver.
 ...

Series applied, thanks.
