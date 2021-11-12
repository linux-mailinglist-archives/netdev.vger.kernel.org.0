Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9C544F004
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 00:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbhKLX1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 18:27:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59162 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231320AbhKLX1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 18:27:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oJB8cZadhZ88pMqgsAeowcMmQujTcvnaKFaN4ghThG8=; b=fMnKZ4zs5K836QuF8JnFiJwy1k
        X2keaMes1ceSBnl0kSb96tqlzmWSlLDLd96r6hhijq8piqtwnR4ahQZrMCXsro1/9DPFTPmtwSspC
        OcvwnSKFjtBbjeUKKmyfAhd8tXo7ls6mF9FW4NJnAZPLdiLF2ipoVLJChPEF+rv1YM9k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mlfuV-00DIhe-9W; Sat, 13 Nov 2021 00:24:43 +0100
Date:   Sat, 13 Nov 2021 00:24:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Wells Lu <wellslutw@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, vincent.shih@sunplus.com,
        Wells Lu <wells.lu@sunplus.com>
Subject: Re: [PATCH v2 2/2] net: ethernet: Add driver for Sunplus SP7021
Message-ID: <YY73u/c6IyQW2Sl3@lunn.ch>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <cover.1636620754.git.wells.lu@sunplus.com>
 <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
 <a8c656b8-a564-6aa6-7ca4-50e7a0bd65a1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8c656b8-a564-6aa6-7ca4-50e7a0bd65a1@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian

You are basically pointing out issues i already pointed out in
previous versions, and have been ignored :-(

Wells, please look at the comments i made on your earlier
versions. Those comments are still valid and need addressing.

	 Andrew
