Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41383911BD
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 17:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfHQPmN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 17 Aug 2019 11:42:13 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53784 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfHQPmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 11:42:13 -0400
Received: by mail-wm1-f68.google.com with SMTP id 10so6345367wmp.3
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 08:42:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:reply-to:to:cc:from
         :message-id;
        bh=Qd0oIy1nBOVm4/nqOs8e9DuBL87P48VzwG8FG+0SZ2o=;
        b=fMSRPfiFbJ4sMqyZvBO6WUyrVOL3DktGD4j1oNtPcjzrJJivqiMH+75ZDIahIOWtO8
         ATAuJXQXF0KGX+pdGMKRlEvnQsbMH8lRIHUw4LdvkYrqfVxwlmQfGrudgINCX2Zp/u1V
         0DUOKmkZbR9kNET22fX+DzJeUpNiZppZFKmJ7Ly1As4Gi3H1B59Qz/Vb/J/MmXWa6yS9
         ZNqXrn7nqHLXw311C+J2zIcnD6kC1yXzPP0ByMM7h0W6qrui4XTOZIy6lEUKPA+NDDmk
         2SaGtApAAow+62tQ3GQykb32w0XBr9z8K2X1nB3IQk5hvGtP6h3myWCWyCrNZVokOpOX
         Qqsw==
X-Gm-Message-State: APjAAAVx2PKA0rJmjPX5OHm6KaGf8zVCsZf/c1Ko6XCHyo2q7Robx8NK
        JaiKWfAd6uFvneuFJvxBhjIVCQ==
X-Google-Smtp-Source: APXvYqxFjIpGmcyyAEpctLk8McPd205v1VaqjR/IDxwQCh8P15fRgge/4HSPRfIqlImsBZW5T1vQmw==
X-Received: by 2002:a1c:ef18:: with SMTP id n24mr3069395wmh.29.1566056531210;
        Sat, 17 Aug 2019 08:42:11 -0700 (PDT)
Received: from HUAWEI-nova-2-351a175292c.fritz.box ([213.220.153.21])
        by smtp.gmail.com with ESMTPSA id b136sm18539660wme.18.2019.08.17.08.42.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 08:42:10 -0700 (PDT)
Date:   Sat, 17 Aug 2019 17:42:08 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <20190817153652.zfcsklt474j72dzm@ast-mbp.dhcp.thefacebook.com>
References: <20190806011134.p5baub5l3t5fkmou@ast-mbp> <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com> <20190813215823.3sfbakzzjjykyng2@ast-mbp> <201908151203.FE87970@keescook> <20190815234622.t65oxm5mtfzy6fhg@ast-mbp.dhcp.thefacebook.com> <B0364660-AD6A-4E5C-B04F-3B6DA78B4BBE@amacapital.net> <20190816214542.inpt6p655whc2ejw@ast-mbp.dhcp.thefacebook.com> <20190816222252.a7zizw7azkxnv3ot@wittgenstein> <20190817150843.4vsmzpwpcvzndjld@ast-mbp> <61B88085-9FBB-41E6-9783-324E445E428D@ubuntu.com> <20190817153652.zfcsklt474j72dzm@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Reply-to: christian.brauner@ubuntu.com
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andy Lutomirski <luto@amacapital.net>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
From:   Christian Brauner <christian.brauner@ubuntu.com>
Message-ID: <C3F5D971-9698-4442-8F9C-091E18E774A9@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On August 17, 2019 5:36:54 PM GMT+02:00, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>On Sat, Aug 17, 2019 at 05:16:53PM +0200, Christian Brauner wrote:
>> On August 17, 2019 5:08:45 PM GMT+02:00, Alexei Starovoitov
><alexei.starovoitov@gmail.com> wrote:
>> >On Sat, Aug 17, 2019 at 12:22:53AM +0200, Christian Brauner wrote:
>> >> 
>> >> (The one usecase I'd care about is to extend seccomp to do
>> >pointer-based
>> >> syscall filtering. Whether or not that'd require (unprivileged)
>ebpf
>> >is
>> >> up for discussion at KSummit.)
>> >
>> >Kees have been always against using ebpf in seccomp. I believe he
>still
>> >holds this opinion. Until he changes his mind let's stop bringing
>> >seccomp
>> >as a use case for unpriv bpf.
>> 
>> That's why I said "whether or not".
>> For the record, I do prefer a non-unpriv-ebpf way.
>> It's still something that will most surely come up in the discussion
>though.
>
>It's very un-kernely way to defer to in-person meetings.
>If there is anything to discuss please discuss it on the public mailing
>list.

https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2019-July/006699.html
