Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE7B01479EA
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 10:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730066AbgAXJAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 04:00:18 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36560 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgAXJAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 04:00:15 -0500
Received: by mail-oi1-f193.google.com with SMTP id c16so1204826oic.3
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 01:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y5EdAX4jkVg2iEO+KKBvYFZ7L2IwmUhmxABZtxwTDV0=;
        b=SYiA638TtjKWHVPo9XbMk9DzdWhGr1CIMjfL5RmNwAC2FuJ6BOftRJALOXEDQiOQgD
         0fjQoQpuqFcsjWawODT6waRgT8tHbtcT5JbVS8ovS/gCJVG1G3aXBRiiXbpoEpsTruoE
         k8771UvRA3plyOhzpLxUGm4QDuiJyGVU7AgoI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y5EdAX4jkVg2iEO+KKBvYFZ7L2IwmUhmxABZtxwTDV0=;
        b=V/KwjYOgQvGC7RY9sm4HRAI5JF1gagTCD2RsCUhR+tlWS4JdznjZ0T+rT9ARvQ18iW
         hPXc3GeLlDjLBW+YBoOy6CMjVnU/cK6nyLc4az+7VAB87OWrma8m39hRr4q8VvYI3qFv
         xpreELoUcv/8Rh2Nd/IaBdkPMTPuXLYzFFHz+n47a+qkE/RGK1K+mo7HBm3Qs+vjRInL
         iSBT19hzGei/DRzPW6g6/sJN+R9D6u9pZy4yWfaha3+6SwURc+HjVOsXXT4f0E8L5ch2
         +Q7y6AILC00HyT/kUmTunjSu/2wNORmb1pmCQucsMzR9p7iTHE90R6TL5HrpqmoEXrTO
         0O7w==
X-Gm-Message-State: APjAAAXxpmYtfNMVfzpxQ5f4EiJvSXrm3ZzQnFECZLMCCCygg1SSrgzs
        7xI3XDJSvYG+Cp8ckHaWQCdLcmmdUJwvDtb+caGr8Q==
X-Google-Smtp-Source: APXvYqwCWyvS3/fUmsDI0shGPjRGN1rHYxo1MRumsxADvX5K0fx2R5oslkof/sexUronmyCand4NPkj0N/nR2Fj0XYs=
X-Received: by 2002:aca:2419:: with SMTP id n25mr1382621oic.13.1579856414929;
 Fri, 24 Jan 2020 01:00:14 -0800 (PST)
MIME-Version: 1.0
References: <20200123165934.9584-1-lmb@cloudflare.com> <20200123165934.9584-3-lmb@cloudflare.com>
 <20200123215348.zql3d5xpg2if7v6q@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200123215348.zql3d5xpg2if7v6q@kafai-mbp.dhcp.thefacebook.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 24 Jan 2020 09:00:03 +0000
Message-ID: <CACAyw9_OGBbsXepTcp=1frEHB7Q2cD9BVXTbgt7Ci_eFyV2Egg@mail.gmail.com>
Subject: Re: [PATCH bpf 2/4] selftests: bpf: ignore RST packets for reuseport tests
To:     Martin Lau <kafai@fb.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jan 2020 at 21:54, Martin Lau <kafai@fb.com> wrote:
>
> btw, it needs a Fixes tag.
>
> Patch 4 and Patch 1 also need a Fixes tag.

This makes me wonder, should these go via bpf or bpf-next? Do I have
to split the series then?

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
