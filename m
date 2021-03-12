Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D15633869D
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 08:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhCLHc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 02:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbhCLHcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 02:32:41 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD340C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 23:32:40 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id g20so3173528wmk.3
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 23:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2vLlMPsBQyKsFoewMMaHWk8ZTsxgQH5oRVh2R46t72I=;
        b=eRvxO3OGAh8x8s+TynQ7Qqc3QtYDI2+D5HRMO+W6qXwkTWKvw4ZHRjJq3w3HNt79s3
         wK/B+6YiYJCSK/Ymqr49GsKrHXzrZa9HN5cmiaDP0jhbiaL1B4nReFSpiV3xL9qdVDEt
         +f/Zx0V12aKrSKs50Bxr4PS9za2RyfMnPF521YbpTkB49TKwp+MB5JSZVxkZ6WDslpeC
         uwCBLjeZDyPyTiObbs6tFqTaJT5iykEOoP/f9cQUKfkCAvV3iw5yMnjGDc+NObpR6Z4S
         1BOkc+0kho1n01vhzcoXnJo3DUzf7q+TtDRRduA23Sn8VySUh2nBZw1k/kYW9ddJxaEG
         j78Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:subject:to:cc:references
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=2vLlMPsBQyKsFoewMMaHWk8ZTsxgQH5oRVh2R46t72I=;
        b=NTDrHgFVHc4geYpBanEBfJxoXSosWPGRi1+bMsaQ/XczQgvmtl14/Halcxb3DRRw7X
         ZqI7vUlIS/Nq5fp1PEXyDkYuqI5ezk1FiCb2Oo2nMT1Ch2Dx8Ee6C2ouBfnO3S0zscpA
         9MCAkzT/E4qcsIg2gQ4e558x0g8dx/2Wi/BnIvkoQhbfN2gqZfPdVLQIwf1GyFEoqzm3
         4Vn34tHcKRVwcC7Uks5iobiqlsGq4W7xOs88/cjgl8hfF911sfZpr/TIxK7f5BWZkUsV
         iZ5hB03lil2obNUpsCMT7uzTrXMr8wMRJ4uArPdtseJHuBaKJ9IOG2ck68HZUjaQAikH
         OuIw==
X-Gm-Message-State: AOAM530QEuBRODe0mF9Silc39Th7+CQGvHhej5D4zyS4eba7JFtdXufI
        0fIGUSE6+sKKGmiHkw3TvAk=
X-Google-Smtp-Source: ABdhPJzU96plijb1/pNdMD1WsWX8VrvNK0AR4kCLhxXPrq8Xm20pf8hcvX6ZNj/+TL4Vzt3y7TBaCg==
X-Received: by 2002:a1c:3b43:: with SMTP id i64mr11452642wma.43.1615534359651;
        Thu, 11 Mar 2021 23:32:39 -0800 (PST)
Received: from ?IPv6:2a00:23c5:5785:9a01:d41c:67e5:a11f:43fe? ([2a00:23c5:5785:9a01:d41c:67e5:a11f:43fe])
        by smtp.gmail.com with ESMTPSA id s18sm7584487wrr.27.2021.03.11.23.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 23:32:39 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Reply-To: paul@xen.org
Subject: Re: [net-next 1/2] xen-netback: add module parameter to disable
 ctrl-ring
To:     ChiaHao Hsu <andyhsu@amazon.com>, netdev@vger.kernel.org
Cc:     wei.liu@kernel.org, davem@davemloft.net, kuba@kernel.org,
        xen-devel@lists.xenproject.org
References: <20210311225944.24198-1-andyhsu@amazon.com>
Message-ID: <bb75476f-881a-bb6b-e368-0bf7044cd57e@xen.org>
Date:   Fri, 12 Mar 2021 07:32:38 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210311225944.24198-1-andyhsu@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/03/2021 22:59, ChiaHao Hsu wrote:
> In order to support live migration of guests between kernels
> that do and do not support 'feature-ctrl-ring', we add a
> module parameter that allows the feature to be disabled
> at run time, instead of using hardcode value.
> The default value is enable.
> 
> Signed-off-by: ChiaHao Hsu <andyhsu@amazon.com>

Reviewed-by: Paul Durrant <paul@xen.org>
