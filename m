Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBE828AF9D
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgJLIGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:06:04 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:59127 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbgJLIGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:06:00 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MmyzH-1k1NRZ3Dpn-00kBsu; Mon, 12 Oct 2020 10:05:58 +0200
Received: by mail-lj1-f174.google.com with SMTP id f21so16037114ljh.7;
        Mon, 12 Oct 2020 01:05:58 -0700 (PDT)
X-Gm-Message-State: AOAM532N25/2X22aC76qWHWmr34EXm6q5RFJq4tz+6wLlsX4PatSs8ZL
        Gv0Yx0AHw7RFTyAGMMMmXoFKLoLbLv/CrwiaFlU=
X-Google-Smtp-Source: ABdhPJxS6wV0vhDGnBBN3sI1mG+/HmqrAaufbkoo+5e/qZJqHDf/hgfM+I/EDrtpzKMmxRZAg/9HoOszLqENstcIhpY=
X-Received: by 2002:a2e:83c9:: with SMTP id s9mr9723391ljh.168.1602489958217;
 Mon, 12 Oct 2020 01:05:58 -0700 (PDT)
MIME-Version: 1.0
References: <20201001011232.4050282-1-andrew@lunn.ch> <20201001011232.4050282-2-andrew@lunn.ch>
 <CAKwvOdnVC8F1=QT03W5Zh9pJdTxxNfRcqXeob5_b4CXycvG1+g@mail.gmail.com>
 <20201002014411.GG4067422@lunn.ch> <CAK8P3a0tA9VMMjgkFeCaM3dWLu8H0CFBTkE8zeUpwSR1o31z1w@mail.gmail.com>
 <CAK7LNARRchbhDNUT3paTVpOJYKR-D_+HLzjG-wsOOM+LO5p3sA@mail.gmail.com>
In-Reply-To: <CAK7LNARRchbhDNUT3paTVpOJYKR-D_+HLzjG-wsOOM+LO5p3sA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 12 Oct 2020 10:05:41 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3GP005UEwET=CUSw3aNdbCVoscCm2g0kpJYeKTv7NhjQ@mail.gmail.com>
Message-ID: <CAK8P3a3GP005UEwET=CUSw3aNdbCVoscCm2g0kpJYeKTv7NhjQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] Makefile.extrawarn: Add symbol for W=1
 warnings for today
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:MqWFNY9vicRCWHvVbRfdumHCAl7LVXS70IX7Wopf2kYB0syWARO
 FmEqbVttPrpwa3pYXCJKI48p7d/DFvucTKfCWJ3/CX2CbufMp/qdjB+iIRw3Ll+h2WaDClI
 Qi5E4rbbY9lwOBn3Ac5qpL99Ar8XA9xBEf7ZNpoLoAbzrSWir6/DhMtH3oUue0cWE0rbJmI
 yDOMB1SgGKIIrLsaI97Rw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Bon+mx5Nnfk=:04oqhYp8CuF57BtJd0kA9H
 SHoittodNQNmFDHFte01z0JjEX6lDpmzeyDptOFUGI4xB5bvR1NEzYTPw68vMJwpLLuYsEUHj
 7VMGevMyimusBM5G6qT7UwqKEN7UfNqcv2m5jpzmFwt9hjqfLZsg7KP4r/YxXIo+R/OxzS5D4
 W7JK86XjyQx9nb0NH8gezz/jH/R2H7wVn8ynuB1SX6dzpUtLIz4Gx+Hb/U94W5vdizSuVy3iz
 wqiJMLV7qZlHJcDcDvuu7LCqzRKRtayb/KAnhRwYTCQAhsWnm+DyG1cxfFZYg2EuuBnTGZ174
 qd3d+YgZv3Qus6aRKPNw9rzFYXm17GGSW6dYC8IkuE3susbB5eBanoxxdYTnDuIHfbkbOMth5
 TozyXaDNuJOUyCUEpNvedfWBNTNs0ql2skA4/vCwpDjNfqAMrWNLXmjEBaSajGPCLBr3AEM8w
 xfELawuCr5VggLuBo9RxUYAIMimkiTPYyOxmRIFZeXd5sZhX6cRbA/EcGZyctO6+b8Oa/Nw9o
 SYA5QPlBarzaK9vTpMsKzcnD1U3Syh/gSp3WRGILjpp78k10IaH0Xka8Czu4pPFZJxtk4BcIF
 qD38PyIBhWgnYOifp0CgWLruLfET3g/EZhGuS0U8JASAOJqyC7Nl7qMbJp57vfOWkCJI92JwK
 zvYAfP1PVOqcDQ5GoVF6QWdLvhKuWkXng7yxwtFZg45hbaEEcF3+36+jqWw/zryYycn1hfFVs
 y+xtifVtrT11NWG61eIddjjVAwfzm+I1NNXkNCW/oM5XVYJBUJx2Eyo2wJkESMiBMkl8gkEcl
 LSdPvi+iVYZkWcZNsae6drsgYVZe0L1VLOUsu7VpcgRqbsUdc4ffy+NHN2u56CcnaWCz5yVPX
 b/vsRP44LyGWK+qYfJicf1cGXnfAdxFJaWiLa/tCCm3eG3LDxoqpCAtN0apAmyIY5dpZuooE3
 mSOdllNwx5cL3LngwG73nZVYbDGBVD2ATnzIROnuHSvB96/V8jQSR
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 3:00 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> BTW, if possible, please educate me about the difference
> between -Wmissing-declarations and -Wmissing-prototypes.
>
...
> Do we need to specify both in W=1 ?
> If yes, what is the difference between them?

I think they do the same thing in the kernel, as we already set
 '-Wstrict-prototypes', which requires that there are no declarations
without having a prototype first. Adding either one should be sufficient.

      Arnd
