Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE331946D3
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgCZSxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:53:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52714 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgCZSxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 14:53:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 335FF15CBC23B;
        Thu, 26 Mar 2020 11:53:31 -0700 (PDT)
Date:   Thu, 26 Mar 2020 11:53:30 -0700 (PDT)
Message-Id: <20200326.115330.2250343131621391364.davem@davemloft.net>
To:     florinel.iordache@nxp.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 6/9] net: phy: add backplane kr driver support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1585230682-24417-7-git-send-email-florinel.iordache@nxp.com>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
        <1585230682-24417-7-git-send-email-florinel.iordache@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 11:53:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florinel Iordache <florinel.iordache@nxp.com>
Date: Thu, 26 Mar 2020 15:51:19 +0200

> +static void kr_reset_master_lane(struct kr_lane_info *krln)
> +{
> +	struct phy_device *bpphy = krln->bpphy;
> +	struct backplane_phy_info *bp_phy = bpphy->priv;
> +	const struct lane_io_ops *lane_ops = krln->bp_phy->bp_dev.lane_ops;

Please use reverse christmas tree ordering for local variables.

Please audit your entire submission for this issue.

Thank you.
