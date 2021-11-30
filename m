Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333C9463A7F
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239413AbhK3Psa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbhK3Ps0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:48:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4F4C06174A
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 07:45:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C8033CE1A47
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 15:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77654C53FC7;
        Tue, 30 Nov 2021 15:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638287103;
        bh=T19UdY4KyRu0pz6Rgcdx4AMGXWvuoerK4yzGyf81z2s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cP0bgeVEPHr/Z6wQ5bsJ/2usg/4QDykslYyELb5aSB0C6wjozGvhY9P4YgH2rwvH1
         7UtWojvdZsWheZjL6gLa16simdOZKViBxFBjPU5HxNcbOVjng0euNt1b5VaQ7NcYFy
         yYluZr6UMlcwKCMkNk8XkUc5+OXaf7EyXsaWb/m4WgvfbQA5usWXtfsMOtm8lTJaxw
         vVU2HRltl50H+OI8SflntQLi/pOiIxnbLldTUrkbLZY3Z55IZst1YGWCgqRgqbzIOO
         zb8077X6dyMBLgIgCIBUi55FlgZW+WGWoZpCuSfN6LlBzGGP/7yniRjXeWJuja1OQ/
         FMjmLu0eGMlgw==
Date:   Tue, 30 Nov 2021 16:44:58 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phylink: tidy up disable bit clearing
Message-ID: <20211130164458.168effaa@thinkpad>
In-Reply-To: <E1ms4Rx-00EKEc-En@rmk-PC.armlinux.org.uk>
References: <E1ms4Rx-00EKEc-En@rmk-PC.armlinux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 14:49:41 +0000
Russell King <rmk+kernel@armlinux.org.uk> wrote:

> Tidy up the disable bit clearing where we clear a bit and the run the
> link resolver.

... and *then run ... ? But this is not important :)

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
