Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6DD5A683
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 23:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfF1Vnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 17:43:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52356 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfF1Vnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 17:43:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A176213CB3309;
        Fri, 28 Jun 2019 14:43:34 -0700 (PDT)
Date:   Fri, 28 Jun 2019 14:43:33 -0700 (PDT)
Message-Id: <20190628.144333.1735217113144120577.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: phylink: further documentation clarifications
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1hfi09-0007Zs-Vb@rmk-PC.armlinux.org.uk>
References: <E1hfi09-0007Zs-Vb@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Jun 2019 14:43:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 25 Jun 2019 10:44:33 +0100

> Clarify the validate() behaviour in a few cases which weren't mentioned
> in the documentation, but which are necessary for users to get the
> correct behaviour.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
