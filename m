Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 382F32C128
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 10:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfE1IZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 04:25:09 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53779 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfE1IZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 04:25:08 -0400
Received: by mail-wm1-f67.google.com with SMTP id d17so1811236wmb.3
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 01:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=OXLAySmmEuRQc6rBVY3uAU8iwA38+cdB/7jMvXY9crc=;
        b=OyftP4zJNXJJJwFNCZ493Y1eA0Q+WLf2EK/YTRi7yFRlG4lglteL241ZXQh1njxTAH
         Qi1Su5WowIQ1xArmDuwgnoRFJkj5UD8mxLSlXyuOILoetvKJnpcQ8+RhZ/alqEQo85NR
         WRs+CHeIqXz8Ln+ucLym653kZv+zxJknYql/qY4TI+NtlrmK64ZOCIwrbFL/aU8FDcal
         fDBeLv8JDk2CqYX2FZmovi8+XYEU33SFPFmFseQaqzItRYzC5Mwnv6IDfeodLWmU6+2x
         Yva+5VnOFh65ccrdcbrZJGqTQF/+ZIBerd/hO/xuiJNasvzjY2Gw68EtvRuPpbKYIOkS
         VWZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OXLAySmmEuRQc6rBVY3uAU8iwA38+cdB/7jMvXY9crc=;
        b=ef4eA11PkxEJyCFZo5PhmeRsqUvhlNBykL3No1K/IDSyzcoMejyM1m9TwZFCECqaSD
         uqKm0qbCOW5tPUblHpZE17SkRSinGTbQMYBSLK/tjqi6REWKwuS3MSixUV/QgCUjtapc
         mRdZEbMpGQDrCe5rVxJfN306cGjJXPrt6JAdJcRvvd6xtJv6KYXDFI5GPI6RL2dc2SAx
         V80icXOl99Mz4ItSlf5xKz7YUG1sjYhBGjb7cLXgFFMhPGkjJpfkLvIzcxCASpK1kCvC
         OsCqkoq41LzwAlQtNC1LfgxmWiC4c0IXvSD62QPh2CP79/t6fM94s/9vnsTmkBgkAgec
         qR2Q==
X-Gm-Message-State: APjAAAVGOTwuXriZJ41CWTOBVCPZDIBvTbG+ebMAAIYFwKraNGROGLO+
        m7DQ+1GKjgEtNrUURWuEYcPq6A==
X-Google-Smtp-Source: APXvYqx4mue3/rXaZEAjR/1/x6k2pEzc0YsV/DfQrGV0bmOFgWftinFkQwlxlVl6nZHxwNdVJ71UQg==
X-Received: by 2002:a1c:448b:: with SMTP id r133mr2282485wma.114.1559031906462;
        Tue, 28 May 2019 01:25:06 -0700 (PDT)
Received: from [192.168.1.2] ([194.53.186.20])
        by smtp.gmail.com with ESMTPSA id k184sm4881771wmk.0.2019.05.28.01.25.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 01:25:05 -0700 (PDT)
Subject: Re: [PATCH bpf-next] bpftool: auto-complete BTF IDs for btf dump
To:     Andrii Nakryiko <andriin@fb.com>, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
References: <20190526000101.112077-1-andriin@fb.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Message-ID: <bcae60bd-d432-0fbe-749f-abe2dc742769@netronome.com>
Date:   Tue, 28 May 2019 09:25:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190526000101.112077-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-05-25 17:01 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> Auto-complete BTF IDs for `btf dump id` sub-command. List of possible BTF
> IDs is scavenged from loaded BPF programs that have associated BTFs, as
> there is currently no API in libbpf to fetch list of all BTFs in the
> system.
> 
> Suggested-by: Quentin Monnet <quentin.monnet@netronome.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>

Thanks!
