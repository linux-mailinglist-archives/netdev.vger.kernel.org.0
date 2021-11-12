Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB3844EBC0
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 18:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbhKLRFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 12:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235434AbhKLRFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 12:05:34 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F21C061767
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 09:02:43 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id c71-20020a1c9a4a000000b0032cdcc8cbafso7249513wme.3
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 09:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VZGehk3+HjfLCRM6NGvoDoHhkCICOZhcoeDuxektNp4=;
        b=i4r1TRjg5InRAmEoxfv3subbanekSTukrotGUQs6tEPZnyWwKL3C9wb+crae+VQFZ/
         qZGR7XhjAeL4yhn9wM5iV4RxEaJNVgeqUYKbWYC54ecmwf3kxLtH33pXIbEK/ETTO0od
         hr6I7svFxj2YBnHIgp4UDY8gI8oq0p1fI01q8XQGcgG3yj13qahLD8HecKfhSkbZSc6v
         TUvt2oDXen92VsDd1TO4a2lM9tzODodBxYl56Yowa9Y+8RQc65Z3fdfJ1Y/6htAaVGmA
         WqbHvDrENhi4upX0BQxdB83MxCtmu7FWfmkJcPmay1Nn7WSep4jl4+40keBvzi87iiE1
         Y1qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VZGehk3+HjfLCRM6NGvoDoHhkCICOZhcoeDuxektNp4=;
        b=DQzlgYcvHolkqi4CB5bSbgYKEPBdNr5NnQdko6wBrKbMsqHlJ4yzeBdKOe2iBJo8Ky
         +a/8SJ1aIwLK3u7BCArYMD15hyKXESLScXdd/eK2sypbF02cox2t6oP+yEm34POuPHFd
         D8m6cNs4g6/WsuR+lzSir1y25uazxH3j7TkJpioP228itJeaehzEiPaGJLVL3983Ujxx
         q7FyPtdSw65dIT/H3xPRjPKKp6OMtrm5NLRw8B2Lby1ja9ifCIRw1bwnO3Ibnkn+ih5s
         /ijivky+8gu4jNZjnLMDWqoDAwfcAYFaVvKyeBcDJWpgmca6duKvbsrulqkXc97QIuCE
         mKEg==
X-Gm-Message-State: AOAM532dem5I7JFxyYRhfKTMxi7hQd4ceVW9sQDkRRqN6+VY+r0AnYCO
        zoBc2zns9VpEgqMj7HaKv33QsA==
X-Google-Smtp-Source: ABdhPJw/3xnMi8Ie76412HjjQrPyQn2wdn5YkAl58VsGkXALq8TmEKdsCVBKKYWdXfsa4pYbudbycA==
X-Received: by 2002:a1c:f31a:: with SMTP id q26mr18195693wmq.148.1636736561937;
        Fri, 12 Nov 2021 09:02:41 -0800 (PST)
Received: from [192.168.1.8] ([149.86.71.160])
        by smtp.gmail.com with ESMTPSA id j8sm5973254wrh.16.2021.11.12.09.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Nov 2021 09:02:41 -0800 (PST)
Message-ID: <2a34cc7d-1d84-99af-715e-5865dfdcc72b@isovalent.com>
Date:   Fri, 12 Nov 2021 17:02:40 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH bpf-next] bpftool: add current libbpf_strict mode to
 version output
Content-Language: en-GB
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
References: <20211112164432.3138956-1-sdf@google.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20211112164432.3138956-1-sdf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-11-12 08:44 UTC-0800 ~ Stanislav Fomichev <sdf@google.com>
> + bpftool --legacy version
> bpftool v5.15.0
> features: libbfd, skeletons
> + bpftool version
> bpftool v5.15.0
> features: libbfd, libbpf_strict, skeletons
> + bpftool --json --legacy version
> {"version":"5.15.0","features":{"libbfd":true,"libbpf_strict":false,"skeletons":true}}
> + bpftool --json version
> {"version":"5.15.0","features":{"libbfd":true,"libbpf_strict":true,"skeletons":true}}

Nice, thanks!
The following doesn't work as expected, though:

    $ ./bpftool --version --legacy
    ./bpftool v5.15.0
    features: libbfd, libbpf_strict, skeletons

This is because we run do_version() immediately when parsing --version,
and we don't parse --legacy in that case. Could we postpone do_version()
until after we have parsed all options, so that the output from the
above is consistent with e.g. "bpftool --legacy --version"?

Thanks,
Quentin
