Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0095F992E
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 19:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfKLS5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 13:57:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47810 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfKLS5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 13:57:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 24151154CC64C;
        Tue, 12 Nov 2019 10:57:38 -0800 (PST)
Date:   Tue, 12 Nov 2019 10:57:37 -0800 (PST)
Message-Id: <20191112.105737.1048367298577980363.davem@davemloft.net>
To:     po.liu@nxp.com
Cc:     claudiu.manoil@nxp.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vinicius.gomes@intel.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, roy.zang@nxp.com, mingkai.hu@nxp.com,
        jerry.huang@nxp.com, leoyang.li@nxp.com
Subject: Re: [v2,net-next, 2/2] enetc: update TSN Qbv PSPEED set according
 to adjust link speed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191112082823.28998-2-Po.Liu@nxp.com>
References: <20191111042715.13444-2-Po.Liu@nxp.com>
        <20191112082823.28998-1-Po.Liu@nxp.com>
        <20191112082823.28998-2-Po.Liu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 10:57:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <po.liu@nxp.com>
Date: Tue, 12 Nov 2019 08:42:55 +0000

> ENETC has a register PSPEED to indicate the link speed of hardware.
> It is need to update accordingly. PSPEED field needs to be updated
> with the port speed for QBV scheduling purposes. Or else there is
> chance for gate slot not free by frame taking the MAC if PSPEED and
> phy speed not match. So update PSPEED when link adjust. This is
> implement by the adjust_link.
> 
> Signed-off-by: Po Liu <Po.Liu@nxp.com>
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied.
