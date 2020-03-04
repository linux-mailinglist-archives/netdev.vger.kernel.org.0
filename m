Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8182179479
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 17:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729758AbgCDQHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 11:07:37 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34852 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgCDQHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 11:07:36 -0500
Received: by mail-pg1-f196.google.com with SMTP id 7so1205235pgr.2;
        Wed, 04 Mar 2020 08:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=K/7y8ZMU3WIhP1kFsvzstIINwJFwHV05bFrknRWRrd0=;
        b=U7RkoEpEcWGKSwRaRSHcI6QzQreTDg4+fvj1laeBWVKfNJNmnpjISDG+LqXZkINgzb
         Ln69gH28UGATmtMnnVKIWJEiqwkvx+G7zC79DHbdNroebYdt6tAOj/PVXCYqjfhozHi6
         LuB90fG4AEoT7SpQCtv42b5Pb+1J6ARppWjutqW2iQ2VcApiHXORZTgyOUF0eak8VtKe
         SMTzqy9EeIdqah69uQgCJZrpwo7chAmYr3eYKNWadOkuHebJnvh9HtwxAPlTAggJsVMi
         3psEKVpsiWoAQEbdbXOSDCTpCV4HLu8M8Z2hQaWorTvF2UAhn82jyCIhxuPBa5jOCciz
         oB8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=K/7y8ZMU3WIhP1kFsvzstIINwJFwHV05bFrknRWRrd0=;
        b=tzaNEWbqGPN9Z54LxltDIlLkg4A+r+A6ckcC+AOe4K4xtGukLjJjpVFGNSBehE/bt6
         DLvGijZni4PZPwYXj9WOokjfRXUQnqODKqHzki6Tp/OBqKXfxoUTWN+CYdYRGPkmoZmo
         vdsx1tJjPZFRnqMJxDm2kZBqFXezdnRuc5zt1Mgu1Ef1iO4JN5iDwBlyDaVRouVNKBVn
         tzBqDsBZBgCy3auYvoDK+2KPmiYOnjPdyXmvwZfGdjkVOLYmmE4stqlpwG5kpdevFrRY
         sQK32AgGrW46AWSqza79HpgscfxixK6zYue864XBoJlelvT3m4q6I4AiG7k+Y0qoQ3QC
         l5Lw==
X-Gm-Message-State: ANhLgQ0bme12nx9RRA7wScrEjEsQeOahvSELYdipo7bCLJMhXx8fcebn
        6+2jK+4+LU9w9IFV7YdGexw=
X-Google-Smtp-Source: ADFU+vvw2QHNjiGzwnowZMWgv4MAIh3vfG9LzEnOByGUty1QrYX+s6/Hnb5vN5F0WuTX6FNFnKi23w==
X-Received: by 2002:a63:ce03:: with SMTP id y3mr3304308pgf.427.1583338054688;
        Wed, 04 Mar 2020 08:07:34 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::4:c694])
        by smtp.gmail.com with ESMTPSA id 185sm21126065pfv.104.2020.03.04.08.07.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Mar 2020 08:07:33 -0800 (PST)
Date:   Wed, 4 Mar 2020 08:07:32 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: switch BPF UAPI #define constants
 used from BPF program side to enums
Message-ID: <20200304160730.lotus7x2ixwxw7lf@ast-mbp>
References: <20200303003233.3496043-1-andriin@fb.com>
 <20200303003233.3496043-2-andriin@fb.com>
 <fb80ddac-d104-d0b7-8bed-694d20b62d61@iogearbox.net>
 <CAEf4BzZWXRX_TrFSPb=ORcfun8B+GdGOAF6C29B-3xB=NaJO7A@mail.gmail.com>
 <87blpc4g14.fsf@toke.dk>
 <945cf1c4-78bb-8d3c-10e3-273d100ce41c@iogearbox.net>
 <c742d2d4-6596-3178-3d03-809270e67183@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c742d2d4-6596-3178-3d03-809270e67183@iogearbox.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 04:57:46PM +0100, Daniel Borkmann wrote:
> On 3/4/20 4:38 PM, Daniel Borkmann wrote:
> > On 3/4/20 10:37 AM, Toke Høiland-Jørgensen wrote:
> > > Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> > > > On Tue, Mar 3, 2020 at 3:01 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > > 
> > > > > On 3/3/20 1:32 AM, Andrii Nakryiko wrote:
> > > > > > Switch BPF UAPI constants, previously defined as #define macro, to anonymous
> > > > > > enum values. This preserves constants values and behavior in expressions, but
> > > > > > has added advantaged of being captured as part of DWARF and, subsequently, BTF
> > > > > > type info. Which, in turn, greatly improves usefulness of generated vmlinux.h
> > > > > > for BPF applications, as it will not require BPF users to copy/paste various
> > > > > > flags and constants, which are frequently used with BPF helpers. Only those
> > > > > > constants that are used/useful from BPF program side are converted.
> > > > > > 
> > > > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > > 
> > > > > Just thinking out loud, is there some way this could be resolved generically
> > > > > either from compiler side or via additional tooling where this ends up as BTF
> > > > > data and thus inside vmlinux.h as anon enum eventually? bpf.h is one single
> > > > > header and worst case libbpf could also ship a copy of it (?), but what about
> > > > > all the other things one would need to redefine e.g. for tracing? Small example
> > > > > that comes to mind are all these TASK_* defines in sched.h etc, and there's
> > > > > probably dozens of other similar stuff needed too depending on the particular
> > > > > case; would be nice to have some generic catch-all, hmm.
> > > > 
> > > > Enum convertion seems to be the simplest and cleanest way,
> > > > unfortunately (as far as I know). DWARF has some extensions capturing
> > > > #defines, but values are strings (and need to be parsed, which is pain
> > > > already for "1 << 1ULL"), and it's some obscure extension, not a
> > > > standard thing. I agree would be nice not to have and change all UAPI
> > > > headers for this, but I'm not aware of the solution like that.
> > > 
> > > Since this is a UAPI header, are we sure that no userspace programs are
> > > using these defines in #ifdefs or something like that?
> > 
> > Hm, yes, anyone doing #ifdefs on them would get build issues. Simple example:
> > 
> > enum {
> >          FOO = 42,
> > //#define FOO   FOO
> > };
> > 
> > #ifndef FOO
> > # warning "bar"
> > #endif
> > 
> > int main(int argc, char **argv)
> > {
> >          return FOO;
> > }
> > 
> > $ gcc -Wall -O2 foo.c
> > foo.c:7:3: warning: #warning "bar" [-Wcpp]
> >      7 | # warning "bar"
> >        |   ^~~~~~~
> > 
> > Commenting #define FOO FOO back in fixes it as we discussed in v2:
> > 
> > $ gcc -Wall -O2 foo.c
> > $
> > 
> > There's also a flag_enum attribute, but with the experiments I tried yesterday
> > night I couldn't get a warning to trigger for anonymous enums at least, so that
> > part should be ok.
> > 
> > I was about to push the series out, but agree that there may be a risk for #ifndefs
> > in the BPF C code. If we want to be on safe side, #define FOO FOO would be needed.
> 
> I checked Cilium, LLVM, bcc, bpftrace code, and various others at least there it
> seems okay with the current approach, meaning no such if{,n}def seen that would
> cause a build warning. Also suricata seems to ship the BPF header itself. But
> iproute2 had the following in include/bpf_util.h:
> 
> #ifndef BPF_PSEUDO_MAP_FD
> # define BPF_PSEUDO_MAP_FD      1
> #endif

Consider that users can do all sorts of stupid things with uapi headers like:
#if BPF_OBJ_NAME_LEN == 16
int foo;
#else
int bar;
#endif

Does that mean that we cannnot change any #define ever?
Of course not.

Consider that #define A A
is also broken in such cases:

For example:
enum {
        A = 1
#define A A
};
#if A == 1
int foo;
#else
int bar;
#endif

Will give different 'int' variable vs:

#define A 1
#if A == 1
int foo;
#else
int bar;
#endif

So ? Let's paralyze the development because of crazy users? No.
