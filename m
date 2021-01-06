Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6852EC6D4
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 00:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbhAFXX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 18:23:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbhAFXX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 18:23:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FC13204EF;
        Wed,  6 Jan 2021 23:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609975398;
        bh=/LcpqlnfvIZlkRV+32fsks1D3kDMqFQj+/v0jQ9Ia+Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tZAFa29mUG6D6SkUQeUekw2Yu0yU+oVGN7K8Y0a73HJb9lm0vQshOi1cFi6Ome/pY
         dyEzYr0k6DBZ80VLkCRVfQ1OfHs7VdFpd2WOt4J8A7Xh+RtM4BPepL1stkloIDYEPc
         4sLosk2Qx4nno6x7uE34SxXkzFtMMLvlTSQpkioSr8kqxjzFf1eFWUfvvyIsFJlFYJ
         py6wCeXvttYhv0IIih3Lx9mXymZPIW/owp51wFym9TT4MZ72/6bFFXE2RzpMuNuM+2
         /GyOG7f1nL5OXqejdYvgIGvPMWUCeh+dDyEknZAzv+84M8mnSwAYp3ZCjLEez+jhOb
         J/bfxCa+ad+1A==
Date:   Wed, 6 Jan 2021 15:23:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhi Han <z.han@gmx.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] Incorrect filename in drivers/net/phy/Makefile
Message-ID: <20210106152317.096f5ba8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210106101712.6360-1-z.han@gmx.net>
References: <20210106101712.6360-1-z.han@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Jan 2021 11:17:12 +0100 Zhi Han wrote:
> It should be a typing error ('-' instead of '_'), as no mdio-bus.c but
> just mdio_bus.c exists.
> 
> Just find it when inspecting these code. Tried to compile to test, but
> failed to construct an applicable .config file for that. Maybe someone
> can do that more skillfully, glad to know how.
> 
> Signed-off-by: Zhi Han <z.han@gmx.net>

Thanks for the patch, please fix the subject like this and repost:

[PATCH] net: phy: Correct filename in the Makefile

When you repost please make sure to CC on your appropriate maintainers
(get_maintainers.pl is your friend).
