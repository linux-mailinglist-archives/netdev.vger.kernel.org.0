Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEE5492EF5
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 21:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349074AbiARUE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 15:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiARUEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 15:04:53 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD7BC061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 12:04:53 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id i82so16956ioa.8
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 12:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xx2R0Dbg7JeLP4/YWwWwOYGP+ShHeHdahKMR+H5uxQQ=;
        b=UWpWwkhPWhPHuaXXkleM1FH0F0QeEdo8ZQIniFtmGhvDVuZH2uV93Re8r10/YKezbN
         W6+wVZ1exCadJugyTk0XRt6OjwI4Iz1D+yaPFs+pNcsid0b6KReZ8WVsB09aOB9irPSA
         xq1WT0OXb+WOZcVHG5B3FI40WsTCxHi9+dIWhm1nW+p6V/BmU2X2m8C+WW0eyV6mFCKS
         hMtdi6YsHrtkifjTvnAm4rV0i5yrYyFOCppqj6af6meNHdYnUzK8fRO0wRra8RbLDBtd
         qxyUtP5F3od27gza9OS4dzqCxfgrK4+oea+GHjxG41sYGIuYBvYUV3D4pvoUhSNe8McT
         98ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xx2R0Dbg7JeLP4/YWwWwOYGP+ShHeHdahKMR+H5uxQQ=;
        b=xkJQQF2oJNEcHbuIURzqi+dwWYqFvO/HhmPSUM6h+RYFealKsGwPn/auNsfQWHtP7/
         O7+ZAxcMczjMxwlwue9qRGBpdbMom6YOO5fsUt8Lz/h8K/FxtAvXCGd6b8ZRCelGl1GB
         Y9ES9xK9q+iKofo2Xx5o+DTDQxk4Wng5ZV46q+KYPY714GMZVdztdtzbnHisPoQpsOTt
         txKTt7Y0ZZuCIGzh4ekMp8HGshpng0L4gGK6wXz6UWIFO8vffhQqn5UJ6IUf62lnIeGW
         qlcpgTUz6dPRFJ0pGBEjcPdfmSoiA5ZhFxKm4ObbTNoNTciMraTogPCzafY00BarzCTd
         JNqQ==
X-Gm-Message-State: AOAM533O/LmUOTpX3/topRKCj9m3jJht1ggSwFiTXLtBoEJ/0N92B0bH
        5v830dW3aWLvYwMsIjP5JKw=
X-Google-Smtp-Source: ABdhPJyrmUqxiI/Z3Egs3/dnGzML5cdX8Uwcmr6k7g0FoXe9IVBrBZPynIaoZVnHymprBf2QqimCbA==
X-Received: by 2002:a02:606a:: with SMTP id d42mr13233434jaf.5.1642536292944;
        Tue, 18 Jan 2022 12:04:52 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.58])
        by smtp.googlemail.com with ESMTPSA id c19sm11357263ili.19.2022.01.18.12.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 12:04:51 -0800 (PST)
Message-ID: <49be1ddc-2c7d-1b7f-795a-30612433e83a@gmail.com>
Date:   Tue, 18 Jan 2022 13:04:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH iproute2 v4 1/2] tc: u32: add support for json output
Content-Language: en-US
To:     Wen Liang <liangwen12year@gmail.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, aclaudi@redhat.com
References: <cover.1642472827.git.wenliang@redhat.com>
 <5d67bd669fe97a9a797263e18718cec3dab88cc4.1642472827.git.wenliang@redhat.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <5d67bd669fe97a9a797263e18718cec3dab88cc4.1642472827.git.wenliang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/17/22 7:42 PM, Wen Liang wrote:
> diff --git a/tc/f_u32.c b/tc/f_u32.c
> index a5747f67..03dbe774 100644
> --- a/tc/f_u32.c
> +++ b/tc/f_u32.c
> @@ -1213,11 +1213,11 @@ static int u32_print_opt(struct filter_util *qu, FILE *f, struct rtattr *opt,
>  
>  	if (handle) {
>  		SPRINT_BUF(b1);
> -		fprintf(f, "fh %s ", sprint_u32_handle(handle, b1));
> +		print_string(PRINT_ANY, "fh", "fh %s ", sprint_u32_handle(handle, b1));

sprint_u32_handle adds a space after the raw check. I think that space
can be removed.

Also, seems like raw and json should be incompatible.


