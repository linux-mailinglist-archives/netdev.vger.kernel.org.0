Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB83A4A723
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 18:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbfFRQiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 12:38:11 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46594 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729349AbfFRQiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 12:38:11 -0400
Received: by mail-ed1-f66.google.com with SMTP id d4so22613605edr.13;
        Tue, 18 Jun 2019 09:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jXvYZkP3QgcqTxDSuncKgo4ShXluNam18sSbFv5z5xQ=;
        b=aqBX0fp2a5KdzVqzyq88Qk4VrNCAp8+J6RpZE5ov+uxD89jHzVXUWhbsp5un/nw7s4
         WHy7YH2Lf528kIC9QWinidXkZUMYkpmhxFwuW3nyjfvdo/PTPz6ywVz9REjup6lLTmn5
         TAayu7vmEnQ0Wq0owMSpG5v/eRq8JezKJeF56TNsJn5FGiAGO7+IivzCe5V//Jw25bp7
         NTnDqKJqXQTiqdMSSJRpvwkIerLwk2MWQos+WP0YQzRmNek2qBCcJXmKww8bDT8k0T0m
         Y9l/f1tsoCJQH2qyyo3yUyG7xQBY8nelnODKBWckIb8z2cJs2CqUiNE8M9GRC53kBCRb
         ioPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jXvYZkP3QgcqTxDSuncKgo4ShXluNam18sSbFv5z5xQ=;
        b=NVGBgIimjXr4k3cSNJFpe6YHxJK2R7wxFgHsI7Ia8S9OHiCZY9dXiXCGTcWOYntqDh
         eqZvp3fvJX45U8P97l6P4f/J3IXe9wnxpidv6Ha2tZj2xmZgL+zTHYV8lQ0r7wC+u3kp
         91TlQpAOur7JHJBKCcz5AuWXfS7TSAye7VmVTV0Q+7aAnOufbRSfL9uUXMrkefuYKmxt
         ymJ5Sbl/Z1X4FYg+LeY4h8jtRh0naBf8vw7dBnsUHY49gKubZRK/2vSojNmk8Pkckl2o
         LgkD19Kj4fBQkHSwzyYLE6jJeAlwZ6NffhCyV5/ZrjuU/r9b4J7N57KIj89X1DW7OVIO
         od3w==
X-Gm-Message-State: APjAAAW/g5E8qfmtOytwRQMj9M+0mDTQ29cs8W4XCeq2tVRcAOAya69T
        2O6j/JX6/r1t72X12IpgyoNAv7YHJrTrvizk3HT4tQ==
X-Google-Smtp-Source: APXvYqw9pH+6wam8u8vh6qWJbTBhm1QeTozsFqj2bAghBHPIFlFM+3Jo3Umal/5U93AZZRzO8XGL3Im4JLIhd+6rzbI=
X-Received: by 2002:a17:906:2acf:: with SMTP id m15mr101493524eje.31.1560875889268;
 Tue, 18 Jun 2019 09:38:09 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYs2+-yeYcx7oe228oo9GfDgTuPL1=TemT3R20tzCmcjsw@mail.gmail.com>
 <CA+FuTSfBFqRViKfG5crEv8xLMgAkp3cZ+yeuELK5TVv61xT=Yw@mail.gmail.com> <20190618161036.GA28190@kroah.com>
In-Reply-To: <20190618161036.GA28190@kroah.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 18 Jun 2019 12:37:33 -0400
Message-ID: <CAF=yD-JnTHdDE8K-EaJM2fH9awvjAmOJkoZbtU+Wi58pPnyAxw@mail.gmail.com>
Subject: Re: 4.19: udpgso_bench_tx: setsockopt zerocopy: Unknown error 524
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Fred Klassen <fklassen@appneta.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 12:10 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jun 18, 2019 at 08:31:16AM -0400, Willem de Bruijn wrote:
> > On Tue, Jun 18, 2019 at 7:27 AM Naresh Kamboju
> > <naresh.kamboju@linaro.org> wrote:
> > >
> > > selftests: net: udpgso_bench.sh failed on 4.19, 4.14, 4.9 and 4.4 branches.
> > > PASS on stable branch 5.1, mainline and next.
> > > This failure is started happening on 4.19 and older kernel branches after
> > > kselftest upgrade to version 5.1
> >
> > Does version 5.1 here mean running tests from Linux 5.1, against older kernels?
> >
> > > Is there any possibilities to backport ?
> > >
> > > Error:
> > > udpgso_bench_tx: setsockopt zerocopy: Unknown error 524
> >
> > MSG_ZEROCOPY for UDP was added in commit b5947e5d1e71 ("udp:
> > msg_zerocopy") in Linux 5.0.
> >
> > The selftest was expanded with this feature in commit db63e489c7aa
> > ("selftests: extend zerocopy tests to udp"), also in Linux 5.0.
> >
> > Those tests are not expected to pass on older kernels.
>
> Any way to degrade gracefully if the feature is not present at all in
> the kernel under test?  People run the latest version of kselftests on
> older kernels all the time.

We add new tests along with new features and bug fixes all the time.
All of those will fail on older kernels, as expected.

I'm honestly surprised to hear that we run newer tests against older
kernels. Is the idea to validate fixes in stable branches? If so,
should we instead backport the relevant tests to those stable
branches? Only the tests that verify fixes, leaving out those for new
features, of course.

Specific to the above test, I can add a check command testing
setsockopt SO_ZEROCOPY  return value. AFAIK kselftest has no explicit
way to denote "skipped", so this would just return "pass". Sounds a
bit fragile, passing success when a feature is absent.
