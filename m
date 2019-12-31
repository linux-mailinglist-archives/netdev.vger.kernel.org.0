Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D5312D625
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 05:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfLaE24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 23:28:56 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:35274 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfLaE2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 23:28:55 -0500
Received: by mail-il1-f196.google.com with SMTP id g12so29409357ild.2;
        Mon, 30 Dec 2019 20:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1//cQc64IuovWYj4WhzsoE+Ao3+S4jCWs4UymnGf/Xk=;
        b=DIaKSrzCX5+Ki0Iw62F8VA5pOlboK8CPTfMBAsKIz1Uz/dkgRjzxFQxCDvixq5N6gI
         MmMKbWDgjc7kF87im4ix07oz19RZgjDdKAnoXLJDzfdrpPxrVIMIPEtIGfAM/ZnNIB6d
         cCl3687Z3orVQTuUt8kww3GddaObQvNAkAgBlhzkI7bF7TClX0T589de5HD3ibhdLDNl
         1J/AjiRmZRKLspwsvj+qisFTcW/QFjh0gOThNCJ4Msl0rNUiOR6QpWGh6djw75rGsjiV
         BQuqRC9rLafQU0PeIf5hxAokW60MuyoanBkTS4MjIbLlCht0AmfLMJHDyZaorsqYXfVX
         Q4iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1//cQc64IuovWYj4WhzsoE+Ao3+S4jCWs4UymnGf/Xk=;
        b=DBtx9nlqnSkYEg0fWigP5KIleG6PJ4TZ2ibgNAzrWeDnikXF55FYI2UPQS+PJCd5hn
         VjyC4MINL2uOF+xxDglDh9+O1zYpUMKEvmjgLvGAY68z3xvu46Nbz4sdtBudrzaVb4OW
         Rt0iS/2wwXZ8WHPM/QMKnaPxb+zOf0S68vgl4guLQjyQUtX7JfNaa6y3oUSHFA8rHOxS
         /6F6TahYlP3lDQWTZEpHesV8clBwSPzmOG508kFk7XBQs8fcRYaQ8yj3YCBk0k8n8Uhu
         786YLLfCktCvygW+hjhBrUE64+GtNcOOrMrLp6175OzdCxOx4GuZ1wkAYEaqAU8BynDC
         rjFQ==
X-Gm-Message-State: APjAAAURCfUwycFtetokNy/ZF8/vEC2ZDjY/gAQQKe+jHUrEcj5ySte/
        CTeJ3v6wV+gtGlFxscGzASNdIOil
X-Google-Smtp-Source: APXvYqwJrzXJoIw5Rja0On7ZLTdI4PohgZRCZrfffosOhkY+Kyvtx4nOox8Dtn6UZvc+HJjtEvsBOQ==
X-Received: by 2002:a92:1699:: with SMTP id 25mr60153544ilw.234.1577766534760;
        Mon, 30 Dec 2019 20:28:54 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:ed82:9285:ce7:fa57? ([2601:282:800:7a:ed82:9285:ce7:fa57])
        by smtp.googlemail.com with ESMTPSA id m189sm11909619ioa.17.2019.12.30.20.28.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2019 20:28:54 -0800 (PST)
Subject: Re: [PATCH bpf-next] bpftool: allow match by name prefixes
To:     Paul Chaignon <paul.chaignon@orange.com>, bpf@vger.kernel.org
Cc:     paul.chaignon@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
References: <20191227161657.GA16029@Nover>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c0302d0f-e77b-97a0-13f7-50e09ac92600@gmail.com>
Date:   Mon, 30 Dec 2019 21:28:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191227161657.GA16029@Nover>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/27/19 9:16 AM, Paul Chaignon wrote:
> This patch extends bpftool to support lookup of programs and maps by
> name prefixes (instead of full name only), as follows.
> 
>   $ ./bpftool prog show name tcp_
>   19: kprobe  name tcp_cleanup_rbu  tag 639217cf5b184808  gpl
>       [...]
>   20: kprobe  name tcp_sendmsg  tag 6546b9784163ee69  gpl
>       [...]
> 

This should be more generic in matches - not just the names beginning
with. Full regex might not be warranted, but certainly more than just
begins with. e.g., handling *tcp*.
