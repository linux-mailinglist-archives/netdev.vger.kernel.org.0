Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF686118F01
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfLJR3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:29:37 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42326 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbfLJR3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:29:37 -0500
Received: by mail-wr1-f66.google.com with SMTP id a15so21019791wrf.9
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 09:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dfqL4lTwR6vF4OgmjVYmmQ0BJocxUPtWFk6FLv0rmCA=;
        b=LkrB+TljTffU1WXzKx9nmBM3P8FLlWbEMLgZlNlfSR7LPyQflKIj3MifLLbUO1/vpE
         o9J0pj+wPRRGYWRiEYNXtGTMrGsmHCaqRDZ4/rdZAkgfBd02SplFeijQLWwPxed/wAra
         QRN7um3b7S9x/vKiU6mFs2/e3D89WR1wYsINhYjY0C60X5/XaHCTIIcw2nkBobGQTEGW
         7SgSwB9RRBCCDuLrbrBTX9Qjyk+uLWGfO3UdXHaeDrwJU+hIdv1u7gOdL+sBLNPbENa1
         kuPPXJ6aARLZIq4El16rTzcYl/Um5utII937nuTyNPfujmfgHBhGBLynSYe66fPFrEd/
         06sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=dfqL4lTwR6vF4OgmjVYmmQ0BJocxUPtWFk6FLv0rmCA=;
        b=LoJp4TXtYMmToroWd0i77hDUhJCfQ4xpz/YwlniYms8KhcEBUy+EBV6FJOFyHt8FPm
         en5oVuENx+oC+ioA9N/GQXOBoi+tyQjpEowKCD/02Vl4wFl/kJe6IWJBaVcH8xKT1OrG
         oasAFTy59hKl2Xp5iAyxt5vYjeqsffOISIzK0a0E2taWxu/PscnSewAWDNnWrPKR2z7o
         m/ZG/diN09Y5Joyqlwcvg1rAn/c9L076wOuv1L49pJiIph66bxYdtww6RB17bLhgXbcr
         r/ETnQ2dBfTsxolmYd549xTvvbaZXMbxkoEQXa6iijfHbm5sV35BgUoTu0NaIhMq4okB
         U02Q==
X-Gm-Message-State: APjAAAUEFNykxn4cWFUvX0EdbghqCNk95okqggvOOX8ERrGmAMpmeEpX
        mAjxZAhl30WMNFAz02Vwq6s2kQ==
X-Google-Smtp-Source: APXvYqyoW01YTwj1I5d01YonnqvFycJwQtu8A2W6d6kY3yx5tQoh9KFcs160px5DcS7zoSNotFMgzA==
X-Received: by 2002:a5d:6652:: with SMTP id f18mr3109683wrw.246.1575998974147;
        Tue, 10 Dec 2019 09:29:34 -0800 (PST)
Received: from [172.20.1.104] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id k8sm4059419wrl.3.2019.12.10.09.29.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Dec 2019 09:29:33 -0800 (PST)
To:     Paul Chaignon <paul.chaignon@orange.com>, bpf@vger.kernel.org
Cc:     paul.chaignon@gmail.com, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <cover.1575991886.git.paul.chaignon@orange.com>
 <1e3ede4f901a36af342e71bc4fdd2b27fbf9a418.1575991886.git.paul.chaignon@orange.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [PATCH bpf-next 2/3] bpftool: match programs by name
Message-ID: <44b6c087-6ce3-2e3d-e33e-4b844632cc50@netronome.com>
Date:   Tue, 10 Dec 2019 17:29:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <1e3ede4f901a36af342e71bc4fdd2b27fbf9a418.1575991886.git.paul.chaignon@orange.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-12-10 17:06 UTC+0100 ~ Paul Chaignon <paul.chaignon@orange.com>
> When working with frequently modified BPF programs, both the ID and the
> tag may change.  bpftool currently doesn't provide a "stable" way to match
> such programs.
> 
> This patch implements lookup by name for programs.  The show and dump
> commands will return all programs with the given name, whereas other
> commands will error out if several programs have the same name.
> 
> Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>

Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>

Thanks!
Quentin
