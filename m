Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE5EEA84A
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 01:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfJaAgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 20:36:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48878 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfJaAgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 20:36:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9131C14E25400;
        Wed, 30 Oct 2019 17:36:11 -0700 (PDT)
Date:   Wed, 30 Oct 2019 17:36:11 -0700 (PDT)
Message-Id: <20191030.173611.319419061703639304.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: marvell: add downshift support for
 88E1145
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b5308aff-01ad-08f1-7b6c-eb8c5b995744@gmail.com>
References: <b5308aff-01ad-08f1-7b6c-eb8c5b995744@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 17:36:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 29 Oct 2019 20:25:26 +0100

> Add downshift support for 88E1145, it uses the same downshift
> configuration registers as 88E1111.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks.
