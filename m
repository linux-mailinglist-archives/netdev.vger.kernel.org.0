Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594563F3646
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 00:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbhHTWKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 18:10:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232349AbhHTWKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 18:10:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9EF161184;
        Fri, 20 Aug 2021 22:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629497395;
        bh=0pSsVPYFFTbRbW7VPD56nMGdP+by8BoUwIc8bnRhlGI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qRUPpyycARnjwBIrT2/LL1+iR0WfPnNWaMQNXSL3ml6Ar4vowCq+XDJ6ZuMmgQJMV
         SO0OOeR69MBu83Mz84DyW9RERdQ/CnxyzCaDV1Ytjuz0AXG8JlshKqMt/Id/RPX7se
         +Ot6t86uUYqz94AOjVkk/wCMaBaQkoV10fo/qK4RrpGETxRzBZGT1zeilJUSZOwYYB
         WHWC0DJdyrHV6om7HCPLUdkMLcFXyvqXC5yM1rJCaglEo8cWHxqYtaT1IzL11dSInA
         OuLNZuIu4wBnt4qBYmB3ou96GjmYRiAEjcaiwKVd/qwKO+87DnNE9K67Rt0WzyU53P
         w1/wloR9Om5Eg==
Date:   Fri, 20 Aug 2021 15:09:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Kiselev <bigunclemax@gmail.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: marvell: fix MVNETA_TX_IN_PRGRS bit number
Message-ID: <20210820150954.54216db6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210820153951.220125-1-bigunclemax@gmail.com>
References: <20210820153951.220125-1-bigunclemax@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Aug 2021 18:39:51 +0300 Maxim Kiselev wrote:
> According to Armada XP datasheet bit at 0 position is corresponding for
> TxInProg indication.
> 
> Signed-off-by: Maxim Kiselev <bigunclemax@gmail.com>

Fixes: c5aff18204da ("net: mvneta: driver for Marvell Armada 370/XP network unit")

?
