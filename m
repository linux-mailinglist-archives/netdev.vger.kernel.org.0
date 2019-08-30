Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6EF4A354E
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 12:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbfH3K63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 06:58:29 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34652 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727729AbfH3K63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 06:58:29 -0400
Received: by mail-wm1-f67.google.com with SMTP id y135so4129315wmc.1
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 03:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9CpyVOrDFv1zt16Yb/z6NLqAEIi4lxQuGba4ZFYUuTI=;
        b=1rDRQ2CyCRRmgGcJjF43OT4k6V2wbPbzSREp9EUi3zSVmFDEQ8Wt86gcUlHSweK+jf
         6m4sGm310vSCHmyisRyc40JVVogAagJ3d+gUEeIrYk64AjBm/rFt+GSzarCvLOOjQPA7
         yY4G3QfRrERAbnrNUn/MG6/p2+TwyN0QOlSM/r8sUyw693QhxRAPMGniiTw7Uo8kGBjQ
         wR2wZx0bpSlg2KjpqCbpeCFcLdks2FSa0xzkeIvzzjN2nUF2KsnTwyRUQ71J/qqCrm3o
         R+j1YDoVih1zOAqSQTiokXEWl40yusK7fLbhCHZLRI7H+1Ryd6gxn1RYdXoHLe8bnK12
         F8qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=9CpyVOrDFv1zt16Yb/z6NLqAEIi4lxQuGba4ZFYUuTI=;
        b=TdQ83a5UjPHIO1TYXkXrG6ZdLxeM5F5BDGWYml9fvBHJtuLSh+j0AeJK+VhPQdIO58
         aXypilGSt7ysu6EHrxXHnR7/wM9aR8Ouj4itxnrnUGgtI9sdhAONmmU6JPxyFQWgAyH8
         3HZqYEGALpnF8622UQYHYq+MjGY85y4Sy60n47G6NbV0iZG+chKxtGbZkRgPhnAKmTUq
         HUGUH0cAazSM0BE3ymuUd+/Ea4lKtpPhLsHZgMi3F8fNAY+y6NhrSSvms3zCRqifxYzF
         3fXY3s8bvdnJ49LPGH/gwzU0eDp37FgnG5HdEQZiXYxqQ36G5dnvJFw4yPNbHWe6Rg+k
         G9Pg==
X-Gm-Message-State: APjAAAUnPIFWRkqZ0V232PmVKYufvq8vZcXCQm3xmp32SGU49EDA//IT
        aeQiDNQv90LBmGpa/VEZBsASUQ==
X-Google-Smtp-Source: APXvYqzIysqfPzqIDEM9B3uLUqQPvdu3znarQsPqBr8ztqqLGVI8pKjWqS9HWh4FxFSrPQLx2HToOA==
X-Received: by 2002:a1c:a60f:: with SMTP id p15mr2563931wme.128.1567162706492;
        Fri, 30 Aug 2019 03:58:26 -0700 (PDT)
Received: from [172.20.1.254] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id f7sm10278846wrf.8.2019.08.30.03.58.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 03:58:25 -0700 (PDT)
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
References: <20190829105645.12285-1-quentin.monnet@netronome.com>
 <20190829105645.12285-3-quentin.monnet@netronome.com>
 <C90F7A80-D2E9-401B-8BFC-47C22A44ADAC@linux.ibm.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [PATCH bpf-next 2/3] tools: bpftool: improve and check builds for
 different make invocations
Message-ID: <8f127330-4395-92c8-a18e-3ac4ff80050b@netronome.com>
Date:   Fri, 30 Aug 2019 11:58:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <C90F7A80-D2E9-401B-8BFC-47C22A44ADAC@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-08-29 18:03 UTC+0200 ~ Ilya Leoshkevich <iii@linux.ibm.com>
>> Am 29.08.2019 um 12:56 schrieb Quentin Monnet <quentin.monnet@netronome.com>:
>>
>> +make_and_clean() {
>> +	echo -e "\$PWD:    $PWD"
>> +	echo -e "command: make -s $* >/dev/null"
>> +	make $J -s $* >/dev/null
> 
> Would it make sense to set ERROR=1 if make produces a bpftool binary,
> but still fails with a non-zero RC for whatever reason?
> 

Hi Ilya,

Generating bpftool being the last thing the Makefile does, I don't know
if this could happen. But sure, that wouldn't hurt, and I will add it to
v2, thanks!

Quentin
