Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19329562886
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 03:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbiGABnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 21:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiGABnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 21:43:53 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766505C953
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 18:43:52 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id jb13so959983plb.9
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 18:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1CTyUsVOqG1d6RnELaDPFW66raanROmL96jSzPSyPbk=;
        b=aDep5pTyQ5S/99G5NSwntMf15yd75Jt09kDgQU7v0XyEZ5LYs7YX7XXS2asqGXADaF
         R7YHKHqd1BjpGCOIQ3vYzXb8S/0m05yCfzDXlLL70XqSkLKKlRaFg6cIKLvskkrNJapW
         NDKquMl6shnUt5Z0eAeYmDwNJbCVhQblbdRGL9MyXEBAF87U9ZYP3NY0vafyt+C/HKaL
         +ttlveFCpXsuuAMiQ7UBCINiHkizZCY8ckaBYhGq/fx6rwJs7FnfI5TiOLScqhQil3om
         D2eo6a4FQWPSSDmC24VX3VsCvgKyJFfN5gXad4qKT3V18kKWJz5drerqQi+IJmwStfn2
         JB5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1CTyUsVOqG1d6RnELaDPFW66raanROmL96jSzPSyPbk=;
        b=hbFtoF9cxdR7nJbNyVBeU4id9k8MsxqIIvEWBBrSWiOyrBBHodObu/2TdWgTThoYDi
         FftPiXO9EJurUCfhD5i8xqLa6CwHYmV85qbUG9cVNQez1rTBOV7LaXyCG9V+wkETh/el
         b7T+S77iQ/ztBsClIcHUdge4moRZ8Yn3Wuyb0UHwRpWo/0HvM3fzUxPGeYNkOvP/oK8G
         X2qx6xP/r2vOYyf6Uw274X9qPykss2NPfw5ZrwEpkDHQWDMv1EQFnLKxS+inYbup9RVd
         UObBMsG+Q19fVjGccAUgLCKHEp4RaxIarcy5D87O1E5mYLQXOurRS2WywsjtUJyU/i1R
         3Img==
X-Gm-Message-State: AJIora9M3cTHhVwBrqZGyc1CeqbEgNGNn1yD/jz+L7WAbHiEVteW/e7y
        W/6k0KyM4kPc3UktKou8dQpyOJxchx8=
X-Google-Smtp-Source: AGRyM1tBUZyOGbjFPq2DJZRWd6KMQrXV8z21IbJMeToYhrZPifBBBiHk2IQKEhVAFRrfwfjEnhL47Q==
X-Received: by 2002:a17:903:230d:b0:16a:73ce:9068 with SMTP id d13-20020a170903230d00b0016a73ce9068mr18554186plh.57.1656639831949;
        Thu, 30 Jun 2022 18:43:51 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bc12-20020a170902930c00b0015e8d4eb1d5sm14142687plb.31.2022.06.30.18.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 18:43:51 -0700 (PDT)
Date:   Fri, 1 Jul 2022 09:43:45 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH net] selftests/net: fix section name when using
 xdp_dummy.o
Message-ID: <Yr5RUQYQCB6sgoIo@Laptop-X1>
References: <20220630062228.3453016-1-liuhangbin@gmail.com>
 <CAEf4BzZ-gn9VmMKx8m2kEvTc--DC8Z_hvKXaw_7Q2BY-J7JQQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ-gn9VmMKx8m2kEvTc--DC8Z_hvKXaw_7Q2BY-J7JQQw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 12:08:11PM -0700, Andrii Nakryiko wrote:
> On Wed, Jun 29, 2022 at 11:22 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
> >
> > Since commit 8fffa0e3451a ("selftests/bpf: Normalize XDP section names in
> > selftests") the xdp_dummy.o's section name has changed to xdp. But some
> > tests are still using "section xdp_dummy", which make the tests failed.
> > Fix them by updating to the new section name.
> >
> > Fixes: 8fffa0e3451a ("selftests/bpf: Normalize XDP section names in selftests")
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> 
> Thanks for fixing this! BTW, does iproute2 support selecting programs
> by its name (not section name)? Only the program name is unique, there
> could be multiple programs with the same SEC("xdp").

Good point. iproute2 do not support selecting programs by its name yet.
I will working on it to add this support.

Thanks
Hangbin
