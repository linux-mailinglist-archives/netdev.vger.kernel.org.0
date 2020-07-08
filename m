Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710DA218C9E
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 18:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730588AbgGHQLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 12:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730093AbgGHQLB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 12:11:01 -0400
Received: from linux-8ccs.fritz.box (p57a23121.dip0.t-ipconnect.de [87.162.49.33])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 562EB2067D;
        Wed,  8 Jul 2020 16:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594224660;
        bh=n3F3bcX2Vci1bakFZU/eICyLnnE7X851ZV5TuN+qGqk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qwr4w1GhLORsHNOTadWKjxr/+KY5sGtD9V/DyZUDtdD+u5cE9FDlC92dZV2DHGD4d
         inc0O+LwJL1lPNpljIww0uV07+QfktCd23Johh5BjrBE0zyU/VjscdMbX/vVE9qUVy
         tG/e+qToIXaQHmyIMQOtfV1ISiBh6i/qbbnSrIHI=
Date:   Wed, 8 Jul 2020 18:10:52 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Dominik Czarnota <dominik.czarnota@trailofbits.com>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Will Deacon <will@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matteo Croce <mcroce@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] module: Refactor section attr into bin attribute
Message-ID: <20200708161049.GA5609@linux-8ccs.fritz.box>
References: <20200702232638.2946421-1-keescook@chromium.org>
 <20200702232638.2946421-3-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200702232638.2946421-3-keescook@chromium.org>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+++ Kees Cook [02/07/20 16:26 -0700]:
>In order to gain access to the open file's f_cred for kallsym visibility
>permission checks, refactor the module section attributes to use the
>bin_attribute instead of attribute interface. Additionally removes the
>redundant "name" struct member.
>
>Cc: stable@vger.kernel.org
>Signed-off-by: Kees Cook <keescook@chromium.org>

Hi Kees,

This looks good to me:

Tested-by: Jessica Yu <jeyu@kernel.org>
Acked-by: Jessica Yu <jeyu@kernel.org>

Thanks!
