Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA5735B650
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 19:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235909AbhDKRST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 13:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbhDKRSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 13:18:17 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512D3C061574;
        Sun, 11 Apr 2021 10:18:00 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id r9so16411527ejj.3;
        Sun, 11 Apr 2021 10:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O8+zwDPffx/8cbMVAw7Kqha5ldA8nkdJKVPH/9f2J8I=;
        b=rvDxIhdqHJyBoRCo2iaoNn/HCltddgtdcnCcKLNl1D2+/iWSUy6/0xdit77Hmfefp+
         dP7RdTfkcTzpxjay081dBj7QPlXlXNLxzQW3CQVSKpG49Q6tmDX+zXM8rEn7OMNcnV6r
         fJD1o9gTbmxYVS61Wn6nvcTNvqJ/tOcawJqdM9rxPv+amOsKrMEioBpHgnUXxPhROv4H
         MdqZaOYF+OurYd9ERSlDeXtlXffLQnSI60O41xmqrIg4E3jJZCwKVVIBU++dvyonv2Tl
         qwAsMStpPyXNAubJPZgwJ1pH2RupIKp1sfenEWS4iqQ5Hd+/pZynl08bqp9zPJ6rpcU9
         ZKyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O8+zwDPffx/8cbMVAw7Kqha5ldA8nkdJKVPH/9f2J8I=;
        b=aR6cmG+gTbzCBC0Q7RyZGwVFOKILteFDkQe6+Ubqw4cUwWN8OHo9Wy1Rf32AR+q6qK
         HjPremhjosX/TPlfbz1gYzU/lpVWzAWGlQ6G+i8tN3HPzxbC9nuZKdf+j2l9RmAHljYs
         2kpyDTl/a2xK2SCQjJTkHz6EjhnHPbGgebkmHpEyiFhCzXQOaAMosDizOpI7ofASJaoo
         ejsuNnQ7OS0YSIsFaguzpUPEkwG7mY+eegTXeLdCAYQql7xZ/qEB6i4ncAuHRnekLKeE
         R4L7dvuff7lJfvWxX3/8/+CStKxE3uP1C8myl0TYLA8phSXis1mSRSj0oGEEggbF4YDP
         ddFw==
X-Gm-Message-State: AOAM532KM6BJNGnKMP64+33MMh4Bp2yw760rMILIp65ZWMxDIU/CZVCk
        RAHd1xREiih20IWGN5CnxiZzY4RUxZYZbLhh4r6od6trgAQ=
X-Google-Smtp-Source: ABdhPJz32ZSbjK4r6qJ/2zw/VEmUWvsmjmmbXvd2zb3bGdaeS38L1mNgskLmzYbhldYpOCwhQo6uQARrSqTRuW8V0Sc=
X-Received: by 2002:a17:906:4cd9:: with SMTP id q25mr24117025ejt.187.1618161477508;
 Sun, 11 Apr 2021 10:17:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210411102344.2834328-1-martin.blumenstingl@googlemail.com> <YHMoRAAVSKvfF6b9@sashalap>
In-Reply-To: <YHMoRAAVSKvfF6b9@sashalap>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 11 Apr 2021 19:17:46 +0200
Message-ID: <CAFBinCDmkJinzxG0XVoLvCnA+a4wDDfKyg-5GiHs0abAMsi1Cg@mail.gmail.com>
Subject: Re: [PATCH stable-5.4 0/2] net: dsa: lantiq_gswip: backports for
 Linux 5.4
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        f.fainelli@gmail.com, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sasha,

On Sun, Apr 11, 2021 at 6:48 PM Sasha Levin <sashal@kernel.org> wrote:
>
> On Sun, Apr 11, 2021 at 12:23:42PM +0200, Martin Blumenstingl wrote:
> >Hello,
> >
> >This backports two patches (which could not be backported automatically
> >because the gswip_phylink_mac_link_up function is different in Linux 5.4
> >compared to 5.7 and newer) for the lantiq_gswip driver:
> >- commit 3e9005be87777afc902b9f5497495898202d335d upstream.
> >- commit 4b5923249b8fa427943b50b8f35265176472be38 upstream.
> >
> >This is the first time that I am doing such a backport so I am not
> >sure how to mention the required modifications. I added them at the
> >bottom of each patch with another Signed-off-by. If this is not correct
> >then please suggest how I can do it rights.
>
> Hey Martin,
>
> Your backport works, but I'd rather take 5b502a7b2992 ("net: dsa:
> propagate resolved link config via mac_link_up()") along with the
> backport instead. This means that we don't diverge from upstream too
> much and will make future backports easier.
>
> I've queued up these 3 commits to 5.4, thanks!
in general I am fine with your suggested approach. however, I think at
least one more backport is required then:
91a208f2185ad4855ff03c342d0b7e4f5fc6f5df ("net: phylink: propagate
resolved link config via mac_link_up()")
Patches should be backported in a specific order also so we don't
break git bisect:
- phylink patch
- dsa patch
- the two lantiq GSWIP patches


Best regards,
Martin
