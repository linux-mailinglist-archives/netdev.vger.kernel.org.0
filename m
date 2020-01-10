Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97ACC1374CE
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 18:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbgAJR3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 12:29:42 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:37589 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbgAJR3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 12:29:41 -0500
Received: by mail-qv1-f65.google.com with SMTP id f16so1082515qvi.4;
        Fri, 10 Jan 2020 09:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:message-id;
        bh=bY0iUxHC//y4vb2cenl2hFiLGkiCzoQ85yaxZ9qeXGQ=;
        b=JK8d5RZ/RUrql3HERwhvUHhDAMSQ29mfNnSSrED62cEWHopTE5oPE/V80qVDLjQ5pR
         0uZ9aUFUGYWtw/S1HvdQd9dZckW9dRkDJt5KH9tEPgDtljF1y2+IKyqUPu6DXniAuEPS
         uO4u4o+eOo1waxAkZGJidjzUsTBeZ4khOEMtlFAwn4AnyokQQZCgwoan5b16ucmt6nO3
         dksnGssqOBLy//sjN7RBMrwPL7gHMpK+BtMcKZmI4tvTL0W5OCJsVMOyKGMgftITTO4B
         MQ5uLeL1Ko28ddn4AH6hvs7H6e2I97EsJAy8YI+VwRZhrAsraGqD696xkXnjef69yP6D
         BJ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:message-id;
        bh=bY0iUxHC//y4vb2cenl2hFiLGkiCzoQ85yaxZ9qeXGQ=;
        b=hwAznMiB9gkydJsCMrivdTDA8+FKrNFj8M1QwCYVPEYh4yB1egrrEyoOwCg+JTVprv
         u1NRKsfYR63VR7vvyzReSoW/30jq2L/eJFgtGlT3Ga8idzkuOACWKiwlyR+5rcbu0Smg
         HJIrSuUwiMey6RPf4kyKYmokbNGvQRCN0cP7E8WajBQSIK8nlVFkOWXfCghZA0L3QfNN
         twX6Zwj6dN7Dts1HHSvqrJ4h7mzOI20ZcbFTWGA+LWsXEq/FrFn9M72gZoqr9BxcoXVX
         UkiRpjSmZRGchlxABu5PUR6egFcLmTVI1zz9zDxDwbGcKnHbdbSu1HQW9rGzVHdb6/Q0
         VsdQ==
X-Gm-Message-State: APjAAAVfG3UY3++A3BZZVlRGo/TZE9SD5chqrMyOrr9L0QFx0htbq6Kq
        UtjCIRiBmFGUOy8eSi3mC0c=
X-Google-Smtp-Source: APXvYqxlUUXQnN+OsZRt5FukvYMWYACR9vvj/jQ9EKpn4iE3q+fsvBsd5QmAbW1DtIf3aW6D5msA5A==
X-Received: by 2002:a0c:fac1:: with SMTP id p1mr3806842qvo.231.1578677380836;
        Fri, 10 Jan 2020 09:29:40 -0800 (PST)
Received: from [192.168.86.249] ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id x19sm1295156qtm.47.2020.01.10.09.29.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Jan 2020 09:29:40 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Date:   Fri, 10 Jan 2020 14:29:54 -0300
User-Agent: K-9 Mail for Android
In-Reply-To: <20200110172231.GB1075235@mini-arch>
References: <20200110164410.GA1075235@mini-arch> <20200110164729.GB2598@kernel.org> <20200110172231.GB1075235@mini-arch>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: pahole and LTO
To:     Stanislav Fomichev <sdf@fomichev.me>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
CC:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@fb.com, andriin@fb.com, morbo@google.com
Message-ID: <51CDC146-588F-46EF-9DB7-AAA9B1F219D2@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On January 10, 2020 2:22:31 PM GMT-03:00, Stanislav Fomichev <sdf@fomichev=
=2Eme> wrote:
>On 01/10, Arnaldo Carvalho de Melo wrote:
>> Em Fri, Jan 10, 2020 at 08:44:10AM -0800, Stanislav Fomichev
>escreveu:
>> > tl;dr - building the kernel with clang and lto breaks BTF
>generation because
>> > pahole doesn't seem to understand cross-cu references=2E
>>=20
>> tl;dr response:
>>=20
>> Yeah, so it may be the time to fix that, elfutils has interfaces for
>it,
>> and the tools that come with it handle cross-cu references, so we
>need
>> to study that and make pahole understand it=2E
>Sure, we can definitely help with the implementation unless someone
>is already actively working on it=2E Just wanted to make sure that's
>a known problem=2E
>
>From my (limited) looking at pahole sources, it seems that building
>and index on the first pass and doing a second pass to resolve
>cross-cu references is relatively easy to implement=2E Am I missing
>anything? (not a dwarf expert in any sense)=2E

Give it a try, please=20

>And where do the patches for pahole go? I don't see any pahole patches
>in bpf/netdev mailing lists=2E

Send it to me, cc
dwarves@vger=2Ekernel=2Eorg

- Arnaldo
>
>> - Arnaldo
>> =20
>> > Can be reproduced with the following:
>> >     $ cat a=2Ec
>> >     struct s;
>> >=20
>> >     void f1() {}
>> >=20
>> >     __attribute__((always_inline)) void f2(struct s *p)
>> >     {
>> >             if (p)
>> >                     f1();
>> >     }
>> >     $ cat b=2Ec
>> >     struct s {
>> >             int x;
>> >     };
>> >=20
>> >     void f2(struct s *p);
>> >=20
>> >     int main()
>> >     {
>> >             struct s s =3D { 10 };
>> >             f2(&s);
>> >     }
>> >     $ clang -fuse-ld=3Dlld -flto {a,b}=2Ec -g
>> >=20
>> >     $ pahole a=2Eout
>> >     tag__recode_dwarf_type: couldn't find 0x3f type for 0x99
>(inlined_subroutine)!
>> >     lexblock__recode_dwarf_types: couldn't find 0x3f type for 0x99
>(inlined_subroutine)!
>> >     struct s {
>> >             int                        x;                    /*   =20
>0     4 */
>> >=20
>> >             /* size: 4, cachelines: 1, members: 1 */
>> >             /* last cacheline: 4 bytes */
>> >     };
>> >=20
>> > From what I can tell, pahole internally loops over each cu and
>resolves only
>> > local references, while the dwarf spec (table 2=2E3) states the
>following
>> > about 'reference':
>> > "Refers to one of the debugging information entries that describe
>the program=2E
>> > There are four types of reference=2E The first is an offset relative
>to the
>> > beginning of the compilation unit in which the reference occurs and
>must
>> > refer to an entry within that same compilation unit=2E The second
>type of
>> > reference is the offset of a debugging information entry in any
>compilation
>> > unit, including one different from the unit containing the
>reference=2E The
>> > third type of reference is an indirect reference to a type
>definition using
>> > an 8-byte signature for that type=2E The fourth type of reference is
>a reference
>> > from within the =2Edebug_info section of the executable or shared
>object file to
>> > a debugging information entry in the =2Edebug_info section of a
>supplementary
>> > object file=2E"
>> >=20
>> > In particular: "The second type of reference is the offset of a
>debugging
>> > information entry in any compilation unit, including one different
>from the
>> > unit containing the reference=2E"
>> >=20
>> >=20
>> > So the question is: is it a (known) issue? Is it something that's
>ommitted
>> > on purpose? Or it's not implemented because lto is not (yet) widely
>used?
>> >=20
>> >=20
>> > Here is the dwarf:
>> >=20
>> > $ readelf --debug-dump=3Dinfo a=2Eout
>> > Contents of the =2Edebug_info section:
>> >=20
>> >   Compilation Unit @ offset 0x0:
>> >    Length:        0x44 (32-bit)
>> >    Version:       4
>> >    Abbrev Offset: 0x0
>> >    Pointer Size:  8
>> >  <0><b>: Abbrev Number: 1 (DW_TAG_compile_unit)
>> >     <c>   DW_AT_producer    : (indirect string, offset: 0x11):
>clang version 10=2E0=2E0 (https://github=2Ecom/llvm/llvm-project=2Egit
>5fe4679cc9cfb4941b766db07bf3cd928075d204)
>> >     <10>   DW_AT_language    : 12	(ANSI C99)
>> >     <12>   DW_AT_name        : (indirect string, offset: 0x0): a=2Ec
>> >     <16>   DW_AT_stmt_list   : 0x0
>> >     <1a>   DW_AT_comp_dir    : (indirect string, offset: 0x7a):
>/usr/local/google/home/sdf/tmp/lto
>> >     <1e>   DW_AT_low_pc      : 0x201730
>> >     <26>   DW_AT_high_pc     : 0x6
>> >  <1><2a>: Abbrev Number: 2 (DW_TAG_subprogram)
>> >     <2b>   DW_AT_low_pc      : 0x201730
>> >     <33>   DW_AT_high_pc     : 0x6
>> >     <37>   DW_AT_frame_base  : 1 byte block: 56 	(DW_OP_reg6 (rbp))
>> >     <39>   DW_AT_name        : (indirect string, offset: 0xa4): f1
>> >     <3d>   DW_AT_decl_file   : 1
>> >     <3e>   DW_AT_decl_line   : 3
>> >     <3f>   DW_AT_external    : 1
>> >  <1><3f>: Abbrev Number: 3 (DW_TAG_subprogram)
>> >     <40>   DW_AT_name        : (indirect string, offset: 0x4): f2
>> >     <44>   DW_AT_decl_file   : 1
>> >     <45>   DW_AT_decl_line   : 5
>> >     <46>   DW_AT_prototyped  : 1
>> >     <46>   DW_AT_external    : 1
>> >     <46>   DW_AT_inline      : 1	(inlined)
>> >  <1><47>: Abbrev Number: 0
>> >   Compilation Unit @ offset 0x48:
>> >    Length:        0x7f (32-bit)
>> >    Version:       4
>> >    Abbrev Offset: 0x0
>> >    Pointer Size:  8
>> >  <0><53>: Abbrev Number: 1 (DW_TAG_compile_unit)
>> >     <54>   DW_AT_producer    : (indirect string, offset: 0x11):
>clang version 10=2E0=2E0 (https://github=2Ecom/llvm/llvm-project=2Egit
>5fe4679cc9cfb4941b766db07bf3cd928075d204)
>> >     <58>   DW_AT_language    : 12	(ANSI C99)
>> >     <5a>   DW_AT_name        : (indirect string, offset: 0x7): b=2Ec
>> >     <5e>   DW_AT_stmt_list   : 0x3a
>> >     <62>   DW_AT_comp_dir    : (indirect string, offset: 0x7a):
>/usr/local/google/home/sdf/tmp/lto
>> >     <66>   DW_AT_low_pc      : 0x201740
>> >     <6e>   DW_AT_high_pc     : 0x1f
>> >  <1><72>: Abbrev Number: 4 (DW_TAG_subprogram)
>> >     <73>   DW_AT_low_pc      : 0x201740
>> >     <7b>   DW_AT_high_pc     : 0x1f
>> >     <7f>   DW_AT_frame_base  : 1 byte block: 56 	(DW_OP_reg6 (rbp))
>> >     <81>   DW_AT_name        : (indirect string, offset: 0x9d):
>main
>> >     <85>   DW_AT_decl_file   : 1
>> >     <86>   DW_AT_decl_line   : 7
>> >     <87>   DW_AT_type        : <0xae>
>> >     <8b>   DW_AT_external    : 1
>> >  <2><8b>: Abbrev Number: 5 (DW_TAG_variable)
>> >     <8c>   DW_AT_location    : 2 byte block: 91 78 	(DW_OP_fbreg:
>-8)
>> >     <8f>   DW_AT_name        : (indirect string, offset: 0xb): s
>> >     <93>   DW_AT_decl_file   : 1
>> >     <94>   DW_AT_decl_line   : 9
>> >     <95>   DW_AT_type        : <0xb5>
>> >  <2><99>: Abbrev Number: 6 (DW_TAG_inlined_subroutine)
>> >     <9a>   DW_AT_abstract_origin: <0x3f>
>> >     <9e>   DW_AT_low_pc      : 0x201752
>> >     <a6>   DW_AT_high_pc     : 0x5
>> >     <aa>   DW_AT_call_file   : 1
>> >     <ab>   DW_AT_call_line   : 10
>> >     <ac>   DW_AT_call_column :=20
>> >  <2><ad>: Abbrev Number: 0
>> >  <1><ae>: Abbrev Number: 7 (DW_TAG_base_type)
>> >     <af>   DW_AT_name        : (indirect string, offset: 0xd): int
>> >     <b3>   DW_AT_encoding    : 5	(signed)
>> >     <b4>   DW_AT_byte_size   : 4
>> >  <1><b5>: Abbrev Number: 8 (DW_TAG_structure_type)
>> >     <b6>   DW_AT_name        : (indirect string, offset: 0xb): s
>> >     <ba>   DW_AT_byte_size   : 4
>> >     <bb>   DW_AT_decl_file   : 1
>> >     <bc>   DW_AT_decl_line   : 1
>> >  <2><bd>: Abbrev Number: 9 (DW_TAG_member)
>> >     <be>   DW_AT_name        : (indirect string, offset: 0xa2): x
>> >     <c2>   DW_AT_type        : <0xae>
>> >     <c6>   DW_AT_decl_file   : 1
>> >     <c7>   DW_AT_decl_line   : 2
>> >     <c8>   DW_AT_data_member_location: 0
>> >  <2><c9>: Abbrev Number: 0
>> >  <1><ca>: Abbrev Number: 0
>>=20
>> --=20
>>=20
>> - Arnaldo

