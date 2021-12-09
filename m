Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A9E46EB15
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 16:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239360AbhLIP2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 10:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236184AbhLIP2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 10:28:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5728C061746;
        Thu,  9 Dec 2021 07:24:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CC3D7CE2643;
        Thu,  9 Dec 2021 15:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5F2C004DD;
        Thu,  9 Dec 2021 15:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639063496;
        bh=B5dv0/+MUM9oeHXzMFpUBKtqk3u7pAyJk0ljTkdMwRA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KZhLtnyfdT9f4HXlQNvdDgEe1zBQkQzNOYmlLuIBmfd/1r5AnjnL/krHaFq4SlUJT
         +54/40V0YTfYd1QavyaVdXFoyR7F1je1Kii9xZm7NzyfKSxfFWFqCj4Bk278sWVEK8
         Ubu9EL1jGm9jXCNMElmuB9R4Anvy40vcjckbc3QtzUly+lPz8hEuePcjlF4ho5Mk+q
         UPAgc5It/BW6CdhMeCWrT43RZvrUJoEeYzVtG0aHViBbVXc/miLhbL9DKzrrB3qGOa
         JvLIheYBLbzetUrzYJGDyIWKFukVxUbGWbYaocXR4liCu+RhJhAhKJ/XfQ9Gs9L0zx
         0+z2TQ5O7TGQA==
Date:   Thu, 9 Dec 2021 07:24:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v7 0/4] Add FDMA support on ocelot switch
 driver
Message-ID: <20211209072454.154b90cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211209104306.986188-1-clement.leger@bootlin.com>
References: <20211209104306.986188-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Dec 2021 11:43:02 +0100 Cl=C3=A9ment L=C3=A9ger wrote:
> This series adds support for the Frame DMA present on the VSC7514
> switch. The FDMA is able to extract and inject packets on the various
> ethernet interfaces present on the switch.

Does not apply, please rebase.
