Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69AA211FC61
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 01:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfLPAwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 19:52:14 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40682 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfLPAwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 19:52:14 -0500
Received: by mail-pj1-f65.google.com with SMTP id s35so2212799pjb.7;
        Sun, 15 Dec 2019 16:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=CPLdbzRuwkKuuGWPgiRoDt4wSTfB7r9JqjQNWrhSKhE=;
        b=eMOoRLUaqH2pWvEN9I/rb255aJLRXbeeVNGuUUk5PHCWRoTf/XuvKVWvZDehIdEC0C
         H1h3NudDWRZ9vb/R+SucSuMOkdgazAIr5QMOZvST9UhZDf3VjeT7xjMEhch/DTCenuVE
         6X2giCSaJXd0Mjyha6bBshhQiNlQdGdv9NcRSIinkq0p6v83HNmf3JANDbid+Jo6ZT6E
         7ZVatDzyzVLcho9J1W2iR503B+hUujr3UT3hpOqCGJqPr0XEv8ycctnQ5OA7QJiuC2mf
         i7k1PxPBX887aarZMYaRdYEQdIHzWOgKvst/SdTuLaKjkFx254uUB0P9lUIHetQgMkUP
         eEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=CPLdbzRuwkKuuGWPgiRoDt4wSTfB7r9JqjQNWrhSKhE=;
        b=gndZP1jjjEbIFMKBj2wNHJlRC5uCuIhQ49ZWca/8kTvgSunBQF7gsFH7uqQTzyU/RP
         EXhp3f63bMEIpumTAx7eTXfr2FO9h1/jlgwM66ze+ouUeIUY7QPuvwq3EqB+8WDk1d/X
         fAEjVlVWy72Sxzeuyoh/VIj+cFwu3jUDZ8mfZ9BUsRPvF+3owXNfGCQxUSYwYt1U8trv
         5jIBrmqHwjqCstCayVKadjTqnhzpxTFgCUZzJu9kTQHMaYMy5JZS/z6z6R0z61BBUk/D
         o42NS0a1FY3N0a4HkdZIU3J9+qnwYc7ky0xPr16x/0S0rAlyuVrFwHn0l9XwIQNnJejz
         rhNA==
X-Gm-Message-State: APjAAAVcQLHeVyaQH1EUBQSXEioTnUD5eRkVYGC/umoX8b9g1x0NBCJD
        zZs2d2IzRP94BkjjNdUj+MhF2+Zt
X-Google-Smtp-Source: APXvYqw5z1Y7EVJXFkeidatp3R44gnye03wjuTTcC1K42WAF8+ixQFti0zvVulhc1/ksFRjaYVZ38w==
X-Received: by 2002:a17:902:321:: with SMTP id 30mr13036030pld.153.1576457533422;
        Sun, 15 Dec 2019 16:52:13 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::935c])
        by smtp.gmail.com with ESMTPSA id b22sm19590118pfd.63.2019.12.15.16.52.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Dec 2019 16:52:12 -0800 (PST)
Date:   Sun, 15 Dec 2019 16:52:10 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v4 bpf-next 0/4] Add libbpf-provided extern variables
 support
Message-ID: <20191216005209.jqb27p7tptauxn45@ast-mbp.dhcp.thefacebook.com>
References: <20191214014710.3449601-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191214014710.3449601-1-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 05:47:06PM -0800, Andrii Nakryiko wrote:
> It's often important for BPF program to know kernel version or some specific
> config values (e.g., CONFIG_HZ to convert jiffies to seconds) and change or
> adjust program logic based on their values. As of today, any such need has to
> be resolved by recompiling BPF program for specific kernel and kernel
> configuration. In practice this is usually achieved by using BCC and its
> embedded LLVM/Clang. With such set up #ifdef CONFIG_XXX and similar
> compile-time constructs allow to deal with kernel varieties.
> 
> With CO-RE (Compile Once – Run Everywhere) approach, this is not an option,
> unfortunately. All such logic variations have to be done as a normal
> C language constructs (i.e., if/else, variables, etc), not a preprocessor
> directives. This patch series add support for such advanced scenarios through
> C extern variables. These extern variables will be recognized by libbpf and
> supplied through extra .extern internal map, similarly to global data. This
> .extern map is read-only, which allows BPF verifier to track its content
> precisely as constants. That gives an opportunity to have pre-compiled BPF
> program, which can potentially use BPF functionality (e.g., BPF helpers) or
> kernel features (types, fields, etc), that are available only on a subset of
> targeted kernels, while effectively eleminating (through verifier's dead code
> detection) such unsupported functionality for other kernels (typically, older
> versions). Patch #3 explicitly tests a scenario of using unsupported BPF
> helper, to validate the approach.
> 
> This patch set heavily relies on BTF type information emitted by compiler for
> each extern variable declaration. Based on specific types, libbpf does strict
> checks of config data values correctness. See patch #1 for details.
> 
> Outline of the patch set:
> - patch #1 does a small clean up of internal map names contants;
> - patch #2 adds all of the libbpf internal machinery for externs support,
>   including setting up BTF information for .extern data section;
> - patch #3 adds support for .extern into BPF skeleton;
> - patch #4 adds externs selftests, as well as enhances test_skeleton.c test to
>   validate mmap()-ed .extern datasection functionality.

Applied. Thanks.

Looking at the tests that do mkstemp()+write() just to pass a file path
as .kconfig_path option into bpf_object_open_opts() it feels that file only
support for externs is unnecessary limiting. I think it will simplify
tests and will make the whole extern support more flexible if in addition to
kconfig_path bpf_object_open_opts() would support in-memory configuration.
