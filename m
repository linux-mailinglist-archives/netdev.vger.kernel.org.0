Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7D4304D95
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732621AbhAZXL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731202AbhAZUl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 15:41:57 -0500
Received: from mail.dr-lotz.de (mail.dr-lotz.de [IPv6:2a01:4f8:161:6ffe::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF70C061573;
        Tue, 26 Jan 2021 12:41:13 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.dr-lotz.de (Postfix) with ESMTP id 9364F5B25F;
        Tue, 26 Jan 2021 21:40:25 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at mail.dr-lotz.de
Received: from mail.dr-lotz.de ([127.0.0.1])
        by localhost (mail.dr-lotz.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id UfRIaAs2M_W1; Tue, 26 Jan 2021 21:40:23 +0100 (CET)
Received: from [192.168.42.35] (ipb21b6623.dynamic.kabel-deutschland.de [178.27.102.35])
        by mail.dr-lotz.de (Postfix) with ESMTPSA id 01A7B5B25E;
        Tue, 26 Jan 2021 21:40:22 +0100 (CET)
Subject: Re: [PATCH v2] wireguard: netlink: add multicast notification for
 peer changes
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210109210056.160597-1-linus@lotz.li>
 <20210115195353.11483-1-linus@lotz.li>
 <CAHmME9rny0bc2JA1_9_A=_3OuPnEvqJyK7UMwsL+x=yTHRoBTQ@mail.gmail.com>
From:   Linus Lotz <linus@lotz.li>
Message-ID: <189f640c-e399-502a-86ec-3432a39a14ad@lotz.li>
Date:   Tue, 26 Jan 2021 21:40:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAHmME9rny0bc2JA1_9_A=_3OuPnEvqJyK7UMwsL+x=yTHRoBTQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,
have you had a chance to look at it yet?

Cheers
Linus

Am 16.01.21 um 00:40 schrieb Jason A. Donenfeld:
> Hey Linus,
> 
> My email server has been firewalled from vger.kernel.org until today,
> so I didn't see the original until this v2 was sent today. My
> apologies. I'll review this first thing on Monday.
> 
> Jason
> 
