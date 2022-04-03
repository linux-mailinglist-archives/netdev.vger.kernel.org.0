Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631444F0BC5
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 20:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359749AbiDCScL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 14:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235979AbiDCScJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 14:32:09 -0400
Received: from mail.tintel.eu (mail.tintel.eu [IPv6:2001:41d0:a:6e77:0:ff:fe5c:6a54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5A527FFD;
        Sun,  3 Apr 2022 11:30:11 -0700 (PDT)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id D5642443B963;
        Sun,  3 Apr 2022 20:30:08 +0200 (CEST)
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id sa1PFiUZ_mjz; Sun,  3 Apr 2022 20:30:08 +0200 (CEST)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id 681894474A5E;
        Sun,  3 Apr 2022 20:30:08 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.tintel.eu 681894474A5E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux-ipv6.be;
        s=502B7754-045F-11E5-BBC5-64595FD46BE8; t=1649010608;
        bh=aL1mGsXRMCBOZs3MUV1DjxhbotLkkVeZMGP5VkLSNvQ=;
        h=Message-ID:Date:MIME-Version:To:From;
        b=hjfedKkTKxsRliIAcjYUAf6CPK4YYdaLY7fvCIZR5MG96tYRop7diZMMj/dYtWPJY
         nk9vfgBaqOHlKXBRNjYEkIMYYZVyl/FAJE5XKzPbqPThemkWd7ls0IkUPBLXu3Bifg
         fXRvt4FZ09btbGoDSd5haLGTky9XkLR+cjn2f+HU=
X-Virus-Scanned: amavisd-new at mail.tintel.eu
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id hiXKhX-QRJ6T; Sun,  3 Apr 2022 20:30:08 +0200 (CEST)
Received: from [IPV6:2001:67c:21bc:20::10] (unknown [IPv6:2001:67c:21bc:20::10])
        (Authenticated sender: stijn@tintel.eu)
        by mail.tintel.eu (Postfix) with ESMTPSA id BE5AF4442F9F;
        Sun,  3 Apr 2022 20:30:07 +0200 (CEST)
Message-ID: <fa04f389-df01-4838-7304-2fb43b919b98@linux-ipv6.be>
Date:   Sun, 3 Apr 2022 21:30:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: phy: marvell: add 88E1543 support
Content-Language: en-GB
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pali@kernel.org, kabel@kernel.org, pabeni@redhat.com,
        kuba@kernel.org, davem@davemloft.net, hkallweit1@gmail.com,
        andrew@lunn.ch
References: <20220403172936.3213998-1-stijn@linux-ipv6.be>
 <YknlRh7MLgLllb9q@shell.armlinux.org.uk>
From:   Stijn Tintel <stijn@linux-ipv6.be>
In-Reply-To: <YknlRh7MLgLllb9q@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/04/2022 21:19, Russell King (Oracle) wrote:
> Hi,
>
> On Sun, Apr 03, 2022 at 08:29:36PM +0300, Stijn Tintel wrote:
>> Add support for the Marvell Alaska 88E1543 PHY used in the WatchGuard
>> Firebox M200 and M300.
> Looking at the IDs, this PHY should already be supported - reporting as
> an 88E1545. Why do you need this patch?
>
Thanks for pointing that out, you're right. Please disregard the patch.=C2=
=A0
Would it be acceptable to change the name member to "Marvell
88E1543/88E1545" to make this more obvious?

Thanks,
Stijn

