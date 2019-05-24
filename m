Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 887C629042
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 07:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731880AbfEXFC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 01:02:58 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38944 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbfEXFC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 01:02:58 -0400
Received: by mail-ed1-f66.google.com with SMTP id e24so12487189edq.6;
        Thu, 23 May 2019 22:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cKIZDHhM23UDx19n3GdofpP2QbyBXWvdFRSPtj7m9HE=;
        b=oRa09WzYVDPLaZ5iPjcgR/bdIyyuzBl/O6xLgj1mU3su+ZBKB6CTACAztrwNZRHF/z
         zacN60isAAh630eywgOtMVB/pSfUCxtSzA/9F3IrWGJd9rwpVzB0TdEwG4H4Y1RR18LO
         MFvS0kFs4D2zRrX60Y84cF6DxY6mtyc6+cYaCjdn8hL38av9jkWagvo3EkVcXVZppKyr
         MydepX+75ROuH7POzzS+CziyKp9ObYCStkZqFSY1b7YTaqk1Ah8aYbPtWOSnsA28i/H8
         F0Byu4s7Ntw1fzM2lO8xZZDnJ8pcw3fIoteLVoiKsrrJAqW3ZV6ds0r5EjeF4YNzz5Vi
         llBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cKIZDHhM23UDx19n3GdofpP2QbyBXWvdFRSPtj7m9HE=;
        b=Ishs46iAlERNRe+EfI9+eV/YlJ4fIfZvtjbvEXyJPINfGh8mbE7/Pxd/krg2xro4EY
         021B2IMavKtROkFNZZwy/xVHvpHefXryt0N7A38s1KdDQiExsQv2v6tV4w3v8Vh3t98O
         FzpyNMknFbPfG3+K/S/OotThhZQLKq+AbKRFdIhlTYqKKCbMphLh58K1oWB0zcyNDNqs
         8xzLjqlj6SR5I8/Qunpt2AwJgddiKw3bIlDVvgy9xVPTs7bwskKPcdRbvHxXMalRHcRI
         Jgark2GF1+4Jx3jEMCvANoUO0kqskHMRsv+H0aw9WcumBQIROI7kutpCK0pQlKbWf/6r
         XqcQ==
X-Gm-Message-State: APjAAAVJeizy3h442ngtT68kYmcPfKpWPd72FgAP34EtVvQn0fNbFrRY
        u9Eb9/GaHxMnFQ+0Z2reiE+R+S5Txf1W/zilSjY=
X-Google-Smtp-Source: APXvYqyA2P6rJ5Rpgaw8f2+M2ICv1VNxQnaI17Q7cCTaCC06j3aE+a5kT2N0nDt4xBozCWvy5ZXtss4pe/5LVrwSnxo=
X-Received: by 2002:a50:f5d0:: with SMTP id x16mr100304375edm.287.1558674176088;
 Thu, 23 May 2019 22:02:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190523210651.80902-1-fklassen@appneta.com> <20190523210651.80902-5-fklassen@appneta.com>
 <CAF=yD-KBNLr5KY-YQ1KMmZGCpYNefSJKaJkZNOwd8nRiedpQtA@mail.gmail.com> <D68C643B-C6A4-4EC5-8E4F-368BDE03760B@appneta.com>
In-Reply-To: <D68C643B-C6A4-4EC5-8E4F-368BDE03760B@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 24 May 2019 01:02:20 -0400
Message-ID: <CAF=yD-JGxrAbv0Cxcn1O20mXY28J1PnpWsHRqcRPO97advm10A@mail.gmail.com>
Subject: Re: [PATCH net 4/4] net/udpgso_bench_tx: audit error queue
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 9:27 PM Fred Klassen <fklassen@appneta.com> wrote:
>
> Willem, this is only my 2nd patch, and my last one was a one liner.
> I=E2=80=99ll try to work through this, but let me know if I am doing a ro=
okie
> mistake (learning curve and all).

Not at all. The fix makes perfect sense.

The test patches 2 and 4 are not fixes, so are better suited to to
net-next. Perhaps the changes to the test can also be more concise,
just the minimal changes needed to demonstrate the bug and fix.

> >>                        tss =3D (struct my_scm_timestamping *)CMSG_DATA=
(cmsg);
> >> -                       fprintf(stderr, "tx timestamp =3D %lu.%09lu\n"=
,
> >> -                               tss->ts[i].tv_sec, tss->ts[i].tv_nsec)=
;
> >> +                       if (tss->ts[i].tv_sec =3D=3D 0)
> >> +                               stat_tx_ts_errors++;
> >> +                       if (cfg_verbose)
> >> +                               fprintf(stderr, "tx timestamp =3D %lu.=
%09lu\n",
> >> +                                       tss->ts[i].tv_sec, tss->ts[i].=
tv_nsec);
> >
> > changes unrelated to this feature?
>
> I=E2=80=99ll remove. Do you think that I should pull out any messages rel=
ated
> to =E2=80=9Ccfg_verbose=E2=80=9D?

This change did not seem relevant to the main feature of the patch.
