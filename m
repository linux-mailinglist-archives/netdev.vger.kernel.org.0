Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EABB14F043
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbgAaP6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:58:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728846AbgAaP6i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 10:58:38 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43E8F206D3;
        Fri, 31 Jan 2020 15:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580486317;
        bh=hnLIGrf0deqBJjaJ6PHTwO5DN5zv5O1TDu/IlTX85uk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wNYK7EnNFsJUWWYopW9YsU3Xmp+EYNDveunBLuK0DZ3O3smo3i5P9Hy62DZtPCUK4
         zcZ2/eL2RT0BHRhGUl1oY1Osr1VN6AMwvD4JjGeR2PWXNOdq+zGu0wdxC/bDrwj0ZF
         JXWW58C1ebe4OGI3g9fOhCe471k6L8dihTiJ1Ik8=
Date:   Fri, 31 Jan 2020 07:58:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next] net: phy: at803x: disable vddio regulator
Message-ID: <20200131075836.485d5583@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200130175402.19567-1-michael@walle.cc>
References: <20200130175402.19567-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jan 2020 18:54:02 +0100, Michael Walle wrote:
> The probe() might enable a VDDIO regulator, which needs to be disabled
> again before calling regulator_put(). Add a remove() function.
> 
> Fixes: 2f664823a470 ("net: phy: at803x: add device tree binding")
> Signed-off-by: Michael Walle <michael@walle.cc>

Applied, thank you!
