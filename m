Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E44B37170E
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 16:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhECOt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 10:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhECOtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 10:49:55 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378AFC06174A
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 07:49:02 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id d21so3536326oic.11
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 07:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lKpuIpEw/RycTQ8Ocq7F02Px0k5oqlFXMXYs1gVgBW0=;
        b=ECAv+gqW9A4vejSCj3Ll2BDOmG7EnLKSeSnFwk/uZDINiDqB0iKGxCy12pRQRTEouQ
         hnRF9esLrZNSYiP5qSK7qI0FRNM/RVolAdOk1AkY4FtLov5bt58VmKRJEBGJN7nJBnsR
         61jaUCPIausoNErrGqpgTsp2WMyCVFINFnC6mAJZdmj7+DTTXlQ9I8/Q8rjTciysIYEF
         5T/WRAvsc+kPVIukdOivpzLxYP4LwNCuQE9KGxFPopCnjKt5cJi6yGJnFtjMcpTzYhIj
         EMRXV0/921Es68ZEOPT+NyHlUqkDIdLC+WyRgFOQ+/pkOYVoRQFSEaylIe4TiHRRwt/v
         nuTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lKpuIpEw/RycTQ8Ocq7F02Px0k5oqlFXMXYs1gVgBW0=;
        b=iFx6sPRNWlp/K2R4v9aYJOl7rAQRkFASrTn/43KtgQeTBWzIgb8gmXHkVO72ZLHclA
         L9aX4GuvsnTXUd2XNvSF2+QDJ/fUaJOgTQveBigpNRIrygAdeyHC3zpseyVYjUrqLEBX
         iLHt7peKhgQhQJK13kRd/w5M5OrddkRBjzOd5Yy0KmBY0xwSAnh/XdWsMRx3SymJBNhZ
         C4N17+WdyUFSgWLkFVsiaXghlxf4FlZYlSD+0j44cVYT1P4sfVUl+8ZUqZaMZ/a58Nmr
         9AH4hacNJq4u3R9yFN4jNBSQAslSKXqVMrfFPUhRukFgui8rolAZnVnyFJXPd5b1hgsg
         MUyQ==
X-Gm-Message-State: AOAM531rKc/yt1XlZGH4xVagDsDFIBMZybg/jM0ghkCbKyzi2NKkE45N
        ajZAFKzIdd02MB/D0lUAjAGxL7ll0NdEWA==
X-Google-Smtp-Source: ABdhPJwh9whmhOt1aT9LxOHxvjthINkj+s85qqo7spgJ7nYRHH2OF05k27t3+NR1OYKn2PCHeLW3NA==
X-Received: by 2002:aca:bb06:: with SMTP id l6mr13733881oif.121.1620053341713;
        Mon, 03 May 2021 07:49:01 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id r124sm607243oig.38.2021.05.03.07.49.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 07:49:01 -0700 (PDT)
Subject: Re: [PATCH iproute2 0/2] dcb: some misc fixes
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org,
        Petr Machata <me@pmachata.org>
Cc:     stephen@networkplumber.org
References: <cover.1619886883.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <40f5d824-d297-e040-2978-9b73fac13bc2@gmail.com>
Date:   Mon, 3 May 2021 08:49:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1619886883.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/21 10:39 AM, Andrea Claudi wrote:
> This series fixes two issues on dcb code:
> - patch 1 fixes an incorrect return value in dcb_cmd_app_show() if an
>   incorrect argument is provided;
> - patch 2 is a trivial fix for a memory leak when "dcb help" is
>   executed.
> 
> Andrea Claudi (2):
>   dcb: fix return value on dcb_cmd_app_show
>   dcb: fix memory leak
> 
>  dcb/dcb.c     | 3 ++-
>  dcb/dcb_app.c | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 

Always cc author of Fixes commit
