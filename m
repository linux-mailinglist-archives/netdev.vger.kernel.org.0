Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F4F26FB01
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgIRK5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:57:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35006 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgIRK5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:57:07 -0400
X-Greylist: delayed 1035 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 06:57:05 EDT
Received: from mail-lj1-f199.google.com ([209.85.208.199])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1kJDnx-00071O-Cw
        for netdev@vger.kernel.org; Fri, 18 Sep 2020 10:39:49 +0000
Received: by mail-lj1-f199.google.com with SMTP id j4so1931290ljo.1
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:39:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8TQIpEkK3UURZSuTWdFxaxjlA5aeVAZ+3spWA7nEMrY=;
        b=SEPYMtp93kIym79CoCWiMV1kfLu4Q+cVUMQSLXeNaI1d/bL0V19Q7IHJG0fTuCwXv0
         dpjE3xsUwZtCyeROzV+LYwY7Omo9mXvnF7kOPdbslTjHy+1S2y8SYpaiMU8Lh66PD9uB
         ZeNGqLPqwPiq8NGExXf9qwAv2SzPGxGoxQxOT8A0L4lvAT1cjK1UEyopgYpSs4ALrIbb
         Q6DsDZxlxKZO5E+y8EHXEAs4/FQEkdBT2wXQ8EsbBByyolBv3j9zb8ktuKVWi/B9O/Rm
         yl/nPu8UAqMSK3E5rh38QYWnqvUrIUL0C91rdftB/w9vxf1fXpc9991uctwWEbYu2muY
         ObJg==
X-Gm-Message-State: AOAM5313V3DUOPJz9fh2PVQ41jhp4pOzDe2tamFHymL8w+K7xkf7qJOW
        V74N4O/M5vE6HfmfEHwH2NYEmyFr8svCu9HmOYaxiszMxpXargmrWs3nkyGSoq5kqLOmfJka5UK
        23ns53rW+JEZZi9LZF3LVcXYzRbOC6jzv8OlzqvOBGkT7OS+x
X-Received: by 2002:a2e:9a0c:: with SMTP id o12mr12181068lji.191.1600425588783;
        Fri, 18 Sep 2020 03:39:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjdifQSj/on5KrMw8Uc/IRsfoxNs9Bf+W2IqpozLJMGxB4ZcAjvQ0UDDusCs6H/dI1hVNWjY2TLNHtYxHpBrY=
X-Received: by 2002:a2e:9a0c:: with SMTP id o12mr12181057lji.191.1600425588488;
 Fri, 18 Sep 2020 03:39:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200907035010.9154-1-po-hsu.lin@canonical.com>
 <20200907131217.61643ada@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAMy_GT-kaqkcdR+0q5eKoW3CJn7dZSCfr+UxRf6e5iRzZMiKTA@mail.gmail.com>
In-Reply-To: <CAMy_GT-kaqkcdR+0q5eKoW3CJn7dZSCfr+UxRf6e5iRzZMiKTA@mail.gmail.com>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Fri, 18 Sep 2020 18:39:37 +0800
Message-ID: <CAMy_GT-0ad7dnWZ=sVt7kZQSMeKQ-9AXdxTe+LqD4uuFnVd+Vw@mail.gmail.com>
Subject: Re: [PATCHv3] selftests: rtnetlink: load fou module for
 kci_test_encap_fou() test
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello folks,

any thoughts on this patch?
It can make the test pass and reduce the failure numbers in
kselftests, it will be great to have this applied.

Thanks
PHLin


On Tue, Sep 8, 2020 at 2:57 PM Po-Hsu Lin <po-hsu.lin@canonical.com> wrote:
>
> On Tue, Sep 8, 2020 at 4:12 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon,  7 Sep 2020 11:50:10 +0800 Po-Hsu Lin wrote:
> > > The kci_test_encap_fou() test from kci_test_encap() in rtnetlink.sh
> > > needs the fou module to work. Otherwise it will fail with:
> > >
> > >   $ ip netns exec "$testns" ip fou add port 7777 ipproto 47
> > >   RTNETLINK answers: No such file or directory
> > >   Error talking to the kernel
> > >
> > > Add the CONFIG_NET_FOU into the config file as well. Which needs at
> > > least to be set as a loadable module.
> > >
> > > Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> >
> > > diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
> > > index 7c38a90..a711b3e 100755
> > > --- a/tools/testing/selftests/net/rtnetlink.sh
> > > +++ b/tools/testing/selftests/net/rtnetlink.sh
> > > @@ -520,6 +520,11 @@ kci_test_encap_fou()
> > >               return $ksft_skip
> > >       fi
> > >
> > > +     if ! /sbin/modprobe -q -n fou; then
> > > +             echo "SKIP: module fou is not found"
> > > +             return $ksft_skip
> > > +     fi
> > > +     /sbin/modprobe -q fou
> > >       ip -netns "$testns" fou add port 7777 ipproto 47 2>/dev/null
> > >       if [ $? -ne 0 ];then
> > >               echo "FAIL: can't add fou port 7777, skipping test"
> > > @@ -540,6 +545,7 @@ kci_test_encap_fou()
> > >               return 1
> > >       fi
> > >
> > > +     /sbin/modprobe -q -r fou
> >
> > I think the common practice is to not remove the module at the end of
> > the test. It may be used by something else than the test itself.
> >
> Hello Jakub,
> Thanks for your feedback.
>
> For this case I think it's safe to remove the module here, as it was
> never loaded before and thus causing this test to fail.
> If other tests in this rtnetlink.sh need this fou module, we should be
> able to spot those failures too, however this is the only failure as I
> can see.
> (pmtu.sh will need fou module to run as well, but it will be loaded there.)
>
> Shouldn't we insert the required module whenever the test needs it? So
> that we can run the test itself directly, without depending on other
> tests.
> Also, I can see modules for tests were being unloaded in other tests as well.
>
> Thanks
>
> > >       echo "PASS: fou"
> > >  }
> > >
> >
