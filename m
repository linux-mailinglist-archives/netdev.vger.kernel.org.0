Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22F7397756
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 17:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhFAQA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 12:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbhFAQAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 12:00:55 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F34C061574
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 08:59:13 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id e11so19910159ljn.13
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 08:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=dwr+m3luJ+zspNwSEhyluz1XC5SAhK/g+8Tfr+DgcGA=;
        b=XCbmlHnb3IiKOljXrNodCi8UKYD8wubRdvDperKdZBIGpT2ZmGcXxrrUECKGaxTYHw
         f/1jAURbwTAuKPJWkki/6Eu6tuo2QdbpKADHBALoDVm0NWH8EmhJM7GbbDYEGMt3vJ3y
         qlDT4JSbTuDU9qVpqaifM+b+s75cHEsNgg0dhOBtulY7ghwwWrymh4bxbCd7UTtz5roK
         TWFbzcXKP+zRx2+N643WzERqFlLI1HUE2zxdmLEyauMiLAAf28fEvvDRNJeH1+RieKjP
         4qraKqgfpDiQUijLpZ851tV9GXPig2HZefpy7dZxvkWbCYc9Qaa8mgNRfpllc7UipOKN
         93GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=dwr+m3luJ+zspNwSEhyluz1XC5SAhK/g+8Tfr+DgcGA=;
        b=Cy8V6GMGR2YRHuGQ9zc84GyESK5/WgoFszFq2Zj3LWopHgCccmARovTMPjoca4xuYJ
         FQjLC5ihrPA2TIXAaTx10Yf7qL8b/px2lsu8L/ME0FtE3A9NkdzUByoZWoIAL4OmYfI8
         Q9e+C7q5NBAcLZg734zHciEs2qLpGhD1r1YmBlj3AvW9Ddoo5bLCVuefG2j24io1W583
         +G2prFS5x9QzRR6p1HHPV5xMOv0NeeRjbWgg4vFurLlQKuy6bksz2YMQwykUjfwsyfw/
         F6FX8rV5+/aBOJoa+mAH1TJBIN+FrlAwUzCx6H9xjSK3iOexrre/aievthp7GM+ZO/9j
         wZMg==
X-Gm-Message-State: AOAM532IaSvjFybk9NR188tny8ADOHoco6jWKwDUaHSPV9eLvokK1+FC
        zKprpOvov6WFJoQr/ZNqDGQ=
X-Google-Smtp-Source: ABdhPJxHQzg22u826p38eWJdOrxLhiqjJ6ACgt2l+UhTcugH2b2ST5wd6QxGY/HZzr5+xi6GF5+GOQ==
X-Received: by 2002:a2e:9b97:: with SMTP id z23mr21694132lji.359.1622563152354;
        Tue, 01 Jun 2021 08:59:12 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id n20sm1077724ljc.34.2021.06.01.08.59.11
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Tue, 01 Jun 2021 08:59:11 -0700 (PDT)
Message-ID: <60B65BBB.2040507@gmail.com>
Date:   Tue, 01 Jun 2021 19:09:31 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     Arnd Bergmann <arnd@kernel.org>, netdev <netdev@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com> <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com> <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
In-Reply-To: <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

01.06.2021 14:42, Heiner Kallweit:
[...]
> Great, so you have a solution for your problem, as i would expect that this
> setting also makes 8139too in newer kernels usable for you.

Well, not exactly, although I'm definitely getting close to some sort of 
satisfactory solution, and I appreciate all the helpfull replies.

Relying on this BIOS setting is still not good, because yet another 
motherboard I've just tested today does not have it (or at least in no 
evident form anyway).

> This hardware is so old that it's not very likely someone spends effort on this.

Now I'd like to ask, is quality reliable fix still wanted in mainline or 
rather not? Because I'll personally do my best to create/find a good fix 
anyway, but if it is of zero interest for mainline, I'll probably not 
invest much time into communicating it. My understanding was that 
default rule is "if broken go fix it" but due to the age of both code 
and hardware, maybe it is considered frozen or some such (I'm just not 
aware really).


Thank you,

Regards,
Nikolai
