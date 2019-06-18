Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAFD4A869
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbfFRR1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:27:53 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34201 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729455AbfFRR1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 13:27:52 -0400
Received: by mail-ed1-f67.google.com with SMTP id s49so22915966edb.1;
        Tue, 18 Jun 2019 10:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bs24QD6yJ48wIr2D5TDhpx73Ym4NDSPa09Z8FwUIQvE=;
        b=NPuEEaeRQXUM2LwJ6yO6Q6m9UffoQUEjfXVZT6RecHHaB4Bu4W2ixljoGBA2PK3pJT
         83AN5mDJvX2A7Uy3UfxmeA1XaLuBXSTJxvzwWDjQdQZDmw45UE++XbDqk5brNWDRsf2r
         DPwhdNwiDjvfm4vhjSk4gcQQo//h7dRkVH0S6LixKlGprCQS1NRcV5v8s3KegJHB3ZPg
         gX3NGNlxq7OcOvQW8RGq7qnHIrjDpu2BPEAodbNWDnSVXaeepFwd+UStt3js+B9Z6Aqh
         xkjvaOd+T6XrWbUn6aTp0f8VnONTITm1UEmMmX/eNHbCrFPg0PaRmDPm+g75Qxuj7Y3D
         G70w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bs24QD6yJ48wIr2D5TDhpx73Ym4NDSPa09Z8FwUIQvE=;
        b=NKDb5Z8MK+0eIUxBlPb8Y8uFhlYumZ6BPcKCGzXnCw8eeUEkIPFBKu7WkWBf2NuXzh
         PGgZn6xrZORwGo1l/ktMDRsAQLIv4Fo6P6FvnjHm64DXWR9BJOTxB02WlEunZgHnjqIT
         P+feLeJuyw10kRHAxdDLd/V5CJXb/mRp1YMtKuKpE8WcbbFjqECGSztUkpHBaZmErT4z
         PRVqdJP+WU7oUuwXftRSkSa62+sAvQf5auqp/US8v18ayIt0RlJk+3guxEEh5EdN7gsN
         GEwjYRO1nGeZUWUsQzW3KnAyU5cwlMoTIMyL9YeR+CClBif43EhJ8yI58ztRh8mkymx8
         UsLw==
X-Gm-Message-State: APjAAAWtP0Bc+S62eQNBpqk82P2ECfUpj/5ijjY/tUVsSOVWyN0bsHFL
        BsV5fBYubcf4UtnRGvVTzJhiPWP0oHImq/I1h2Y=
X-Google-Smtp-Source: APXvYqy+vHPlxGTx8RjvjaFMbvXUSFFZSS8pgii3Bqo2LWopkCRdmxrsa32MOi905yoaHU9HmsN91HWR3FyE0VgaWxY=
X-Received: by 2002:a17:906:cd1f:: with SMTP id oz31mr15684183ejb.226.1560878870625;
 Tue, 18 Jun 2019 10:27:50 -0700 (PDT)
MIME-Version: 1.0
References: <CA+FuTSfBFqRViKfG5crEv8xLMgAkp3cZ+yeuELK5TVv61xT=Yw@mail.gmail.com>
 <20190618161036.GA28190@kroah.com> <CAF=yD-JnTHdDE8K-EaJM2fH9awvjAmOJkoZbtU+Wi58pPnyAxw@mail.gmail.com>
 <20190618.094759.539007481404905339.davem@davemloft.net> <20190618171516.GA17547@kroah.com>
In-Reply-To: <20190618171516.GA17547@kroah.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 18 Jun 2019 13:27:14 -0400
Message-ID: <CAF=yD-+pNrAo1wByHY6f5AZCq8xT0FDMKM-WzPkfZ36Jxj4mNg@mail.gmail.com>
Subject: Re: 4.19: udpgso_bench_tx: setsockopt zerocopy: Unknown error 524
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Fred Klassen <fklassen@appneta.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 1:15 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jun 18, 2019 at 09:47:59AM -0700, David Miller wrote:
> > From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > Date: Tue, 18 Jun 2019 12:37:33 -0400
> >
> > > Specific to the above test, I can add a check command testing
> > > setsockopt SO_ZEROCOPY  return value. AFAIK kselftest has no explicit
> > > way to denote "skipped", so this would just return "pass". Sounds a
> > > bit fragile, passing success when a feature is absent.
> >
> > Especially since the feature might be absent because the 'config'
> > template forgot to include a necessary Kconfig option.
>
> That is what the "skip" response is for, don't return "pass" if the
> feature just isn't present.  That lets people run tests on systems
> without the config option enabled as you say, or on systems without the
> needed userspace tools present.

I was not aware that kselftest had this feature.

But it appears that exit code KSFT_SKIP (4) will achieve this. Okay,
I'll send a patch and will keep that in mind for future tests.
