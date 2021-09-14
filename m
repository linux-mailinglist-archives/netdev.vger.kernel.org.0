Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A9540BAE8
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 00:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbhINWFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 18:05:00 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:45563 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbhINWE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 18:04:58 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]) by
 mrelayeu.kundenserver.de (mreue010 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1M1HqM-1mT0c44Bzu-002mr2; Wed, 15 Sep 2021 00:03:39 +0200
Received: by mail-wr1-f48.google.com with SMTP id g16so604033wrb.3;
        Tue, 14 Sep 2021 15:03:38 -0700 (PDT)
X-Gm-Message-State: AOAM533bFzfD1QPDo0LHSl1lDQiaan6eCHGFdYTI/yo2bKB5tPLGUfyp
        E57iYd5P4gxI81a/d/CvYOvGzX6VEXVrt+0eOFs=
X-Google-Smtp-Source: ABdhPJwhAXAnpXRH0/G3EydXtQOLww1rGEpSQchTL8vbfDRnOyiwnZ9a7hWu0kCogOma+gV7tQNgIhLP36LvPFqRwt0=
X-Received: by 2002:adf:914e:: with SMTP id j72mr1380085wrj.428.1631657018586;
 Tue, 14 Sep 2021 15:03:38 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
 <36aa5cb7-e3d6-33cb-9ac6-c9ff1169d711@linuxfoundation.org>
 <CAK8P3a1vNx1s-tcjtu6VDxak4NHyztF0XZGe3wOrNbigx1f4tw@mail.gmail.com>
 <120389b9-f90b-0fa3-21d5-1f789b4c984d@linuxfoundation.org>
 <CAFd5g47MgGCoenw08hehegstQSujT7AwksQkxA7mQgKhChimNw@mail.gmail.com>
 <3bad5d2f-8ce7-d0b9-19ad-def68d4193dd@linuxfoundation.org> <CAFd5g47bZbqGgMn8PVa=DaSFfjnJsLGVsLTYzmmCOpdv-TfUSQ@mail.gmail.com>
In-Reply-To: <CAFd5g47bZbqGgMn8PVa=DaSFfjnJsLGVsLTYzmmCOpdv-TfUSQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 15 Sep 2021 00:03:22 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0wQC+9_3wJEACgOLa9C5_zLSmDfU=_79h_KMSE_9JxRw@mail.gmail.com>
Message-ID: <CAK8P3a0wQC+9_3wJEACgOLa9C5_zLSmDfU=_79h_KMSE_9JxRw@mail.gmail.com>
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Brendan Higgins <brendanhiggins@google.com>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com, Wei Liu <wei.liu@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        KUnit Development <kunit-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:TGKoNGYg3XZ12X86bn6RKRgu+uL9/g8js96eejetf0UEDglfL2x
 PVN8Ua0qYSc9kXSY4DsJiQEiOCyFtN4A6SOuDMFkRHWpKNXTToVm1Lt8we224RgSkthBXSc
 GoLfVJW4mw+QVHRa2ehWKPt2ESxQ2FZuUiM76ZAoNdtIN2+5MYGs7LI/GJ/KVVZBjx3bQyl
 d2EVtdGqBmAi6lNybAucg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ryhRnBOopLo=:zztz24XlEDgzhvfcn38+q2
 i9P6qVZT9jo9judsStpheGS4GD8N4Pdh5cbeWIlHg/a6tExvNgmteHmIR8ynDc/IWPjDMkEmS
 U65A1kPe6bVI92yJDm1/k4br+2oJFStdvabzegFIy2YxHo+3Ngh3XAi1ijMGOiFQSMh+wmc0r
 kKwpLeEkdz11RfLgFRoJmivyuv5tck0KGkmyjF8LuxyFdc80hQH9LYi5BgK/DWefPqDe9eHHz
 mx/ODG6/s7suZ8XdUBTaURes+g5Jai0bZiQuQkEumGgt+pIctbZCwEQ85HuNhoHhI+aRjDUlt
 AlNXNnKisRNmguHWhY68AmpJVWMYHxyt2QwpRet6J7Tx9g/LnXtC1f65CBF/oo0nfsClfgtmv
 JrJpvr05D6aNae+bdOwFAd+a/O3ObN7lmpBqlB/zRXr2Ofpjh4jjeOhLWcex7Ov4GGe8EDrU4
 M9dH5bxjD4JFEclZd4mIY6jTPVkN6g8GaLEmffDlTo2RnvjK2SsF6yLZMAhsZf7M/bqBMqc9K
 U5be3jIUpTSGkSNGT/AiqXZKjPRBLkEDxEIHYDaA0MX+FGGK2/+awsmONVLYZlQyUeVEdjS2w
 g89gIrhdyc2rYC4r5pQE0yRANra7hhjw1iwKYt7yVfdUBxFMprJNd+/lfKlMtDeAJBNqfNGYw
 awnG2chADN9Zflee4CvCYU93sJEmJ+eIMQyWI8bdpUc0+MQXdsBvVgKU8G0m2jySosv5IQHeD
 /JX6OcTj8xyZrqT/2kJwtUNkyLH9doWrHQs14CRSSIwbmBgoZ7YK5t6mYe/su2aRRUdcN4owz
 B6Lu5qTMBURqLYRfzxwxDI+O5xKnoivvdTusaD+1jOi5iefbfJSR4jJH2V12YCCt8j0r1QS5t
 SqbSO1kelwQPLSBHDDDw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 10:48 PM Brendan Higgins
<brendanhiggins@google.com> wrote:
>
> On Mon, Sep 13, 2021 at 1:55 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
> >
> > On 9/8/21 3:24 PM, Brendan Higgins wrote:
> > Brendan,
> >
> > Would you like to send me the fix with Suggested-by for Arnd or Kees?
>
> So it looks like Arnd's fix was accepted (whether by him or someone
> else) for property-entry-test and Linus already fixed thunderbolt, so
> the only remaining of Arnd's patches is for the bitfield test, so I'll
> resend that one in a bit.
>
> Also, I haven't actually tried Linus' suggestion yet, but the logic is
> sound and the change *should* be fairly unintrusive - I am going to
> give that a try and report back (but I will get the bitfield
> structleak disable patch out first since I already got that applying).

Looking at my randconfig tree, I find these six instances:

$ git grep -w DISABLE_STRUCTLEAK_PLUGIN
drivers/base/test/Makefile:CFLAGS_property-entry-test.o +=
$(DISABLE_STRUCTLEAK_PLUGIN)
drivers/iio/test/Makefile:CFLAGS_iio-test-format.o +=
$(DISABLE_STRUCTLEAK_PLUGIN)
drivers/mmc/host/Makefile:CFLAGS_sdhci-of-aspeed.o              +=
$(DISABLE_STRUCTLEAK_PLUGIN)
drivers/thunderbolt/Makefile:CFLAGS_test.o += $(DISABLE_STRUCTLEAK_PLUGIN)
lib/Makefile:CFLAGS_test_scanf.o += $(DISABLE_STRUCTLEAK_PLUGIN)
lib/Makefile:CFLAGS_bitfield_kunit.o += $(DISABLE_STRUCTLEAK_PLUGIN)
scripts/Makefile.gcc-plugins:    DISABLE_STRUCTLEAK_PLUGIN +=
-fplugin-arg-structleak_plugin-disable
scripts/Makefile.gcc-plugins:export DISABLE_STRUCTLEAK_PLUGIN

Sorry for failing to submit these as a proper patch. If you send a new version,
I think you need to make sure you cover all of the above, using whichever
change you like best.

        Arnd
