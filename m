Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D877123F83
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 07:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfLRGXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 01:23:40 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35902 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfLRGXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 01:23:40 -0500
Received: by mail-pl1-f193.google.com with SMTP id d15so514205pll.3;
        Tue, 17 Dec 2019 22:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eX0CXj2vhPUQYL0CTUJZnkl/It94Ri0r5UvRz15Iqwc=;
        b=fUFvsrMDb2TYCG4L/sBjPW2tPnhsw2AHEvxM1rzONmUwYJi3APJtNU1iOijUghMVWa
         C+tPMPiZqGKedRqfeqLnkVAxDNT2c2ARUfi1klKljHi7puYkoxxOw284HgGcyWfW4nrd
         T+qIgAoB/QQ2u9WbEJ7M3gPA+YjTdfZVVcG/lCnhFiw8PF6ckoZ/caQNXDVDNcme6IbH
         Gl7Vk/n6EUkxxDyZOa9/RnvRYjiNZQiRsPY7Wj7eAaWpo67FQ3AtI3nn187RSuucRcwe
         hjTvCsN4q8hxTY+EZfzqRQiI3n8zt614sJ8eelWQHIMkifqfaKyRarU7xNEi/QwnMeOe
         bFEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eX0CXj2vhPUQYL0CTUJZnkl/It94Ri0r5UvRz15Iqwc=;
        b=V57qM48ZF/Yoy8fXNm5x6ffnubL6CHG9YdwOcVi//RkNdQV/lgCg0ads7AtVKxJhMH
         hoON9UAfHMm2r62z5lXcvsuKjbNnfsZd+CJ/XMTFCWZay1Lr8GkQ9UzgdeVXkxaVcd+6
         tgRQQczVp8WglMI9lkeKH1n9AcaWrwcdWWyGNx1muOABpbx6421iIwtdfz0YwSxy5XHs
         IsNbbik7X+jxMY/VZJ3Bv69aB6XzCt1+1zp9YuCNdyvSZIMDMtkRoTSpSPmscGBQ4yTj
         YbwZdJ/pw4XDhclGAU5aAO2ue49qLkYR7lQUMWkB2npmTebj/H2YZlfibt5U2pjr5Ve2
         wXzw==
X-Gm-Message-State: APjAAAUNkj75vd5bIJGVkoKL5V59BFrHI+63QExAyAlf+05W3vbhtMy0
        T0G4nRsu8LP/gwwHKGGPoD8=
X-Google-Smtp-Source: APXvYqw6b4/2U7BRQP1m5oZv2gcGd5wM3Bjcpyzjt33YRO7k5n5TP22Z0d2506fyVyMF9IFY+mgv6g==
X-Received: by 2002:a17:902:be10:: with SMTP id r16mr814986pls.169.1576650219475;
        Tue, 17 Dec 2019 22:23:39 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::9922])
        by smtp.gmail.com with ESMTPSA id y62sm1375490pfg.45.2019.12.17.22.23.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Dec 2019 22:23:38 -0800 (PST)
Date:   Tue, 17 Dec 2019 22:23:36 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 0/3] Skeleton improvements and documentation
Message-ID: <20191218062335.folwsve44bkawsvi@ast-mbp.dhcp.thefacebook.com>
References: <20191218052552.2915188-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218052552.2915188-1-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 09:25:49PM -0800, Andrii Nakryiko wrote:
> Simplify skeleton usage by embedding source BPF object file inside skeleton
> itself. This allows to keep skeleton and object file in sync at all times with
> no chance of confusion.
> 
> Also, add bpftool-gen.rst manpage, explaining concepts and ideas behind
> skeleton. In examples section it also includes a complete small BPF
> application utilizing skeleton, as a demonstration of API.
> 
> Patch #2 also removes BPF_EMBED_OBJ, as there is currently no use of it.
> 
> v2->v3:
> - (void) in no-args function (Alexei);
> - bpftool-gen.rst code block formatting fix (Alexei);
> - simplified xxx__create_skeleton to fill in obj and return error code;
> 
> v1->v2:
> - remove whitespace from empty lines in code blocks (Yonghong).

Applied. Thanks.

This bit:
+		  layout will be created. Currently supported ones are: .data,
+		  .bss, .rodata, and .extern structs/data sections. These
didn't render correctly in the man page for me.
Not sure whehther it's an issue in my setup or .rst is invalid.
Please take a look.
Overall new man page looks great.

