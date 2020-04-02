Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1B7A19BD24
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 09:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387655AbgDBH6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 03:58:15 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46511 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgDBH6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 03:58:15 -0400
Received: by mail-lj1-f196.google.com with SMTP id r7so2157031ljg.13
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 00:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=lbDh9sGXngdhn9Jh8C6oZaKlG1DNYVAa7PojnE5vWdk=;
        b=DD6JgrL8yF39MxS5PpkI2Rw/KTHYk4nI/6xo+IRW/zuqhtA9Hc4qIfIbx2LJCS+Cjs
         d6ZsqhG6yKe/C4XJX2JrdkNx7Y6urH55e8bLz4IyTF4IJ6AkpsdsHJPGhnk5Iqsp8FTk
         v6OoSBh0D8ccNE7HgfJ8gqyRvJdoBGnhocKFjtWJiwLRh8BQLsbjBWZcxiMHmDID7k3r
         yqN6qSkixvLWjszVqQuEqyfyXHSyGH1ObGLCfbyDF/Ma2NZt7QVLd3RvbQZwnrqrTIPR
         GYLJ9YM5loJ67+IuZ90XJxy3b+wVTHIJnpHxO5M+8asrx0W293watQBNLBwOayh9in75
         n02Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=lbDh9sGXngdhn9Jh8C6oZaKlG1DNYVAa7PojnE5vWdk=;
        b=UfKA1e12MlNvz9pnlXVlHJSWhuiB/TLncT0iV2vdGEq5gxhpLqld4ULe6j6VIp8uQR
         KV8bo0PINSggT/aFEZQhH1gUjNXZj8pq9Oa9cvktIxOGyfYTYBfenYNRPIkV+eIO3tNj
         nyFS8pKbWcSloxI8nBtvufRcOkjBxv5tACQp8tlLrJG0dDvACWwVsKzWnQLSeMtSEnjE
         wps8sX4vBd20O3zK79YPDuK/+L/8Z9cUTxwKTF0swMjCWwwRCnSFKzhDt42XNAgqVawu
         jYA8VrLBQV7xsbFut6Wd6+B2gzuKxzWXc1O4Rrfpl4nzNPSu9y92BUOqqXEnk4OHUpUP
         7U9A==
X-Gm-Message-State: AGi0Pua52i2SA8M4Y1MGZV3Czo80snBjaB97klynXw665uRpXSmAX+eG
        6C0PZuVNOP+97QsWZbRFUcsh
X-Google-Smtp-Source: APiQypKsVxbu7x6sHS9dSwQFgJAP48asDP5+nyFjAe07VJP0WG9v8qLpP+uZQj4BJmxFoTtZwEysXA==
X-Received: by 2002:a2e:9611:: with SMTP id v17mr1232229ljh.115.1585814291641;
        Thu, 02 Apr 2020 00:58:11 -0700 (PDT)
Received: from ?IPv6:2a00:1370:8117:aa18:ddbf:b317:48a7:bf0f? ([2a00:1370:8117:aa18:ddbf:b317:48a7:bf0f])
        by smtp.gmail.com with ESMTPSA id n17sm2721968ljc.76.2020.04.02.00.58.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Apr 2020 00:58:10 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH v3] bitfield.h: add FIELD_MAX() and field_max()
From:   Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>
In-Reply-To: <CAKwvOdnO2=yjEerw50b_C2vrgdCh2es6ZRfQpBRVR9RCrvwi6Q@mail.gmail.com>
Date:   Thu, 2 Apr 2020 10:58:09 +0300
Cc:     Alex Elder <elder@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5F165F1C-C1E8-43D0-AC8A-5572B36D3370@linaro.org>
References: <20200311024240.26834-1-elder@linaro.org>
 <20200401173515.142249-1-ndesaulniers@google.com>
 <3659efd7-4e72-6bff-5657-c1270e8553f4@linaro.org>
 <CAKwvOdn7TpsZJ70mRiQARJc9Fy+364PXSAiPnSpc_M9pOaXjGw@mail.gmail.com>
 <3c878065-8d25-8177-b7c4-9813b60c9ff6@linaro.org>
 <CAKwvOdnZ-QNeYQ_G-aEuo8cC_m68E5mAC4cskwAQpJJQPc1BSg@mail.gmail.com>
 <efd2c8b1-4efd-572e-10c5-c45f705274d0@linaro.org>
 <CAKwvOdnZ9KL1Esmdjvk-BTP2a+C24bOWguNVaU3RSXKi1Ouh+w@mail.gmail.com>
 <5635b511-64f8-b612-eb25-20b43ced4ed3@linaro.org>
 <CAKwvOdnO2=yjEerw50b_C2vrgdCh2es6ZRfQpBRVR9RCrvwi6Q@mail.gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 2 Apr 2020, at 03:26, Nick Desaulniers <ndesaulniers@google.com> =
wrote:
>=20
> On Wed, Apr 1, 2020 at 4:18 PM Alex Elder <elder@linaro.org> wrote:
>>=20
>> On 4/1/20 5:26 PM, Nick Desaulniers wrote:
>>>=20
>>> mainline is hosed for aarch64 due to some dtc failures.  I'm not =
sure
>>> how TCWG's CI chooses the bisection starting point, but if mainline
>>> was broken, and it jumped back say 300 commits, then the automated
>>> bisection may have converged on your first patch, but not the =
second.
>>=20
>> This is similar to the situation I discussed with Maxim this
>> morning.  A different failure (yes, DTC related) led to an
>> automated bisect process, which landed on my commit. And my
>> commit unfortunately has the the known issue that was later
>> corrected.
>>=20
>> Maxim said this was what started the automated bisect:
>> =3D=3D=3D
>> +# 00:01:41 make[2]: *** =
[arch/arm64/boot/dts/ti/k3-am654-base-board.dtb] Error 2
>> +# 00:01:41 make[2]: *** =
[arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dtb] Error 2
>> +# 00:01:41 make[1]: *** [arch/arm64/boot/dts/ti] Error 2
>> +# 00:01:41 make: *** [dtbs] Error 2
>=20
> DTC thread:
> =
https://lore.kernel.org/linux-arm-kernel/20200401223500.224253-1-ndesaulni=
ers@google.com/
>=20
> Maxim, can you describe how the last known good sha is chosen?  If you
> persist anything between builds, like ccache dir, maybe you could
> propagate a sha of the last successful build, updating it if no
> regression occurred?  Then that can always be a precise last known
> good sha.  Though I don't know if the merge commits complicate this.

Well, since you asked, the simplified version is =E2=80=A6

Bisection is done between =E2=80=9Cbaseline" commit and =E2=80=9Cregressed=
=E2=80=9D commit, not between "last known-good=E2=80=9D commit and =
=E2=80=9Cbad=E2=80=9D commit.  Each build has a metric, and regression =
happens when metric for new build is worse than metric for baseline =
build.  For tcwg_kernel jobs the metric is the number of .o files =
produced in the kernel build (i.e., build with 18555 .o files is worse =
than build with 18560 .o files).

If a new build hasn=E2=80=99t regressed compared to the baseline build, =
then baseline metric is set to that of the new build, and baseline =
commit is set to sha1 of the new build.

If the new build has regressed, then bisection between baseline sha1 and =
new sha1 is triggered.  Once bisection identifies the first bad commit, =
CI notification is emailed, and baseline is reset to the first bad =
commit =E2=80=94 so that we detect even worse regressions when they =
occur.

The baseline state is recorded in git repos (with one branch per CI =
configuration):
- metric / artifacts: =
https://git.linaro.org/toolchain/ci/base-artifacts.git/refs/heads
- linux kernel: https://git.linaro.org/toolchain/ci/linux.git/refs/heads
- llvm: https://git.linaro.org/toolchain/ci/llvm-project.git/refs/heads

--
Maxim Kuvyrkov
https://www.linaro.org

