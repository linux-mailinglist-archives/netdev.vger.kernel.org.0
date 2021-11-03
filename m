Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEFB443B7A
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 03:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhKCCpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 22:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhKCCpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 22:45:34 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70831C061205;
        Tue,  2 Nov 2021 19:42:58 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t11so1453277plq.11;
        Tue, 02 Nov 2021 19:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=45coi7Ih4CCb0SGaI6BKbm4uGXPIoQsr5bED3veX7DE=;
        b=Ry6uy/domHLypn6avbjpw9PjUebXIUXSRX9ZgtAcsfcLeL8ZLcIwfJD+twl0/bDCI3
         ZywdOsoCUM5TwV3oc00Vqvpi8I2HMDclEBR0aVyr/KqMIteamjivFwyu+7SPPsj8cpTE
         LoCTDAegvgNkczk2p4zhdDtXuNM9Gli1a96M6/YCy5bSoW8yzuslw3hppeRv3hHx9q+A
         d2jPKiP9s+H4tL+p19nOO115LZoBHtP2KIxRN/PkVzNFvioLuRehhLYDTBzToth3ihAH
         k9VrJMXki7udNoEJjofSKxj5odVRNKb2kg62LVchqCZtHITsqz4OkSIzoSLuLNKcVjJL
         OFtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=45coi7Ih4CCb0SGaI6BKbm4uGXPIoQsr5bED3veX7DE=;
        b=L1SgmfznOUc/+jw4IfifmeTvSxUg0ID5GmT7f7MchiL2u1y/12CTddRywQKZWOv0PP
         DNppKRtD0PY+5cnv2LPxw5WtBDOMenzXdugWr8959GsKEOzpE0qcUsiKIVGB29Uhe7c3
         xrRipULb9tRmyIZIP+eAjtDT2ukStpJa2lSZbcuv8aQtU53FRVTAkQHgoic5tS/Uksze
         lZfb+vNvwiST3mlT48iqQmIaGChhfKvM61cHIvslff2Q7L5hKV5xcLH2Zq5/CJCtsZKp
         Ug4ZaMnr1GK6mBa190LTvJ3WHuY/rU9YIFfI6yrB3W5zSVx8/ABuDO18FeIaqQTfTUNu
         06kg==
X-Gm-Message-State: AOAM531W6BPhfgsBLz6HdvwKNRpP0xIdRRNUghynqwKrymA2cIpV1qPU
        az/3xF+b3nlCuVtuC/h9lslWQyZlwIg=
X-Google-Smtp-Source: ABdhPJxC2WtxuL1nKnY+zvOVECgekSKubOOgGoHPN5cWWJxr32+dTU4lb8Yqrqgm0XDt+ZZNqdYONg==
X-Received: by 2002:a17:903:234b:b0:141:bdfa:e9be with SMTP id c11-20020a170903234b00b00141bdfae9bemr25952939plh.36.1635907377965;
        Tue, 02 Nov 2021 19:42:57 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s22sm464148pfe.76.2021.11.02.19.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 19:42:57 -0700 (PDT)
Date:   Wed, 3 Nov 2021 10:42:51 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Coco Li <lixiaoyan@google.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCHv2 net 5/5] kselftests/net: add missed
 toeplitz.sh/toeplitz_client.sh to Makefile
Message-ID: <YYH3K1zJmissyL7F@Laptop-X1>
References: <20211102013636.177411-1-liuhangbin@gmail.com>
 <20211102013636.177411-6-liuhangbin@gmail.com>
 <CA+FuTSeS2s7czeAASfz9qep06gdUKVHD8bhiqtEOS1w82-JR7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSeS2s7czeAASfz9qep06gdUKVHD8bhiqtEOS1w82-JR7Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 11:09:43AM -0400, Willem de Bruijn wrote:
> On Mon, Nov 1, 2021 at 9:37 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
> >
> > When generating the selftests to another folder, the toeplitz.sh
> > and toeplitz_client.sh are missing as they are not in Makefile, e.g.
> >
> >   make -C tools/testing/selftests/ install \
> >       TARGETS="net" INSTALL_PATH=/tmp/kselftests
> >
> > Making them under TEST_PROGS_EXTENDED as they test NIC hardware features
> > and are not intended to be run from kselftests.
> >
> > Fixes: 5ebfb4cc3048 ("selftests/net: toeplitz test")
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> Reviewed-by: Willem de Bruijn <willemb@google.com>

Thanks for the review.
> 
> The same might apply to the icmp and vrf tests? I am not familiar with those.

icmp and vrf are running for selftests. They should be added to TEST_PROGS.

Thanks
Hangbin
