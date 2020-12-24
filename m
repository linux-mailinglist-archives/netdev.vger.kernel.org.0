Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A042E28FF
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 23:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729063AbgLXWPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 17:15:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51135 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728704AbgLXWPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 17:15:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608848056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OpzLpHtxke5GPVXdOMNFOhaA1c9Yik4R0aHPWq8pI48=;
        b=IafoOrdRB+2EYali4p7a7e2SsyfzzX/qlFMamrWcPgTbDyFgQcGagRm0NTWzwYGZ+s54bz
        /skhEY4YV1kIGmG6gxqXfQUVwLkdNwBmOrUmvjekPncHBh8gG/qriWmrugCyBBiZw9g7H9
        aQLsKgSrt9yU9lJPv2H4GKMv4WGl1wg=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-oO-M3ys3PnuGMFGTaXlSvA-1; Thu, 24 Dec 2020 17:14:14 -0500
X-MC-Unique: oO-M3ys3PnuGMFGTaXlSvA-1
Received: by mail-oi1-f197.google.com with SMTP id m15so1550121oig.20
        for <netdev@vger.kernel.org>; Thu, 24 Dec 2020 14:14:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=OpzLpHtxke5GPVXdOMNFOhaA1c9Yik4R0aHPWq8pI48=;
        b=DlxV3qmgc4o0ZFUVjDOeTzwGedv47wGHdn51JYpdZgiA8a+FX98R3WS3Z8AMSWERUK
         433InIcI9Wnga/8xEbCcqN225Fd47gFUcB9CTtFG0u8TLEl6fxCG99dPgz0F+OGz8Qvw
         IIBKIow4q00pvJ+8Kry7ykVp9drgtRH0g8FXpTtyXxBp53NrmH/UCuOr+O7zwwoFJvlt
         97gCgmQKXs6ezW3lm2HiOQzT8BoMU75tLNcyOExeuseLYd/WdV7JfO8zjNEw/8ZO/kU7
         barqwImtIdKeCBYCe/LEAxZkJ2SvRJtSsUicpfoUNw/Q+PalKjtgUyvvQFl914UCdccg
         vAAQ==
X-Gm-Message-State: AOAM531zhVWoVntadKfS+G0pG4Bi49B+FbEBilI+ALwpz5qcqsuCDN9l
        WnEc0QF517HktXTKRQAC+d/hbdEEUyOERj9gccnAXOwy9HIm7rYQQLUzcaE2BIvc++ySCTs8qev
        Fb5xjhetqywCviL8K
X-Received: by 2002:a05:6808:49a:: with SMTP id z26mr3795004oid.137.1608848054244;
        Thu, 24 Dec 2020 14:14:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzXn8fOtR0aIAl41R31bVitiskVsUroq1veIaDNDB3PtWemiAgpfxhqsP28XYoXKId96Xylfw==
X-Received: by 2002:a05:6808:49a:: with SMTP id z26mr3794998oid.137.1608848054077;
        Thu, 24 Dec 2020 14:14:14 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id n16sm7090100oov.23.2020.12.24.14.14.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Dec 2020 14:14:13 -0800 (PST)
Subject: Re: [PATCH] nfp: remove h from printk format specifier
To:     Simon Horman <simon.horman@netronome.com>
Cc:     kuba@kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, gustavoars@kernel.org,
        louis.peens@netronome.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, oss-drivers@netronome.com,
        linux-kernel@vger.kernel.org
References: <20201223202053.131157-1-trix@redhat.com>
 <20201224202152.GA3380@netronome.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <bac92bab-243b-ca48-647c-dad5688fa060@redhat.com>
Date:   Thu, 24 Dec 2020 14:14:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201224202152.GA3380@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/24/20 12:21 PM, Simon Horman wrote:
> On Wed, Dec 23, 2020 at 12:20:53PM -0800, trix@redhat.com wrote:
>> From: Tom Rix <trix@redhat.com>
>>
>> This change fixes the checkpatch warning described in this commit
>> commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of unnecessary %h[xudi] and %hh[xudi]")
>>
>> Standard integer promotion is already done and %hx and %hhx is useless
>> so do not encourage the use of %hh[xudi] or %h[xudi].
>>
>> Signed-off-by: Tom Rix <trix@redhat.com>
> Hi Tom,
>
> This patch looks appropriate for net-next, which is currently closed.
>
> The changes look fine, but I'm curious to know if its intentionally that
> the following was left alone in ethernet/netronome/nfp/nfp_net_ethtool.c:nfp_net_get_nspinfo()
>
> 	snprintf(version, ETHTOOL_FWVERS_LEN, "%hu.%hu"

I am limiting changes to logging functions, what is roughly in checkpatch.

I can add this snprintf in if you want.

Tom

>
> If the above was not intentional then perhaps you could respin with that
> updated and resubmit when net-next re-opens. Feel free to add:
>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
>

