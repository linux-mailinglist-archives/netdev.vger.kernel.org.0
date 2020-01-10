Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E811137407
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 17:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbgAJQrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 11:47:33 -0500
Received: from mail-qt1-f170.google.com ([209.85.160.170]:42047 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728543AbgAJQrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 11:47:33 -0500
Received: by mail-qt1-f170.google.com with SMTP id j5so2430884qtq.9;
        Fri, 10 Jan 2020 08:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wTylJod4sVPFt5UWbUUrZ07QgAAqI1Um4GGOhdwGCnw=;
        b=c6a/u6Qqzf4ZKB/66+MLr8sowsPeFzJfm7NcfAASFjO9OpUzfgX5AbsOOkpW/H6ws/
         kS1B8L1dtnQ504IBhre3TB1CopWT5W+sOzhoTLu1pvwlZn8mcZv9DnwiikA+cq0AgPMc
         S99mu26p7zTFKE/xXI8yc5jRIwFDx6LxNg17RKmQay6peeL8Xo36+OFe3SjHbXMKCVnY
         VlwvupKJqwvk/VgxcFXZnlQCrIQxhbRB3jmnfL5kmF7K2AiLqnzrMtNO3BrTEQQbmt4G
         wZLFI0D+Tf3cp/WMcWhqXIgYyAjRJfN1zWYnEVFAVHr+dGDkROEEb+LaqCoaQVhexraL
         qp+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wTylJod4sVPFt5UWbUUrZ07QgAAqI1Um4GGOhdwGCnw=;
        b=MeZQrQvUmff2X4+665vmbQ162aESxh+ejSd186+gV1jP2MSBkRyhxjXSYJvqOdhMZ6
         qHq1TFt7LDDiSQZztyTRjr2AyoFnhwnc4uHKnEX1hna6gN7GaFwIXIGeA/qr/eQwQXnC
         cbrY/8B45EBaPVXNhGEPBg0XnNAOKJFlK2Uc7iWE425544IC8LRsvtXJE4DGFcFjeLYJ
         n7yAhnilEEOtiY6CRhNH8zIJOv/NtNsSmzmRq9ZoUZ3iEKtUMOea+2FDJPDclgMHsVzm
         NUqygmUR4UVINlRjt97Ui5UBTt9bsKmbAkC5DG4JfHcncmS8a5WlmIV38KNJyxqW9haT
         WxjQ==
X-Gm-Message-State: APjAAAUV7fu2pcY71UnTVHC6jS2Xt+54bc2WC9KOp5dBAyxdG31p0P72
        YxMdUgNxH1oKmGcLuZF1fnA=
X-Google-Smtp-Source: APXvYqz8kwGEdebSAut/FOT50E+S0RKCIfpQkrxdE5LJ68x/wltV+4hUc1SeK90Jp2GEaprE9G4c4w==
X-Received: by 2002:aed:3ea7:: with SMTP id n36mr3241667qtf.258.1578674851686;
        Fri, 10 Jan 2020 08:47:31 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id n4sm1215004qti.55.2020.01.10.08.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 08:47:31 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 1870A40DFD; Fri, 10 Jan 2020 13:47:29 -0300 (-03)
Date:   Fri, 10 Jan 2020 13:47:29 -0300
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@fb.com, andriin@fb.com, morbo@google.com
Subject: Re: pahole and LTO
Message-ID: <20200110164729.GB2598@kernel.org>
References: <20200110164410.GA1075235@mini-arch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110164410.GA1075235@mini-arch>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Jan 10, 2020 at 08:44:10AM -0800, Stanislav Fomichev escreveu:
> tl;dr - building the kernel with clang and lto breaks BTF generation because
> pahole doesn't seem to understand cross-cu references.

tl;dr response:

Yeah, so it may be the time to fix that, elfutils has interfaces for it,
and the tools that come with it handle cross-cu references, so we need
to study that and make pahole understand it.

- Arnaldo
 
> Can be reproduced with the following:
>     $ cat a.c
>     struct s;
> 
>     void f1() {}
> 
>     __attribute__((always_inline)) void f2(struct s *p)
>     {
>             if (p)
>                     f1();
>     }
>     $ cat b.c
>     struct s {
>             int x;
>     };
> 
>     void f2(struct s *p);
> 
>     int main()
>     {
>             struct s s = { 10 };
>             f2(&s);
>     }
>     $ clang -fuse-ld=lld -flto {a,b}.c -g
> 
>     $ pahole a.out
>     tag__recode_dwarf_type: couldn't find 0x3f type for 0x99 (inlined_subroutine)!
>     lexblock__recode_dwarf_types: couldn't find 0x3f type for 0x99 (inlined_subroutine)!
>     struct s {
>             int                        x;                    /*     0     4 */
> 
>             /* size: 4, cachelines: 1, members: 1 */
>             /* last cacheline: 4 bytes */
>     };
> 
> From what I can tell, pahole internally loops over each cu and resolves only
> local references, while the dwarf spec (table 2.3) states the following
> about 'reference':
> "Refers to one of the debugging information entries that describe the program.
> There are four types of reference. The first is an offset relative to the
> beginning of the compilation unit in which the reference occurs and must
> refer to an entry within that same compilation unit. The second type of
> reference is the offset of a debugging information entry in any compilation
> unit, including one different from the unit containing the reference. The
> third type of reference is an indirect reference to a type definition using
> an 8-byte signature for that type. The fourth type of reference is a reference
> from within the .debug_info section of the executable or shared object file to
> a debugging information entry in the .debug_info section of a supplementary
> object file."
> 
> In particular: "The second type of reference is the offset of a debugging
> information entry in any compilation unit, including one different from the
> unit containing the reference."
> 
> 
> So the question is: is it a (known) issue? Is it something that's ommitted
> on purpose? Or it's not implemented because lto is not (yet) widely used?
> 
> 
> Here is the dwarf:
> 
> $ readelf --debug-dump=info a.out
> Contents of the .debug_info section:
> 
>   Compilation Unit @ offset 0x0:
>    Length:        0x44 (32-bit)
>    Version:       4
>    Abbrev Offset: 0x0
>    Pointer Size:  8
>  <0><b>: Abbrev Number: 1 (DW_TAG_compile_unit)
>     <c>   DW_AT_producer    : (indirect string, offset: 0x11): clang version 10.0.0 (https://github.com/llvm/llvm-project.git 5fe4679cc9cfb4941b766db07bf3cd928075d204)
>     <10>   DW_AT_language    : 12	(ANSI C99)
>     <12>   DW_AT_name        : (indirect string, offset: 0x0): a.c
>     <16>   DW_AT_stmt_list   : 0x0
>     <1a>   DW_AT_comp_dir    : (indirect string, offset: 0x7a): /usr/local/google/home/sdf/tmp/lto
>     <1e>   DW_AT_low_pc      : 0x201730
>     <26>   DW_AT_high_pc     : 0x6
>  <1><2a>: Abbrev Number: 2 (DW_TAG_subprogram)
>     <2b>   DW_AT_low_pc      : 0x201730
>     <33>   DW_AT_high_pc     : 0x6
>     <37>   DW_AT_frame_base  : 1 byte block: 56 	(DW_OP_reg6 (rbp))
>     <39>   DW_AT_name        : (indirect string, offset: 0xa4): f1
>     <3d>   DW_AT_decl_file   : 1
>     <3e>   DW_AT_decl_line   : 3
>     <3f>   DW_AT_external    : 1
>  <1><3f>: Abbrev Number: 3 (DW_TAG_subprogram)
>     <40>   DW_AT_name        : (indirect string, offset: 0x4): f2
>     <44>   DW_AT_decl_file   : 1
>     <45>   DW_AT_decl_line   : 5
>     <46>   DW_AT_prototyped  : 1
>     <46>   DW_AT_external    : 1
>     <46>   DW_AT_inline      : 1	(inlined)
>  <1><47>: Abbrev Number: 0
>   Compilation Unit @ offset 0x48:
>    Length:        0x7f (32-bit)
>    Version:       4
>    Abbrev Offset: 0x0
>    Pointer Size:  8
>  <0><53>: Abbrev Number: 1 (DW_TAG_compile_unit)
>     <54>   DW_AT_producer    : (indirect string, offset: 0x11): clang version 10.0.0 (https://github.com/llvm/llvm-project.git 5fe4679cc9cfb4941b766db07bf3cd928075d204)
>     <58>   DW_AT_language    : 12	(ANSI C99)
>     <5a>   DW_AT_name        : (indirect string, offset: 0x7): b.c
>     <5e>   DW_AT_stmt_list   : 0x3a
>     <62>   DW_AT_comp_dir    : (indirect string, offset: 0x7a): /usr/local/google/home/sdf/tmp/lto
>     <66>   DW_AT_low_pc      : 0x201740
>     <6e>   DW_AT_high_pc     : 0x1f
>  <1><72>: Abbrev Number: 4 (DW_TAG_subprogram)
>     <73>   DW_AT_low_pc      : 0x201740
>     <7b>   DW_AT_high_pc     : 0x1f
>     <7f>   DW_AT_frame_base  : 1 byte block: 56 	(DW_OP_reg6 (rbp))
>     <81>   DW_AT_name        : (indirect string, offset: 0x9d): main
>     <85>   DW_AT_decl_file   : 1
>     <86>   DW_AT_decl_line   : 7
>     <87>   DW_AT_type        : <0xae>
>     <8b>   DW_AT_external    : 1
>  <2><8b>: Abbrev Number: 5 (DW_TAG_variable)
>     <8c>   DW_AT_location    : 2 byte block: 91 78 	(DW_OP_fbreg: -8)
>     <8f>   DW_AT_name        : (indirect string, offset: 0xb): s
>     <93>   DW_AT_decl_file   : 1
>     <94>   DW_AT_decl_line   : 9
>     <95>   DW_AT_type        : <0xb5>
>  <2><99>: Abbrev Number: 6 (DW_TAG_inlined_subroutine)
>     <9a>   DW_AT_abstract_origin: <0x3f>
>     <9e>   DW_AT_low_pc      : 0x201752
>     <a6>   DW_AT_high_pc     : 0x5
>     <aa>   DW_AT_call_file   : 1
>     <ab>   DW_AT_call_line   : 10
>     <ac>   DW_AT_call_column : 
>  <2><ad>: Abbrev Number: 0
>  <1><ae>: Abbrev Number: 7 (DW_TAG_base_type)
>     <af>   DW_AT_name        : (indirect string, offset: 0xd): int
>     <b3>   DW_AT_encoding    : 5	(signed)
>     <b4>   DW_AT_byte_size   : 4
>  <1><b5>: Abbrev Number: 8 (DW_TAG_structure_type)
>     <b6>   DW_AT_name        : (indirect string, offset: 0xb): s
>     <ba>   DW_AT_byte_size   : 4
>     <bb>   DW_AT_decl_file   : 1
>     <bc>   DW_AT_decl_line   : 1
>  <2><bd>: Abbrev Number: 9 (DW_TAG_member)
>     <be>   DW_AT_name        : (indirect string, offset: 0xa2): x
>     <c2>   DW_AT_type        : <0xae>
>     <c6>   DW_AT_decl_file   : 1
>     <c7>   DW_AT_decl_line   : 2
>     <c8>   DW_AT_data_member_location: 0
>  <2><c9>: Abbrev Number: 0
>  <1><ca>: Abbrev Number: 0

-- 

- Arnaldo
