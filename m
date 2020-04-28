Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBE51BB8BA
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 10:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgD1IW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 04:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726562AbgD1IW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 04:22:26 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD4DC03C1A9
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 01:22:26 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g13so23546920wrb.8
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 01:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=112gxQAElWOFxILa6n1/AzuzINg5xMRFYi5S8oYYf70=;
        b=rx++ukxK/E51Z8RzpvkMDmGKunYpebTm81HovATnfKmtrVAdDKk5V4lDrJXsDDZI2N
         2pj+9yxIrr/XjiRVRUrYPXlXueX8pYmytzEPFVG8ykgMqRmozasfWsreaDlpFX3GocFO
         BrEPofUZVXlUZyrsEzylSDGts8o8GLmamlyZouwTG2ZWMK8jbgryzCP86Nu0u8jqid/p
         s4f3JCaqwe0mcGwhPWa+0UmgJt7iGt63NQaQvqCTYr1tQG+GPIaUzSlr4xLqNUtIH58/
         zFt4enThDPTWtcGonnA9RRmrhrIyfWMyqgUzIEtkj6Irde91GpP++Tk5+0xflik9NIHy
         g/DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=112gxQAElWOFxILa6n1/AzuzINg5xMRFYi5S8oYYf70=;
        b=Qc1+LVQAUHNhI+9YmcGGUcwyP+BAxnTShtCZXjM1XLLTEq0vrPAZneigXJD3Nhxeql
         ls1p24TZmqbQ+6AKO23Z4XzlbzPKdQdu6FAX4Gr1ZraeDwu1raINO4lUGy9xIYmmkLKb
         SsNgs6BIJjYChLGLZ1Cn41Sck4djCk7WgMqfhL8wWXgjrnV9shfq4xWhH7iqetE/VELe
         Xy/p8ypw9Wtvy+vHEIN1pq7f/NjLMheYc6I1O8fly6x5BuY7X8obsuqBSFsmPeOd0MSf
         9M3ZWjUzi/uiiDi6biB9ijDS7bAvxTyA0dAHbIFv1kryiZ9DKFBoTQqVseyoxAwfmdh2
         sBsw==
X-Gm-Message-State: AGi0PuZJD2FuuwffaqvAYIC4OPZuQi7WQyporOTXc+jtCBs9slyPuKfm
        sUoZdrhlt63ecbDwy5NJ/44SSQ==
X-Google-Smtp-Source: APiQypKOeWtgCMVmaknUCLgU1BuWibYdmCF0ziiNgFN3rt0k8PhVddH8KjqsetzpA6IpCX7wR9titw==
X-Received: by 2002:a5d:640a:: with SMTP id z10mr33540147wru.280.1588062145241;
        Tue, 28 Apr 2020 01:22:25 -0700 (PDT)
Received: from [192.168.1.10] ([194.53.185.137])
        by smtp.gmail.com with ESMTPSA id z2sm23789902wrm.77.2020.04.28.01.22.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2020 01:22:24 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next 07/10] bpftool: expose attach_type-to-string
 array to non-cgroup code
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200428054944.4015462-1-andriin@fb.com>
 <20200428054944.4015462-8-andriin@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <25456924-1953-5d80-f057-2678dd529bd1@isovalent.com>
Date:   Tue, 28 Apr 2020 09:22:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200428054944.4015462-8-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-04-27 22:49 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> Move attach_type_strings into main.h for access in non-cgroup code.
> bpf_attach_type is used for non-cgroup attach types quite widely now. So also
> complete missing string translations for non-cgroup attach types.
> 
> Cc: Quentin Monnet <quentin@isovalent.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Thank you Andrii

