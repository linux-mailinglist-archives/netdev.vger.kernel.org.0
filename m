Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176A22F04B4
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 02:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbhAJBZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 20:25:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:56174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbhAJBZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 20:25:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F359F23447;
        Sun, 10 Jan 2021 01:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610241860;
        bh=ZK8sjUoBH2wZBGZNygyI2dvKHeMU/wGLnAmtV8PppFI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TLYM6zXlMeTFV96+5oh28pmLXGhiXPtWx6XWIsUIBhl/9EhaLMDvpGqlcLsCLHk6M
         Fhxe0cgbJuQIuOJBpkHxtJ25Vuc7Awg26hpL2WPJcAuEcjns45F7iU4itXKkHCsr/L
         SokYVy0910zTI/lcmG2veAqXZoC30ZL5DdZ20htYBqT15m0ZsgpVjW+p7VPWRuX0zF
         tPqqtPOwV5wyfbvRKwKYqBaAdEhjnTtQS9z4z5vtoZ27z4wnhy4MGH6ZWspgq9eyZC
         lS10OOeISYXboQW/TA/TwhRjvLpWpsgt2jutJTL9s4qFovZnCVEru6O95uBUPJSM4Y
         6/v9FDUeFoTBw==
Date:   Sat, 9 Jan 2021 17:24:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 04/10] net: dsa: felix: reindent struct
 dsa_switch_ops
Message-ID: <20210109172419.63dcaea9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210108175950.484854-5-olteanv@gmail.com>
References: <20210108175950.484854-1-olteanv@gmail.com>
        <20210108175950.484854-5-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 Jan 2021 19:59:44 +0200 Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The devlink function pointer names are super long, and they would break
> the alignment. So reindent the existing ops now by adding one tab.

Therefore it'd be tempting to prefix them with dl_ rather than full
devlink_
