Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D84F1825FC
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 00:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731446AbgCKXmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 19:42:22 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45391 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCKXmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 19:42:22 -0400
Received: by mail-pl1-f194.google.com with SMTP id b22so1838785pls.12;
        Wed, 11 Mar 2020 16:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=B2KIOZXAKL4mhVnKlXociLNQKh63L3RnkEVoYPvSaZI=;
        b=qtg1+XsATpphmdJ8wIZRGtXLq7JnFCODxrNZY0IV4fzYbHkXaNughHfuxRGSGmnOpC
         69HG14eUyOQej8cz/XjagBE7PkulWeOkW9zezk69ucfUzBqWq0D98bMNCq85icx3Fy9W
         2QdiaaA7pi9rEJxuR/pdcJ0RpiPwRdDtedmD0tIpAKUZExaHjEMGdxsOQMOcHIUcOw/n
         mi2UO1Y0I6+p2+dmYwobB+CWXvmdtJIsYxfzq422ApYHgmz8Xxgz2Qyp+hLmqVCfdZ45
         392XnzpjzGDLyeBZ7HKip79jyg/Y8YAozT5DwyhmfbbIiEqDCaymXTiE6hNO/Sx3BpVF
         lGCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=B2KIOZXAKL4mhVnKlXociLNQKh63L3RnkEVoYPvSaZI=;
        b=b0KyyPBrOKWXZcdEDzWFHz/UsCltUvS3v1pHeQQZ2FqiuSCUwGnu/QhmkWKn7RAMNh
         DNkFjcYu0DMKNKhbZs+SznrxTP/NMuM4/Uok8YhlvOzvEOZ1Zba97vwUuGi5lL6aTa5S
         Hpjoh0Iz0uosj0yW90Np0cwoYwt/GfY7PNF4d9hO26DZ98hyx2onZ1M9jiXXB1jJvryi
         wwPube27DCB9tvNVkQt4SXrlEndyMX4kLxw5WqswBo8j5rV8YiD28xBYKRDcfxNiLUQX
         VW4FHnef0haVk/XGo0cM9t1iRDVRcT6bhZC28iHm7SGUvGMpTuDMbE/EFV3UL/gC5TTP
         HBmg==
X-Gm-Message-State: ANhLgQ1wilvJ2SNr+B8Ix4TzjKEpw0mcZA1lJRRVAm2om1qX9Ehmqz5B
        ++DG0PcqSTSRYHqh1+7qLvQS7Z8a
X-Google-Smtp-Source: ADFU+vvVKwmvSA0tssq/GJ7H5tQMhwjYpDAuZBGAy4rMKk3EsWdXr1YwK+tXL3a/PHw+OUbyOUfGoQ==
X-Received: by 2002:a17:90b:124a:: with SMTP id gx10mr1148213pjb.117.1583970140839;
        Wed, 11 Mar 2020 16:42:20 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id i5sm34068457pfo.173.2020.03.11.16.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 16:42:20 -0700 (PDT)
Date:   Wed, 11 Mar 2020 16:42:14 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5e69775639097_20552ab9153405b46b@john-XPS-13-9370.notmuch>
In-Reply-To: <20200311021205.9755-1-quentin@isovalent.com>
References: <20200311021205.9755-1-quentin@isovalent.com>
Subject: RE: [PATCH bpf-next] tools: bpftool: restore message on failure to
 guess program type
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quentin Monnet wrote:
> In commit 4a3d6c6a6e4d ("libbpf: Reduce log level for custom section
> names"), log level for messages for libbpf_attach_type_by_name() and
> libbpf_prog_type_by_name() was downgraded from "info" to "debug". The
> latter function, in particular, is used by bpftool when attempting to
> load programs, and this change caused bpftool to exit with no hint or
> error message when it fails to detect the type of the program to load
> (unless "-d" option was provided).
> 
> To help users understand why bpftool fails to load the program, let's do
> a second run of the function with log level in "debug" mode in case of
> failure.
> 
> Before:
> 
>     # bpftool prog load sample_ret0.o /sys/fs/bpf/sample_ret0
>     # echo $?
>     255
> 
> Or really verbose with -d flag:
> 
>     # bpftool -d prog load sample_ret0.o /sys/fs/bpf/sample_ret0
>     libbpf: loading sample_ret0.o
>     libbpf: section(1) .strtab, size 134, link 0, flags 0, type=3

[...]

> After:
> 
>     # bpftool prog load sample_ret0.o /sys/fs/bpf/sample_ret0
>     libbpf: failed to guess program type from ELF section '.text'
>     libbpf: supported section(type) names are: socket sk_reuseport kprobe/ [...]
> 
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>

lgtm

Acked-by: John Fastabend <john.fastabend@gmail.com>
