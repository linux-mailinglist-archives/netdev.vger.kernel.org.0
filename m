Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D3329DA15
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390224AbgJ1XOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390214AbgJ1XNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:13:09 -0400
X-Greylist: delayed 4199 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Oct 2020 16:13:09 PDT
Received: from sym2.noone.org (sym2.noone.org [IPv6:2a01:4f8:120:4161::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748F2C0613CF;
        Wed, 28 Oct 2020 16:13:09 -0700 (PDT)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4CLqZX3lSvzvjcZ; Wed, 28 Oct 2020 14:45:07 +0100 (CET)
Date:   Wed, 28 Oct 2020 14:45:07 +0100
From:   Tobias Klauser <tklauser@distanz.ch>
To:     Ian Rogers <irogers@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Michal Rostecki <mrostecki@opensuse.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 2/2] tools, bpftool: Remove two unused variables.
Message-ID: <20201028134507.rccioix2vo57bqm7@distanz.ch>
References: <20201027233646.3434896-1-irogers@google.com>
 <20201027233646.3434896-2-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027233646.3434896-2-irogers@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-28 at 00:36:46 +0100, Ian Rogers <irogers@google.com> wrote:
> Avoid an unused variable warning.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>

Reviewed-by: Tobias Klauser <tklauser@distanz.ch>
