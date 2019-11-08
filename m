Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22428F3E1D
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 03:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbfKHCdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 21:33:33 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41734 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfKHCdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 21:33:33 -0500
Received: by mail-pf1-f193.google.com with SMTP id p26so3685442pfq.8;
        Thu, 07 Nov 2019 18:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1baxNtgpBmJVIgMPxLLA9d+ZZLVZ++lDBeUowvPugUg=;
        b=iTqxtNGeHvluR2HdvC8SKuWTO98ORSYeMFZ5p8/ftInvgtTEtUgDJce+UmfI/Y40ZH
         cuJyqQYDmZF3SE61VFOJtzOXlLtJBh9Ymlt/rWEqb09+Q8LweoBGk/d4uLMHeodu+l7R
         i3rjA4KA9smJs6YzbFj9NHKvkEnB0oZcy0jAK2OSTuzgW93eUYM3BlUlLcHyIlrF77lm
         mABPShfPAAy36KlYtrTJ7LVdsvW4n3aNiYWDjlK/syGOvm9LULHidgpf/KlSCs83jVsF
         MKahF8AZ4ZP83QdSf9TIfXYrcje5KcVmzuyUmcTa6EeiKH3Uw4ncoRnWfgjRqGjJW6sf
         4FkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1baxNtgpBmJVIgMPxLLA9d+ZZLVZ++lDBeUowvPugUg=;
        b=EKeUZYZtMm/KXp2VJErr8QplC2Fw/xxfX/ErszqX8fECCPX+LrEqopgDPNoHXv9P8K
         K8wmsG/IS5UPk0c+U7b+t3i9mVD8sSgsRdysfmvVVz7+L94RX8ijCnAOJukhLUtbkHNt
         wKZpWOi6JNl2v7pjqKJXZnYaAn819wEebavECLz8x3jf6cEyYDnJ475PXf3AfDNwp6Yk
         DD+1ulmFUr1FQMMjWvYTenmfhhnMeRrbQql23J6o6GUUjsXXitVgwJO+mxqWnJhERVxB
         rM1GYW7yB8doMixmZkQJL69+X8qFa0POxX2B75U2nvFhqnF4wtovffmsoRoqDpI3iefW
         OmUA==
X-Gm-Message-State: APjAAAVEmWh4RffG+5eZhoZ0jiYA1bYHri7YWREaMPtoGCPrgoUAWu4b
        6p7XzijwNfvRq3OdKzIOZktU5EVW
X-Google-Smtp-Source: APXvYqzu0Er3/StLhuKqKDRxY1wE8Qsk8YFYtdP54IH3rJ9EJHW/jEIunl+ki7D9kCDzGPRu6e11hw==
X-Received: by 2002:a62:e708:: with SMTP id s8mr8711701pfh.80.1573180412480;
        Thu, 07 Nov 2019 18:33:32 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:d046])
        by smtp.gmail.com with ESMTPSA id s26sm3787170pga.67.2019.11.07.18.33.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 18:33:31 -0800 (PST)
Date:   Thu, 7 Nov 2019 18:33:30 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 07/17] selftests/bpf: Add test for BPF
 trampoline
Message-ID: <20191108023328.fmq5suz7bcmyqenb@ast-mbp.dhcp.thefacebook.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-8-ast@kernel.org>
 <1929869B-945B-4DBC-B6CD-0B6C397DA4EA@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1929869B-945B-4DBC-B6CD-0B6C397DA4EA@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 01:17:50AM +0000, Song Liu wrote:
> 
> 
> > On Nov 6, 2019, at 9:46 PM, Alexei Starovoitov <ast@kernel.org> wrote:
> > 
> > Add sanity test for BPF trampoline that checks kernel functions
> > with up to 6 arguments of different sizes.
> > 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> > tools/lib/bpf/bpf_helpers.h                   | 13 +++
> > .../selftests/bpf/prog_tests/fentry_test.c    | 64 +++++++++++++
> > .../testing/selftests/bpf/progs/fentry_test.c | 90 +++++++++++++++++++
> > 3 files changed, 167 insertions(+)
> > create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_test.c
> > create mode 100644 tools/testing/selftests/bpf/progs/fentry_test.c
> > 
> > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > index 0c7d28292898..c63ab1add126 100644
> > --- a/tools/lib/bpf/bpf_helpers.h
> > +++ b/tools/lib/bpf/bpf_helpers.h
> > @@ -44,4 +44,17 @@ enum libbpf_pin_type {
> > 	LIBBPF_PIN_BY_NAME,
> > };
> > 
> > +/* The following types should be used by BPF_PROG_TYPE_TRACING program to
> > + * access kernel function arguments. BPF trampoline and raw tracepoints
> > + * typecast arguments to 'unsigned long long'.
> > + */
> > +typedef int __attribute__((aligned(8))) ks32;
> > +typedef char __attribute__((aligned(8))) ks8;
> > +typedef short __attribute__((aligned(8))) ks16;
> > +typedef long long __attribute__((aligned(8))) ks64;
> > +typedef unsigned int __attribute__((aligned(8))) ku32;
> > +typedef unsigned char __attribute__((aligned(8))) ku8;
> > +typedef unsigned short __attribute__((aligned(8))) ku16;
> > +typedef unsigned long long __attribute__((aligned(8))) ku64;
> > +
> > #endif
> 
> Maybe a separate patch for bpf_helpers.h?

I squashed them to reduce the number of patches. It's already at 17
and I had to add another one. So v3 will have 18.

> Otherwise, 
> 
> Acked-by: Song Liu <songliubraving@fb.com>
