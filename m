Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 235A11A1983
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 03:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgDHBYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 21:24:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44242 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbgDHBYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 21:24:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4B58F1210A3E3;
        Tue,  7 Apr 2020 18:24:17 -0700 (PDT)
Date:   Tue, 07 Apr 2020 18:24:16 -0700 (PDT)
Message-Id: <20200407.182416.1315050127551387306.davem@davemloft.net>
To:     martin.fuzzey@flowbird.group
Cc:     fugang.duan@nxp.com, robh+dt@kernel.org, shawnguo@kernel.org,
        netdev@vger.kernel.org, festevam@gmail.com,
        linux-kernel@vger.kernel.org, s.hauer@pengutronix.de,
        linux-imx@nxp.com, devicetree@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH v3 0/4] Fix Wake on lan with FEC on i.MX6
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1585835490-3813-1-git-send-email-martin.fuzzey@flowbird.group>
References: <1585835490-3813-1-git-send-email-martin.fuzzey@flowbird.group>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Apr 2020 18:24:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Fuzzey <martin.fuzzey@flowbird.group>
Date: Thu,  2 Apr 2020 15:51:26 +0200

> This series fixes WoL support with the FEC on i.MX6
> The support was already in mainline but seems to have bitrotted
> somewhat.
> 
> Only tested with i.MX6DL
> 
> Changes V2->V3
> 	Patch 1:
> 		fix non initialized variable introduced in V2 causing
> 		probe to sometimes fail.
> 
> 	Patch 2:
> 		remove /delete-property/interrupts-extended in
> 		arch/arm/boot/dts/imx6qp.dtsi.
> 
> 	Patches 3 and 4:
> 		Add received Acked-by and RB tags.
> 
> Changes V1->V2
> 	Move the register offset and bit number from the DT to driver code
> 	Add SOB from Fugang Duan for the NXP code on which this is based

Series applied, thanks.
