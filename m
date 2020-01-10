Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABF21374A9
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 18:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgAJRWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 12:22:34 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:52203 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgAJRWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 12:22:34 -0500
Received: by mail-pj1-f68.google.com with SMTP id j11so1234982pjs.1
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 09:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yckjqKc1VEAvKfSqvXgIamYyBYNAJ2QcE8RIf1gfr2c=;
        b=iQc8sjaLIrmzCjFiLKLdTFwu1DRcd8IU3mBqSkziM3cckGM0gmMTP5S4yCut7siA12
         3Aeckq0HAYaDhGVT1YxbrsBGS539I0N5fZEeLPX2R9c1eWxrBLcGzk5CMFav/ZQ4CS94
         Jwuxt5wY6Mr38MsyN5u0av5LjUA6QW3S4z4md4tCJRDJG4ly6ojuvaX7LrDLJ0nePteL
         5janqzMyeKr5IS5U5zKIHb4j0+NMYfmhggwJofrXuDV6JqKGDR0vWr24EiwZJ+al3Hqb
         Omjg3cbPIea6n/zfGcNGCzfVroSHuURTsUkTiO9NTlhCbWar3Wyn0b3vZ8FJ5z6JCdHR
         RICQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yckjqKc1VEAvKfSqvXgIamYyBYNAJ2QcE8RIf1gfr2c=;
        b=pTmin3wpt2+NitdPn0AfkkDkVKkofrdEx5h/bqQYT5XLKuMBhETiSZhqspIUehMM0R
         4NHYwx/enxhfcY2kpNPOpsZKKshoMUoULI40MO0hP9z6hlaiZFQ8Tc83IPzFUNo2gKNv
         DqHG3IZ30EJOXw8/23LNY9cIusIPamGfaKESzHEriLdzef+JbSXdizMMZX1074WDK/jm
         0Z/+IrTolA6V62B7MUlGyjyHaMxpMqj1vdY/ycFsL12YoHu2vFkukv8XMywsCjTxSSWR
         AZ6J8VjoF9uyzctXM6A23E/Q6R1iJAwnDq6RPcCM7bkaUG3BeoDeuCW08FTlt4oAnmUb
         kyJw==
X-Gm-Message-State: APjAAAU1BM/oXjpkUUIVfV535JIepO4u/gVPgbwe6prQ3dV3nkMBaUcZ
        QCrtTp+IN+5BIpDg+r278q9vwQ==
X-Google-Smtp-Source: APXvYqzebaX+YihH+DE40pf0jaw1kDq34pShvo+SBxdoHmKa4rC+VrXhPYuc1/+y3BJxnp8lw9wWgg==
X-Received: by 2002:a17:90a:a88d:: with SMTP id h13mr5836107pjq.55.1578676953073;
        Fri, 10 Jan 2020 09:22:33 -0800 (PST)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id e19sm3361292pjr.10.2020.01.10.09.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 09:22:32 -0800 (PST)
Date:   Fri, 10 Jan 2020 09:22:31 -0800
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@fb.com, andriin@fb.com, morbo@google.com
Subject: Re: pahole and LTO
Message-ID: <20200110172231.GB1075235@mini-arch>
References: <20200110164410.GA1075235@mini-arch>
 <20200110164729.GB2598@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110164729.GB2598@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/10, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jan 10, 2020 at 08:44:10AM -0800, Stanislav Fomichev escreveu:
> > tl;dr - building the kernel with clang and lto breaks BTF generation because
> > pahole doesn't seem to understand cross-cu references.
> 
> tl;dr response:
> 
> Yeah, so it may be the time to fix that, elfutils has interfaces for it,
> and the tools that come with it handle cross-cu references, so we need
> to study that and make pahole understand it.
Sure, we can definitely help with the implementation unless someone
is already actively working on it. Just wanted to make sure that's
a known problem.

From my (limited) looking at pahole sources, it seems that building
and index on the first pass and doing a second pass to resolve
cross-cu references is relatively easy to implement. Am I missing
anything? (not a dwarf expert in any sense).

And where do the patches for pahole go? I don't see any pahole patches
in bpf/netdev mailing lists.

> - Arnaldo
>  
> > Can be reproduced with the following:
> >     $ cat a.c
> >     struct s;
> > 
> >     void f1() {}
> > 
> >     __attribute__((always_inline)) void f2(struct s *p)
> >     {
> >             if (p)
> >                     f1();
> >     }
> >     $ cat b.c
> >     struct s {
> >             int x;
> >     };
> > 
> >     void f2(struct s *p);
> > 
> >     int main()
> >     {
> >             struct s s = { 10 };
> >             f2(&s);
> >     }
> >     $ clang -fuse-ld=lld -flto {a,b}.c -g
> > 
> >     $ pahole a.out
> >     tag__recode_dwarf_type: couldn't find 0x3f type for 0x99 (inlined_subroutine)!
> >     lexblock__recode_dwarf_types: couldn't find 0x3f type for 0x99 (inlined_subroutine)!
> >     struct s {
> >             int                        x;                    /*     0     4 */
> > 
> >             /* size: 4, cachelines: 1, members: 1 */
> >             /* last cacheline: 4 bytes */
> >     };
> > 
> > From what I can tell, pahole internally loops over each cu and resolves only
> > local references, while the dwarf spec (table 2.3) states the following
> > about 'reference':
> > "Refers to one of the debugging information entries that describe the program.
> > There are four types of reference. The first is an offset relative to the
> > beginning of the compilation unit in which the reference occurs and must
> > refer to an entry within that same compilation unit. The second type of
> > reference is the offset of a debugging information entry in any compilation
> > unit, including one different from the unit containing the reference. The
> > third type of reference is an indirect reference to a type definition using
> > an 8-byte signature for that type. The fourth type of reference is a reference
> > from within the .debug_info section of the executable or shared object file to
> > a debugging information entry in the .debug_info section of a supplementary
> > object file."
> > 
> > In particular: "The second type of reference is the offset of a debugging
> > information entry in any compilation unit, including one different from the
> > unit containing the reference."
> > 
> > 
> > So the question is: is it a (known) issue? Is it something that's ommitted
> > on purpose? Or it's not implemented because lto is not (yet) widely used?
> > 
> > 
> > Here is the dwarf:
> > 
> > $ readelf --debug-dump=info a.out
> > Contents of the .debug_info section:
> > 
> >   Compilation Unit @ offset 0x0:
> >    Length:        0x44 (32-bit)
> >    Version:       4
> >    Abbrev Offset: 0x0
> >    Pointer Size:  8
> >  <0><b>: Abbrev Number: 1 (DW_TAG_compile_unit)
> >     <c>   DW_AT_producer    : (indirect string, offset: 0x11): clang version 10.0.0 (https://github.com/llvm/llvm-project.git 5fe4679cc9cfb4941b766db07bf3cd928075d204)
> >     <10>   DW_AT_language    : 12	(ANSI C99)
> >     <12>   DW_AT_name        : (indirect string, offset: 0x0): a.c
> >     <16>   DW_AT_stmt_list   : 0x0
> >     <1a>   DW_AT_comp_dir    : (indirect string, offset: 0x7a): /usr/local/google/home/sdf/tmp/lto
> >     <1e>   DW_AT_low_pc      : 0x201730
> >     <26>   DW_AT_high_pc     : 0x6
> >  <1><2a>: Abbrev Number: 2 (DW_TAG_subprogram)
> >     <2b>   DW_AT_low_pc      : 0x201730
> >     <33>   DW_AT_high_pc     : 0x6
> >     <37>   DW_AT_frame_base  : 1 byte block: 56 	(DW_OP_reg6 (rbp))
> >     <39>   DW_AT_name        : (indirect string, offset: 0xa4): f1
> >     <3d>   DW_AT_decl_file   : 1
> >     <3e>   DW_AT_decl_line   : 3
> >     <3f>   DW_AT_external    : 1
> >  <1><3f>: Abbrev Number: 3 (DW_TAG_subprogram)
> >     <40>   DW_AT_name        : (indirect string, offset: 0x4): f2
> >     <44>   DW_AT_decl_file   : 1
> >     <45>   DW_AT_decl_line   : 5
> >     <46>   DW_AT_prototyped  : 1
> >     <46>   DW_AT_external    : 1
> >     <46>   DW_AT_inline      : 1	(inlined)
> >  <1><47>: Abbrev Number: 0
> >   Compilation Unit @ offset 0x48:
> >    Length:        0x7f (32-bit)
> >    Version:       4
> >    Abbrev Offset: 0x0
> >    Pointer Size:  8
> >  <0><53>: Abbrev Number: 1 (DW_TAG_compile_unit)
> >     <54>   DW_AT_producer    : (indirect string, offset: 0x11): clang version 10.0.0 (https://github.com/llvm/llvm-project.git 5fe4679cc9cfb4941b766db07bf3cd928075d204)
> >     <58>   DW_AT_language    : 12	(ANSI C99)
> >     <5a>   DW_AT_name        : (indirect string, offset: 0x7): b.c
> >     <5e>   DW_AT_stmt_list   : 0x3a
> >     <62>   DW_AT_comp_dir    : (indirect string, offset: 0x7a): /usr/local/google/home/sdf/tmp/lto
> >     <66>   DW_AT_low_pc      : 0x201740
> >     <6e>   DW_AT_high_pc     : 0x1f
> >  <1><72>: Abbrev Number: 4 (DW_TAG_subprogram)
> >     <73>   DW_AT_low_pc      : 0x201740
> >     <7b>   DW_AT_high_pc     : 0x1f
> >     <7f>   DW_AT_frame_base  : 1 byte block: 56 	(DW_OP_reg6 (rbp))
> >     <81>   DW_AT_name        : (indirect string, offset: 0x9d): main
> >     <85>   DW_AT_decl_file   : 1
> >     <86>   DW_AT_decl_line   : 7
> >     <87>   DW_AT_type        : <0xae>
> >     <8b>   DW_AT_external    : 1
> >  <2><8b>: Abbrev Number: 5 (DW_TAG_variable)
> >     <8c>   DW_AT_location    : 2 byte block: 91 78 	(DW_OP_fbreg: -8)
> >     <8f>   DW_AT_name        : (indirect string, offset: 0xb): s
> >     <93>   DW_AT_decl_file   : 1
> >     <94>   DW_AT_decl_line   : 9
> >     <95>   DW_AT_type        : <0xb5>
> >  <2><99>: Abbrev Number: 6 (DW_TAG_inlined_subroutine)
> >     <9a>   DW_AT_abstract_origin: <0x3f>
> >     <9e>   DW_AT_low_pc      : 0x201752
> >     <a6>   DW_AT_high_pc     : 0x5
> >     <aa>   DW_AT_call_file   : 1
> >     <ab>   DW_AT_call_line   : 10
> >     <ac>   DW_AT_call_column : 
> >  <2><ad>: Abbrev Number: 0
> >  <1><ae>: Abbrev Number: 7 (DW_TAG_base_type)
> >     <af>   DW_AT_name        : (indirect string, offset: 0xd): int
> >     <b3>   DW_AT_encoding    : 5	(signed)
> >     <b4>   DW_AT_byte_size   : 4
> >  <1><b5>: Abbrev Number: 8 (DW_TAG_structure_type)
> >     <b6>   DW_AT_name        : (indirect string, offset: 0xb): s
> >     <ba>   DW_AT_byte_size   : 4
> >     <bb>   DW_AT_decl_file   : 1
> >     <bc>   DW_AT_decl_line   : 1
> >  <2><bd>: Abbrev Number: 9 (DW_TAG_member)
> >     <be>   DW_AT_name        : (indirect string, offset: 0xa2): x
> >     <c2>   DW_AT_type        : <0xae>
> >     <c6>   DW_AT_decl_file   : 1
> >     <c7>   DW_AT_decl_line   : 2
> >     <c8>   DW_AT_data_member_location: 0
> >  <2><c9>: Abbrev Number: 0
> >  <1><ca>: Abbrev Number: 0
> 
> -- 
> 
> - Arnaldo
