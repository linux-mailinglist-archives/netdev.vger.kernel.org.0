Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FF43E14A3
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 14:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241307AbhHEMWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 08:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232651AbhHEMWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 08:22:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBF1561151;
        Thu,  5 Aug 2021 12:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628166142;
        bh=CJnycGuOiOO7pYToDEB8B8b344U6ZnxE1+ipdNSRUsk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kcyGE1qXA186Z7sn/qPKafN4zLund0bRdxxguTuJkoqjHoQubGQz8t+PmDNwKY89k
         bpQuGRzG3ZERuFDsY5UQGnAF2oyiynamS+xtg2iJ2oA0CfapoA13Kh7ovLAVgkLLif
         bEzYOlF3PBL62T91411m2ywZznUshDZJ5AS6C99d5420+RLPV/weWgmw6yeYwEModn
         MBpE+wJAtXTRq/yHxLN0WABKzkmQZ5tp1oNlCpYp/4MfF1OFQ7DD16T2NUQskWyXIK
         Bchs1RNEMlmmd2SHVTu6Lny3SDP5nRyp/si9qb2N00q8mx/ophCKgTrqYdus9tLEhx
         7KSCBwZCS2meQ==
Received: by mail-wr1-f43.google.com with SMTP id h13so6295194wrp.1;
        Thu, 05 Aug 2021 05:22:21 -0700 (PDT)
X-Gm-Message-State: AOAM530DTsohpBcXm54E5qt93UZVOfTQ8hXBRo6ET+TIc7DKbuPSxFOI
        o1hcb+Q5s87FbRveKBqEMxqer1MA2vG7FvT9o64=
X-Google-Smtp-Source: ABdhPJwv8Oj2kPOxLGBcS2bRTqaTF3dz2wz4rDvZnHdf6YV48nwBMHQ5JZaGCU7SNzHubRRNf8Ggj1xl8CCjU4LtWU0=
X-Received: by 2002:a5d:44c7:: with SMTP id z7mr5117225wrr.286.1628166140523;
 Thu, 05 Aug 2021 05:22:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210805110048.1696362-1-arnd@kernel.org> <20210805112546.gitosuu7bzogbzyf@skbuf>
 <CAK8P3a0w95+3dBo5OLeCsEi8gjmFqabnSeqeNPQq49=rPeRm=A@mail.gmail.com> <20210805121754.uo4umz7wiayyu7y4@skbuf>
In-Reply-To: <20210805121754.uo4umz7wiayyu7y4@skbuf>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 5 Aug 2021 14:22:04 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0Yh-0J=Q-=g1+peSX9gtn36v-a5G14ubf-1gmBtCH4fw@mail.gmail.com>
Message-ID: <CAK8P3a0Yh-0J=Q-=g1+peSX9gtn36v-a5G14ubf-1gmBtCH4fw@mail.gmail.com>
Subject: Re: [PATCH net-next] dsa: sja1105: fix reverse dependency
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 5, 2021 at 2:17 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Thu, Aug 05, 2021 at 01:39:34PM +0200, Arnd Bergmann wrote:
> > I will give this a little more testing and resend
> > later with that change.
>
> Btw, not sure if you noticed but I did send that out already:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210805113612.2174148-1-vladimir.oltean@nxp.com/

Yes, saw it, but only after my reply. I don't expect any problems with it, but
it's in my test tree now and I'll let you know if something comes up.

      Arnd
