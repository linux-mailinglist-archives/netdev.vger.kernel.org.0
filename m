Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC7891026
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 12:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfHQKo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 06:44:28 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43855 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfHQKo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 06:44:27 -0400
Received: by mail-ed1-f65.google.com with SMTP id h13so7198161edq.10;
        Sat, 17 Aug 2019 03:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LF5Ug8gWxI6H2xb/E/SdUzqI4ChF9q52pqIFSSBLhXg=;
        b=KHFXb6vGMrTrAkGENpnON204JGQkrNm9iV0L+8DWlvRAQfXs43VDGFqAAyufqLbSws
         wSl6InxpK7Xrf8fkrnktcKm/HPeRhSI4PEfSaRwh99EI+37pwwUJ59OgeRmqu2kEUJuH
         TUokXCWM2E8jwmIHoJvF0GAvXnu+O3u9VU2ot+TkyVFfLMNQuq9S8SYdFRjZ+cA+KYLc
         O0X8MNOM+z4Bs7o9lEPoLmBlho/g2jd+NjDPDviGc9OM1ROkYeZlOTg0eUpytiPDJ++N
         EIqy7sWdpIDsFiS71UzGsR8gG8iRNUVNF7PfXmMghs9Jtwg+lPOPskw4JdmpVcIRhLtG
         NsNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LF5Ug8gWxI6H2xb/E/SdUzqI4ChF9q52pqIFSSBLhXg=;
        b=O+EDzUOT7vvq1Ek4pO2V8t5USqpzhXbpYU0jcnhYJYTwN5eGnBb08erl5LPv3CTzMu
         +1i60Vcdren/QO8hxCWrsSx/m8S9zao1RnDiXicp/av9xT9GfCUJjUjNShvy+B1cxD+H
         kGJwtqXWWGs8X6dqaG8zPo4ektAooB6l8k8F2AshM91501ZrYQUmCmriCN9L2miaojtt
         oURGhm6JHI8+uakafjqpxfaEOWsvaLYn0FD+x5ic8Hc8UHvmkVP15WsfAAmaKeLx9snX
         FyUdhukupmtXZV81bhSRgqa3F1Xy1ctUQU/EwJa33w8zEJRnfzjAz/F8JYj0A/qXaADd
         XiCQ==
X-Gm-Message-State: APjAAAXHsSIF0Hf/wSX2aPifTLTbd0RxLMIPS7ZeveY3J6maO6GdY3Ud
        TUEB8jv/OGzIwDhOviI1zifW5rceUAmKTA4ixHQ=
X-Google-Smtp-Source: APXvYqzgnxsnAlGut7FIsqp6mXVN9pu1wXZ0KuF/LjBQUuevWXxoyH72zSuVasgVdua8jDw3Xh+T9VRKHcoDJO6kAbE=
X-Received: by 2002:a17:906:c445:: with SMTP id ck5mr4624139ejb.15.1566038666154;
 Sat, 17 Aug 2019 03:44:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190816004449.10100-1-olteanv@gmail.com> <20190816004449.10100-5-olteanv@gmail.com>
 <20190816122103.GE4039@sirena.co.uk> <CA+h21hoP3t6j2mTd2BLwizqbFap+9Z2vdxQ4ahHS3-7Vr31Lxw@mail.gmail.com>
 <20190816125942.GG4039@sirena.co.uk>
In-Reply-To: <20190816125942.GG4039@sirena.co.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 17 Aug 2019 13:44:14 +0300
Message-ID: <CA+h21hr=fZ2XX3BF=YSCS86zfy9rGZDaji-VjFDVWhdcA8ppqw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 04/11] spi: spi-fsl-dspi: Cosmetic cleanup
To:     Mark Brown <broonie@kernel.org>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>, mlichvar@redhat.com,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Aug 2019 at 15:59, Mark Brown <broonie@kernel.org> wrote:
>
> On Fri, Aug 16, 2019 at 03:37:46PM +0300, Vladimir Oltean wrote:
> > On Fri, 16 Aug 2019 at 15:21, Mark Brown <broonie@kernel.org> wrote:
>
> > > This is difficult to review since there's a bunch of largely unrelated
> > > changes all munged into one patch.  It'd be better to split this up so
> > > each change makes one kind of fix, and better to do this separately to
> > > the rest of the series.  In particular having alignment changes along
> > > with other changes hurts reviewability as it's less immediately clear
> > > what's a like for liken substitution.
>
> > Yes, the diff of this patch looks relatively bad. But I don't know if
> > splitting it in more patches isn't in fact going to pollute the git
> > history, so I can just as well drop it.
>
> No problem with lots of patches in git history if you want to split it
> up (and probably split it out of the series).  Like I say it's mainly
> the alignment changes that it'd be better to pull out, the others really
> should be but it's easier to cope there.

Yes, normally it would make sense to pull these out of the patchset.
But basically all the future patches I plan to send to net-next for
this release somehow depend on this dspi driver rework.
My plan was that once the patchset reaches a stage where you accept
it, to ask Dave M. to temporarily pull the series into net-next as
well, so that the tree compiles and I can continue to work on other
sja1105 stuff. He can then drop it during the merge window. From that
perspective, even if the entire series takes more time to get accepted
rather than individual bits, at least there would be 1 single patchset
for Dave to pull.
Let me know if there's a better way to handle this.

Thanks,
-Vladimir
