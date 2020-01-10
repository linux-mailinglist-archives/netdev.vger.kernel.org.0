Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0031137A15
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 00:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgAJXUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 18:20:42 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38607 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727175AbgAJXUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 18:20:41 -0500
Received: by mail-pl1-f196.google.com with SMTP id f20so1415191plj.5;
        Fri, 10 Jan 2020 15:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=KCVOgfQdxZ9PXTcLGm84N1El0dyVEoP1FKFbu5Cwbso=;
        b=LT87Ec4L7nf8z5n3TGbsKwOyCJ/SAvvN0saNq/nA2W26dxoBxt8a/axu90tB532cfN
         2rFAbIurrxH7lqg4tWFpuLNmEAcGcJqwYdSWTv38Ff/jBO1Ns8PRxYdoi2lHEc+KJQxF
         iTEDOc281ukbCgpy+1QtEeRG2vlzgUEYHIYiFV6dSGTwv7vRcKCV7/9oGIBMyJN+FC+/
         P3tUrY60+oPZsolLqXBO3E7w6Ty0IqVtCiWEMDW62qSvRKc9H1HHRBi0jrYfxHu9exko
         pEOTEMFKuAKS9JhQfU6827NrZeO0pYZnnDUFALC0KVtlnkxTFZNJijOiP4X5MId4lSDu
         cjfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=KCVOgfQdxZ9PXTcLGm84N1El0dyVEoP1FKFbu5Cwbso=;
        b=kN6PP7Jd4h+YZQD7RNeVeUIw8X+Wo1Au1PTKj5MOhJ3Xtvhk4LkCDSX+mnMjVU9jq2
         9nGPzaH/oPQI+SwSIGDTrhNCcTDxbXuLS23XgrGOPtJG3YnElINfeoknRNqc/As0WPy0
         fxPHH29/BBYYMzJkqt5E8wdad+uH7JI8wWdjfcebat7zSoasMvLd9IKE/0IQgZd0Mf33
         H30EXMGGloQxrSV/Q43S1mjDNfrD8HOOJ3Er95y18bR2rcMLESb/ogOZmVFZCfGMCykW
         bKqMSCHHdabtGBOpQGTNPSjJOPfotjnx2ZfwxCt97mzK6mJRi2QQ/dKsbsHm7peQvkG/
         O2Mw==
X-Gm-Message-State: APjAAAVwnDLn5D5XbcAaV0EG13Bt5eS7SPSJGBjoGdJ2wrNmxUBaTwDR
        AcQguOtUi8TyMAESCGR8UGI=
X-Google-Smtp-Source: APXvYqx59+rWsfeJleSQAqkH+QRrVGCw8NYok39v/l8Gz5TL9EsT1cyo6WUUQ6A5j9WYiAGd+HuWRQ==
X-Received: by 2002:a17:90a:8d84:: with SMTP id d4mr8079069pjo.114.1578698441102;
        Fri, 10 Jan 2020 15:20:41 -0800 (PST)
Received: from localhost (198-0-60-179-static.hfc.comcastbusiness.net. [198.0.60.179])
        by smtp.gmail.com with ESMTPSA id p5sm3941318pgs.28.2020.01.10.15.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 15:20:40 -0800 (PST)
Date:   Fri, 10 Jan 2020 15:20:39 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5e1906c73a2b7_20f32b2a8c44e5bc2d@john-XPS-13-9370.notmuch>
In-Reply-To: <5e179a4def787_28762abb601485c027@john-XPS-13-9370.notmuch>
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
 <157851817088.1732.14988301389495595092.stgit@ubuntu3-kvm2>
 <CAPhsuW774z68g_Y-C1XU70H-x6S2mr+Hd0-qY02E9aZBJjepkA@mail.gmail.com>
 <5e179a4def787_28762abb601485c027@john-XPS-13-9370.notmuch>
Subject: Re: [bpf PATCH 8/9] bpf: sockmap/tls, tls_push_record can not handle
 zero length skmsg
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Song Liu wrote:
> > On Wed, Jan 8, 2020 at 1:17 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > >
> > > When passed a zero length skmsg tls_push_record() causes a NULL ptr
> > > deref. To resolve for fixes do a simple length check at start of
> > > routine.
> > 
> > Could you please include the stack dump for the NULL deref?
> > 
> > Thanks,
> > Song
> 
> Sure I'll send a v2 with the stack dump.

Hi Song, I'm having a bit of trouble reproducing this now. I'm going to
drop this patch from the series for now and see if something changed in
crypto layers or elsewhere. I originally saw this on a bit older kernel
so something might changed. Feels a bit like a work-around anyways so
I'll dig into it a bit more.

Either way I'll try and understand this a bit better. Thanks for the
question.
