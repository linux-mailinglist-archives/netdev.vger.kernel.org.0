Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7718B9214D
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 12:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfHSKcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 06:32:51 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46775 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbfHSKcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 06:32:51 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hzewi-0001AV-VE; Mon, 19 Aug 2019 12:31:29 +0200
Date:   Mon, 19 Aug 2019 12:31:27 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Nick Desaulniers <ndesaulniers@google.com>
cc:     akpm@linux-foundation.org, sedat.dilek@gmail.com,
        jpoimboe@redhat.com, yhs@fb.com, miguel.ojeda.sandonis@gmail.com,
        clang-built-linux@googlegroups.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Armijn Hemel <armijn@tjaldur.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Juergen Gross <jgross@suse.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Enrico Weigelt <info@metux.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Hannes Reinecke <hare@suse.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Pu Wen <puwen@hygon.cn>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 11/16] x86: prefer __section from compiler_attributes.h
In-Reply-To: <20190812215052.71840-11-ndesaulniers@google.com>
Message-ID: <alpine.DEB.2.21.1908191229080.1923@nanos.tec.linutronix.de>
References: <20190812215052.71840-1-ndesaulniers@google.com> <20190812215052.71840-11-ndesaulniers@google.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nick,

On Mon, 12 Aug 2019, Nick Desaulniers wrote:

-ECHANGELOG_EMPTY

While I think I know the reason for this change, it's still usefull to have
some explanaiton of WHY this is preferred in the change log.

Thanks,

	tglx
