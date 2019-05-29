Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1256D2DA0C
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 12:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbfE2KKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 06:10:03 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39503 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfE2KKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 06:10:02 -0400
Received: by mail-ed1-f68.google.com with SMTP id e24so2876740edq.6
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 03:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nm38JeNDlkgyzoR2E2bkpbIH5WQW0O+ix4B6IWaGYjk=;
        b=iOx1OEzrJnLYmToCoRl2wdmDsuwWhMXDTxy1Z6qWeSsaA1eo2aWwhCgCkiP6QOespF
         +RE2p8IkyBSMg/XpGZ4nj2caho2BNb78OUTxMyxVu9Hdk6sL+ypKdEdFknSpeZxeLtpy
         0lZIzYNOsEXJYI2hrKC3vDh5PlGSubHJf7C4HX4aCeayfFdREP4GyHR+HUN96psu7y2L
         ez/HFXwpa0Uhdz/ufIJdRaDh1cMQK7n6xjR+eQxm5YSjBKhzl4MyaqKBq8NLMWvu9nRP
         shjZnkh1wjipX+hCi673Jy5WoWheF0F+8aOQ56uEBIBzZDOtfrmtpN7+Kie5vaR8QGoM
         +QaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nm38JeNDlkgyzoR2E2bkpbIH5WQW0O+ix4B6IWaGYjk=;
        b=L6xux2PkOhk4op3ra4MgbLO518BQ95mvRubnM4Re3YcZ0XmF3Ls3RamLYXk00ajFuy
         2CX0OsAS2k2ps5ZsPhmX9+qVTDdfb+WhvmiC9mKWloATeW3AWup7If4CnqSKskwub3M7
         Z69IX6V3WlRwooFHyv5DeHuW2auDjVYDH2CkFY4SafQGw5GSKDqFTAUrPSY3BbQZ/C1e
         7hfjaLkl/pnddPeT4PR139tq019jheqpywUXLFn3U2eK3OeLduPZmn3e9QnvsiE+75yk
         mhBPWP5TETvgRTBabmsN4CN+3sfCCoAPbow7wofSJkZ11Ud9lk/cb35Smalg6foX/64q
         Ufng==
X-Gm-Message-State: APjAAAV1elvtnJJY9x/k+rg/fe06szue7Kxt4/2EPKQT0yMzuehoucpc
        CiP5LrOwjuJqUQmsRJ8QzAjCMx9peMX5lMcD/EQ=
X-Google-Smtp-Source: APXvYqxNGR5PDseiIxj/ieWJfwe8LjKZJAC8kMac2efQ0OsIJyDRKw4EmbpDqf7DzAko9a/30zg/1Y9GPcVt74qcJ5g=
X-Received: by 2002:a17:906:4b12:: with SMTP id y18mr72604497eju.32.1559124601389;
 Wed, 29 May 2019 03:10:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190528225005.10628-1-olteanv@gmail.com> <20190528225005.10628-3-olteanv@gmail.com>
 <8577fda1-9104-2d2a-980f-91f4bb6c6f8e@gmail.com>
In-Reply-To: <8577fda1-9104-2d2a-980f-91f4bb6c6f8e@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 29 May 2019 13:09:50 +0300
Message-ID: <CA+h21hoD21GCbSS7R0Av3tRe7LoxqRSmmNnCTrQZVCjQYCiGPw@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net: dsa: tag_8021q: Create a stable binary format
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 May 2019 at 04:08, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/28/2019 3:50 PM, Vladimir Oltean wrote:
> > Tools like tcpdump need to be able to decode the significance of fake
> > VLAN headers that DSA uses to separate switch ports.
> >
> > But currently these have no global significance - they are simply an
> > ordered list of DSA_MAX_SWITCHES x DSA_MAX_PORTS numbers ending at 4095.
> >
> > The reason why this is submitted as a fix is that the existing mapping
> > of VIDs should not enter into a stable kernel, so we can pretend that
> > only the new format exists. This way tcpdump won't need to try to make
> > something out of the VLAN tags on 5.2 kernels.
> >
> > Fixes: f9bbe4477c30 ("net: dsa: Optional VLAN-based port separation for switches without tagging")
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>
> This looks a lot nicer actually, and kudos for documenting the format.
> --
> Florian

Please don't merge this. The MBZ bit doesn't actually prevent the VID
from taking the reserved value of 0. I don't know what I was thinking.
I'll send out a v2 soon.

Thanks,
-Vladimir
