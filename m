Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610EF300FB0
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730917AbhAVWNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 17:13:10 -0500
Received: from 95-165-96-9.static.spd-mgts.ru ([95.165.96.9]:32998 "EHLO
        blackbox.su" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1729347AbhAVWM6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 17:12:58 -0500
Received: from metabook.localnet (metabook.metanet [192.168.2.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by blackbox.su (Postfix) with ESMTPSA id CD5D782100;
        Sat, 23 Jan 2021 01:12:26 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blackbox.su; s=mail;
        t=1611353546; bh=lWPKTNit76qJXZ2b90ZpRVzOpxGts5CbDZzgBth5kuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1No600Ti2Sni2KtM1qQEUBkC9ZQ4oNb5os7ubkDXo+RvP8o5iLGnMBe4zb9sUryj
         PRujFxWri88BXD9gnxzBydFlh7WhiD4l4FY0gRKMpDfFa4OOOOE7c0ArzHCKRka3lA
         R5eFYAqdjHzBEb+zwe7xdTHtzX8YG18WI6DB1H2tQ1X889EfGReCKyZKh0I3bqCaVn
         Nkc2tLbQXNjFq9B2H9tRJBfhkbO/wb73YGhQ6oZN2rTS/vUXYd3brcJmkVG+i37S5x
         Z0jZZJxypPnETScVngYPQ0bwTgLJFWj8VEStPkDtgR2WMtEaxJEkZJrX71XtT00ZVx
         sXMgzFhT1ZpRg==
From:   Sergej Bauer <sbauer@blackbox.su>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Simon Horman <simon.horman@netronome.com>,
        Mark Einon <mark.einon@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lan743x: add virtual PHY for PHY-less devices
Date:   Sat, 23 Jan 2021 01:11:34 +0300
Message-ID: <2487479.v6ibHXAnzy@metabook>
In-Reply-To: <ecc54ce2-cbda-d801-1127-e1c15aa22654@gmail.com>
References: <20210122214247.6536-1-sbauer@blackbox.su> <ecc54ce2-cbda-d801-1127-e1c15aa22654@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday, January 23, 2021 12:52:48 AM MSK Florian Fainelli wrote:
> On 1/22/2021 1:42 PM, Sergej Bauer wrote:
> > From: sbauer@blackbox.su
> > 
> > v1->v2:
> > 	switch to using of fixed_phy as was suggested by Andrew and Florian
> > 	also features-related parts are removed
> > 
> > Previous versions can be found at:
> > v1:
> > initial version
> > 
> > 	https://lkml.org/lkml/2020/9/17/1272
> > 
> > Signed-off-by: Sergej Bauer <sbauer@blackbox.su>
> 
> You are not explaining why you need this and why you are second guessing
> the fixed PHY MII emulation that already exists. You really need to do a
> better job at describing your changes and why the emulation offered by
> swphy.c is not enough for your use case.

ok, I'll try to accomplish it with swphy.

-- 
                                    Regards,
                                           Sergej.



