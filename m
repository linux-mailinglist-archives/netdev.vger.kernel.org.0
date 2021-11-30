Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8981A463A82
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhK3PtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbhK3PtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:49:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A80C061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 07:45:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F23F1CE1A49
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 15:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CA3C53FC7;
        Tue, 30 Nov 2021 15:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638287146;
        bh=VoojhxcqmyH43bMolVBlVTaVxtZe2bOtJdDqoGr0+T0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kb/6/ZvnmgDOJlVd0oGJCW1QK3v8q7Xo2MO2ET+UCROOMeaZzhNBTrm9F0SUHVAzj
         7ipaq2Vq5fKJGOVF73Nw/apnkbdoLtdD/htvE91yyYgPz6ugXZPY4DW4j5im43V21A
         LVIeIHqZPzdXzeFqFnj9pKodGWG7CkizjiDxgzFyk+RPxQTOOGzjh4asXsXo5tNVYb
         Fhn4zoiogBKPRUFGy9d8E61dnDe81PPwD5tliKGoRPTH/eMs6SY4EkzK71RPAGLvr8
         tHM6ozbPrbHQV6M1weLRn2kCx0AIWMeKY5fQIM72ZvPjaJp3mVzgQY0MyiKMPJh1Et
         aoBe6IwIVB/Kg==
Date:   Tue, 30 Nov 2021 16:45:41 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: mvneta: program 1ms autonegotiation clock
 divisor
Message-ID: <20211130164541.6742452a@thinkpad>
In-Reply-To: <E1ms4WD-00EKLK-Ld@rmk-PC.armlinux.org.uk>
References: <E1ms4WD-00EKLK-Ld@rmk-PC.armlinux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 14:54:05 +0000
Russell King <rmk+kernel@armlinux.org.uk> wrote:

> Program the 1ms autonegotiation clock divisor according to the clocking
> rate of neta - without this, the 1ms clock ticks at about 660us on
> Armada 38x configured for 250MHz. Bring this into correct specification.
>=20
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
