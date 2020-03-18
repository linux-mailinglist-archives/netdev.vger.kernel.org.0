Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A60271896A9
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 09:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgCRILM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 04:11:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47842 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbgCRILK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 04:11:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 26BBC1489E4DA;
        Wed, 18 Mar 2020 01:11:09 -0700 (PDT)
Date:   Tue, 17 Mar 2020 23:39:54 -0700 (PDT)
Message-Id: <20200317.233954.1822377816644426205.davem@davemloft.net>
To:     mchehab+huawei@kernel.org
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        corbet@lwn.net, linux@armlinux.org.uk, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH 10/17] net: phy: sfp-bus.c: get rid of docs warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0d4835042a03ecda3514c1de0254d30134b0e8e0.1584456635.git.mchehab+huawei@kernel.org>
References: <cover.1584456635.git.mchehab+huawei@kernel.org>
        <0d4835042a03ecda3514c1de0254d30134b0e8e0.1584456635.git.mchehab+huawei@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 01:11:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date: Tue, 17 Mar 2020 15:54:19 +0100

> The indentation for the returned values are weird, causing those
> warnings:
> 
> 	./drivers/net/phy/sfp-bus.c:579: WARNING: Unexpected indentation.
> 	./drivers/net/phy/sfp-bus.c:619: WARNING: Unexpected indentation.
> 
> Use a list and change the identation for it to be properly
> parsed by the documentation toolchain.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Applied.
