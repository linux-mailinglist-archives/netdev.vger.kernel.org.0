Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2141A1E3671
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 05:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgE0DWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 23:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgE0DWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 23:22:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D453C061A0F;
        Tue, 26 May 2020 20:22:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BA035127803B0;
        Tue, 26 May 2020 20:22:01 -0700 (PDT)
Date:   Tue, 26 May 2020 20:22:00 -0700 (PDT)
Message-Id: <20200526.202200.2254002991885460192.davem@davemloft.net>
To:     fugang.duan@nxp.com
Cc:     andrew@lunn.ch, martin.fuzzey@flowbird.group,
        s.hauer@pengutronix.de, netdev@vger.kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, devicetree@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net v3 0/4] net: ethernet: fec: move GPR reigster
 offset and bit into DT
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590424033-16906-1-git-send-email-fugang.duan@nxp.com>
References: <1590424033-16906-1-git-send-email-fugang.duan@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 20:22:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: fugang.duan@nxp.com
Date: Tue, 26 May 2020 00:27:09 +0800

> From: Fugang Duan <fugang.duan@nxp.com>
> 
> The commit da722186f654 (net: fec: set GPR bit on suspend by
> DT configuration) set the GPR reigster offset and bit in driver
> for wol feature support.
> 
> It brings trouble to enable wol feature on imx6sx/imx6ul/imx7d
> platforms that have multiple ethernet instances with different
> GPR bit for stop mode control. So the patch set is to move GPR
> register offset and bit define into DT, and enable imx6q/imx6dl
> imx6qp/imx6sx/imx6ul/imx7d stop mode support.
> 
> Currently, below NXP i.MX boards support wol:
> - imx6q/imx6dl/imx6qp sabresd
> - imx6sx sabreauto
> - imx7d sdb
> 
> imx6q/imx6dl/imx6qp sabresd board dts file miss the property
> "fsl,magic-packet;", so patch#4 is to add the property for stop
> mode support.
> 
> 
> v1 -> v2:
>  - driver: switch back to store the quirks bitmask in driver_data
>  - dt-bindings: rename 'gpr' property string to 'fsl,stop-mode'
>  - imx6/7 dtsi: add imx6sx/imx6ul/imx7d ethernet stop mode property
> v2 -> v3:
>  - driver: suggested by Sascha Hauer, use a struct fec_devinfo for
>    abstracting differences between different hardware variants,
>    it can give more freedom to describe the differences.
>  - imx6/7 dtsi: correct one typo pointed out by Andrew.
> 
> Thanks Martin, Andrew and Sascha Hauer for the review.

Series applied to net-next, thanks.
