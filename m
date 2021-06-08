Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D63D3A051E
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 22:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbhFHUZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 16:25:00 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:43935 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234490AbhFHUY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 16:24:59 -0400
Received: by mail-lj1-f178.google.com with SMTP id r14so9559345ljd.10
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 13:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=iAF1p1O5HHomKy0WFFA5vwlYul2To4IV6MZ+RRXBRgw=;
        b=VfWAMbwn4xgT/F1jw0meETQKaje0LvQ2Ag/Nb2V3wo+hCyaAfkwiffCRK2LE81fqBe
         ImTJmZhiwkMV1PhFuSeNN4XzJln5zGzlLyhUtiMDBbtaDTbSWI5TtfgnEbV/6DITfWmt
         yWMizq62L+rH//2yO8utrtPkTNf5pkSqiOxV5saMN8ptWH7+TNLXu1Kl6INvDhC9odfV
         c2R+0M7kSrKe02Z0s4nPpjbnr92/4hx9WcBQXlXdyO8dx0pKSlNnW54KGCmDR4pKLd7Y
         bx6qnd7GZoX5ojMDPZOu2Y8Azk0TG2XvCCw3ubE7BAxTK/GCG7hRkuQcsWWGQLLqMH5R
         7mSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=iAF1p1O5HHomKy0WFFA5vwlYul2To4IV6MZ+RRXBRgw=;
        b=svlLxVYunEmbawU5fvCY9sLtdyUMKRO84seUlW+lbXT0YAR9z8fVXD8KKJf3BhXp+J
         o7u1YG3lVhDEF9t5e2vzL5ev/DioOhZ4XQ+bo9Kfc3/InE53Jns0R8L8047dfLnGevwx
         QUXN7L8GVqar2zFkNduMw72yAfGuNCtDEPPkZAi5+wo/Jxqn7kcdcW0+GdbbO1408+Go
         k6c9AokhfAomrDAmsdWkkF6DwwpPC0yjoIIzbhF9+JLwv3Vv1Lp21OsDeTFNlNYS0Bj5
         uD2BvKp0jv4LWfK4xIx62QqXErnQuBRDbx+QcIJD9kJwNrF2mlA795y2G+dMkllClnXc
         RTUQ==
X-Gm-Message-State: AOAM531CBEhCTxx0mAmG8kJjPE/D94ubOywmVTo7ZGUvDrymuqIjtj7y
        e3Xnjm7oIG8xRtnRBWQopuaakOrdSDBdwg==
X-Google-Smtp-Source: ABdhPJzQhAhRelCVAs03T5rvfqpVJKz2HI6QJZ6bLfvpZ/N6zKk89OHHXBNDqTbxVWCajFif40Y2+Q==
X-Received: by 2002:a2e:581e:: with SMTP id m30mr372142ljb.170.1623183713384;
        Tue, 08 Jun 2021 13:21:53 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id b21sm100319ljp.0.2021.06.08.13.21.52
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Tue, 08 Jun 2021 13:21:52 -0700 (PDT)
Message-ID: <60BFD3D9.4000107@gmail.com>
Date:   Tue, 08 Jun 2021 23:32:25 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Arnd Bergmann <arnd@kernel.org>
CC:     netdev <netdev@vger.kernel.org>
Subject: Re: Realtek 8139 problem on 486.
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com> <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com> <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com> <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com> <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com> <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com> <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com> <60B6C4B2.1080704@gmail.com> <CAK8P3a0iwVpU_inEVH9mwkMkBxrxbGsXAfeR9_bOYBaNP4Wx5g@mail.gmail.com> <60BEA6CF.9080500@gmail.com> <CAK8P3a12-c136eHmjiN+BJfZYfRjXz6hk25uo_DMf+tvbTDzGw@mail.gmail.com>
In-Reply-To: <CAK8P3a12-c136eHmjiN+BJfZYfRjXz6hk25uo_DMf+tvbTDzGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

08.06.2021 10:44, Arnd Bergmann:
[...]
> However, it should not lead to any missed interrupts with my patch:
> at any point in time, you have either all hardware interrupts enabled,
> or you are in napi polling mode and are guaranteed to call the poll

For this to work, napi_complete should likely be called with some 
different condition instead?
E.g.:

-        if (work_done < budget) {
+        if ((work_done < budget) && !status) {

Otherwise polling would possibly be shut down before all non-rx events 
are cleared?
For some reason such 'corrected' version does not work here though 
(Communication fails completely). Probably I'm still missing something.


Thank you,

Regards,
Nikolai

> function within a relatively short timespan. If you have no pending
> rx events, processing should be pretty much instantaneous, it just
> gets pushed from the irq handler to immediately following the irq
> handler. If there is a constant stream of incoming data, it gets
> moved into softirqd context, which may be delayed when there is
> another thread running.
>
>          Arnd
>
