Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D9428AE01
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 07:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgJLF4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 01:56:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36378 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbgJLF4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 01:56:30 -0400
Received: from mail-lj1-f198.google.com ([209.85.208.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1kRqou-0002CJ-0P
        for netdev@vger.kernel.org; Mon, 12 Oct 2020 05:56:28 +0000
Received: by mail-lj1-f198.google.com with SMTP id h6so6103169ljl.11
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 22:56:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MG6dr6dkYjbuidZHOqbfSuEQ8chzRGiJ/r5QM2M/mPI=;
        b=CwJKSENH/SG1SarTNaNG8bKUiokKFcp7OwxY5Alssoc4UjNJofmUajQzP0LR0gsep2
         2VKtBp2tVR7tt44oX/LH3zFyADif4kC+7cqFibLmWuUW78FFK5qNgig2Zs8XaXYmj2ne
         qJo4L73PON2vPthMJfVV3QfG4wlFzdVqh5LD0JpccJ7M4FwBCBApLHdCCtQFhL+LzQJb
         QHDpBI4B6zDYyqRF+8qQw07Aff39hp6l1WSQK2Yn521bQHcE8w6fG51XNAxt46TlKrWx
         DDNd0V4MyKvlTfhSgn2LypmRXr7qiv7YElq+W3Ygr7t0kbZMUlC+79KIWsBwaVYnBRdv
         gyTA==
X-Gm-Message-State: AOAM531vbacPYIBgdoV/udxiLxmM7EfhTA0gcxg6o6G6Q/cybuvX+vzn
        Lg1yp7+MDeHrp6Xq8C/XBqDFF2XGokn/aAOuf7sPKxdy2gPvMQtSDCZarCAImIRnwwaZIl4uCHQ
        9JLPM6hXbJ0BWzPM5HgX4rwDEej7/2yPWCiHmMx90VGON4flg
X-Received: by 2002:ac2:5e6c:: with SMTP id a12mr1947639lfr.568.1602482187423;
        Sun, 11 Oct 2020 22:56:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoCKfffCt19WVgrVsF4yF4GyeBHzR1CkXFM5Wcu9g2IAxq3X1X3p1GzScUUEVKhUm+XfQYsVpWEn/D3wEnFNw=
X-Received: by 2002:ac2:5e6c:: with SMTP id a12mr1947631lfr.568.1602482187140;
 Sun, 11 Oct 2020 22:56:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200907035010.9154-1-po-hsu.lin@canonical.com>
 <20200907131217.61643ada@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMy_GT-kaqkcdR+0q5eKoW3CJn7dZSCfr+UxRf6e5iRzZMiKTA@mail.gmail.com> <CAMy_GT-0ad7dnWZ=sVt7kZQSMeKQ-9AXdxTe+LqD4uuFnVd+Vw@mail.gmail.com>
In-Reply-To: <CAMy_GT-0ad7dnWZ=sVt7kZQSMeKQ-9AXdxTe+LqD4uuFnVd+Vw@mail.gmail.com>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Mon, 12 Oct 2020 13:56:15 +0800
Message-ID: <CAMy_GT9hALtE9-qBU95QCR7=VN8hwRps4U=hDjsWeKzssnMbKg@mail.gmail.com>
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

Hello,
Is there any update on this patch?
Thanks!
PHLin

On Fri, Sep 18, 2020 at 6:39 PM Po-Hsu Lin <po-hsu.lin@canonical.com> wrote:
>
> Hello folks,
>
> any thoughts on this patch?
> It can make the test pass and reduce the failure numbers in
> kselftests, it will be great to have this applied.
>
> Thanks
> PHLin
>
>
> On Tue, Sep 8, 2020 at 2:57 PM Po-Hsu Lin <po-hsu.lin@canonical.com> wrote:
> >
> > On Tue, Sep 8, 2020 at 4:12 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Mon,  7 Sep 2020 11:50:10 +0800 Po-Hsu Lin wrote:
> > > > The kci_test_encap_fou() test from kci_test_encap() in rtnetlink.sh
> > > > needs the fou module to work. Otherwise it will fail with:
> > > >
> > > >   $ ip netns exec "$testns" ip fou add port 7777 ipproto 47
> > > >   RTNETLINK answers: No such file or directory
> > > >   Error talking to the kernel
> > > >
> > > > Add the CONFIG_NET_FOU into the config file as well. Which needs at
> > > > least to be set as a loadable module.
> > > >
> > > > Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> > >
> > > > diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
> > > > index 7c38a90..a711b3e 100755
> > > > --- a/tools/testing/selftests/net/rtnetlink.sh
> > > > +++ b/tools/testing/selftests/net/rtnetlink.sh
> > > > @@ -520,6 +520,11 @@ kci_test_encap_fou()
> > > >               return $ksft_skip
> > > >       fi
> > > >
> > > > +     if ! /sbin/modprobe -q -n fou; then
> > > > +             echo "SKIP: module fou is not found"
> > > > +             return $ksft_skip
> > > > +     fi
> > > > +     /sbin/modprobe -q fou
> > > >       ip -netns "$testns" fou add port 7777 ipproto 47 2>/dev/null
> > > >       if [ $? -ne 0 ];then
> > > >               echo "FAIL: can't add fou port 7777, skipping test"
> > > > @@ -540,6 +545,7 @@ kci_test_encap_fou()
> > > >               return 1
> > > >       fi
> > > >
> > > > +     /sbin/modprobe -q -r fou
> > >
> > > I think the common practice is to not remove the module at the end of
> > > the test. It may be used by something else than the test itself.
> > >
> > Hello Jakub,
> > Thanks for your feedback.
> >
> > For this case I think it's safe to remove the module here, as it was
> > never loaded before and thus causing this test to fail.
> > If other tests in this rtnetlink.sh need this fou module, we should be
> > able to spot those failures too, however this is the only failure as I
> > can see.
> > (pmtu.sh will need fou module to run as well, but it will be loaded there.)
> >
> > Shouldn't we insert the required module whenever the test needs it? So
> > that we can run the test itself directly, without depending on other
> > tests.
> > Also, I can see modules for tests were being unloaded in other tests as well.
> >
> > Thanks
> >
> > > >       echo "PASS: fou"
> > > >  }
> > > >
> > >
