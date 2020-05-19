Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED0C1D8CCB
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 03:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgESA7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 20:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbgESA73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 20:59:29 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79387C061A0C;
        Mon, 18 May 2020 17:59:29 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49QyFn2C35z9sT3;
        Tue, 19 May 2020 10:59:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1589849966; bh=8/+JurzWor9GOkMEO6UBnJlAsXzwZLYg4x/TZn37qos=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iIVVHUQASagv59C+VIQOnQtpogsxpFdYvze4yvfpBcmwuNCyaevLKzU9l2sIp0ilw
         +DYckKCW1ryryi5bRywI8FSOStoP5rWY1J9s9Ts4y7BqkJlZoDorFB3x2KPXE9Es3b
         0JxJQXpDh8S/Ce+oL/DjZ2jkta34Dv6kCHqqix+yWfD8flS0vD8QQDt0ikHXmU6NNj
         gzOyPPDAvx0aRDJZpE5PwnF3W5N1fpOW1oOpAuzeKOBJbh3muK4kjcFquhKXzsmGuK
         Xfs/D5kHCefQ26xWcxTgb0a+WrZzXmdb5tssO2YA/U15uSeIf2Q222xIsAAGrZrDY8
         0uT1DOQn/49bg==
Message-ID: <f23cf92ee3639e0112e67051009651a88dd0b53b.camel@ozlabs.org>
Subject: Re: [PATCH] net: bmac: Fix stack corruption panic in bmac_probe()
From:   Jeremy Kerr <jk@ozlabs.org>
To:     userm57@yahoo.com, Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Paul Mackerras <paulus@samba.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Tue, 19 May 2020 08:59:24 +0800
In-Reply-To: <05aa357d-4b9c-4038-c0f4-1bfea613c6e4@yahoo.com>
References: <769e9041942802d0e9ff272c12ee359a04b84a90.1589761211.git.fthain@telegraphics.com.au>
         <43d5717e7157fd300fd5bf893e517bbdf65c36f4.camel@ozlabs.org>
         <05aa357d-4b9c-4038-c0f4-1bfea613c6e4@yahoo.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stan,

> The new kernel compiled and booted with no errors, with these
> STACKPROTECTOR options in .config (the last two revealed the bug):
> 
> CONFIG_HAVE_STACKPROTECTOR=y
> CONFIG_CC_HAS_STACKPROTECTOR_NONE=y
> CONFIG_STACKPROTECTOR=y
> CONFIG_STACKPROTECTOR_STRONG=y

Brilliant, thanks for testing. I'll send a standalone patch to netdev.

Cheers,


Jeremy

