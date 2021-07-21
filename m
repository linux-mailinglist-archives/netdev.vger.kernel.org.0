Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8C63D128C
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239996AbhGUO4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239989AbhGUO4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 10:56:12 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BAAC061575
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 08:36:48 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id l7so2660548wrv.7
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 08:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HpRa1ix6hAPuB8DnQBcEdSj7KsogY+yLTzijguZVYEE=;
        b=vE/GJOEreeJVhFCyCovuk3FjgCOfbv96LXVD7h00p3L1b/8EiSqzRQaX1QZ4Yryltx
         7qGHUrtcO3thjbt4KHFUvKTzBc2+tDQAdKOtUTHyHKA9zGnuiWXenn/mZeX7J33DXOze
         Yilpy7fqEDUJXEUZY2EDaTiSvL0ris599qQOuXz9CyLPc1KpI4GnONQjr2EtvkLZEdEJ
         YLJraFUfOO2EungFqULlWFh13m+pxD6kgG8/Lbxbsmjd4fsrPulZvbe8WAn1gPfLt7uL
         Bsk70zpnuuLnOKuFVw129pfDZtIWM7hJlpgr8vnwY0biTBgioVr/B7yTo8Y+Mae80Zub
         5zgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HpRa1ix6hAPuB8DnQBcEdSj7KsogY+yLTzijguZVYEE=;
        b=LaoN4wyT0HnWrRawTaq9ldvjntbH0W1vUSD0iWwM7D88/JocwVh0Qvm4VJ6LVK/tSz
         iNkosCqveOuiiNTzgGBwd9MaWyiLDDjM1ymxnxH2InVUyb+o4yI0wMJ6oUVv69MoKXIQ
         uFrCuuN/6kRvdSnxDmUEP5tPISutas1xfI5Kxalt9LmWb64+GXZ9zBYezS6GOoMC/JdN
         LlHlwlzMKuB+h0CHsvYBSLFWntyFzMVRG8D7yBWhZ5J1Yo5GpBsvSXLbw/k+MgyI2k24
         zuVCpkULxB8YGQLP70QbZZ6uka2CjlaWllqe3SA2cYdSCPhXsScJQ5YlrkNFbcOc7lB8
         cYnA==
X-Gm-Message-State: AOAM532YVKO1ubY1jqx7Vke8EiTMYKGST6B4KERrZPGYfqtg5BhT39/Z
        /Bg7Gc0YDra9gHmCiPLWaw2+ZA==
X-Google-Smtp-Source: ABdhPJxdlaRbaRZ+Xw3OSc0sFmb0TLDA9ktxG7vqe0pwwHe0JL80+SWxuK1MDPzWG6H5vsIXHZoTkQ==
X-Received: by 2002:adf:f110:: with SMTP id r16mr43054628wro.358.1626881807641;
        Wed, 21 Jul 2021 08:36:47 -0700 (PDT)
Received: from [192.168.1.8] ([149.86.71.195])
        by smtp.gmail.com with ESMTPSA id q19sm225785wmq.38.2021.07.21.08.36.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 08:36:47 -0700 (PDT)
Subject: Re: [PATCH bpf-next 1/6] libbpf: rename btf__load() as
 btf__load_into_kernel()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20210714141532.28526-1-quentin@isovalent.com>
 <20210714141532.28526-2-quentin@isovalent.com>
 <CAEf4Bza=5GjYyDCZNMbUFyQskXunT8S3R1jCfvZmy3f1joRVFQ@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <69d16c23-12bd-31a9-d025-230efec8eb6d@isovalent.com>
Date:   Wed, 21 Jul 2021 16:36:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAEf4Bza=5GjYyDCZNMbUFyQskXunT8S3R1jCfvZmy3f1joRVFQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-07-15 21:32 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>

> we haven't released v0.5 yet, so this will go into 0.5, probably

Oh my, I still haven't done the mental switch since the old release
model. v2 is coming, with this and your other points hopefully
addressed. Thanks a lot for the review!

Quentin
