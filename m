Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7CB29DA16
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390215AbgJ1XOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:14:24 -0400
Received: from sym2.noone.org ([178.63.92.236]:41764 "EHLO sym2.noone.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390213AbgJ1XNJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 19:13:09 -0400
X-Greylist: delayed 4197 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Oct 2020 19:13:08 EDT
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4CLqZ551RYzvjc1; Wed, 28 Oct 2020 14:44:45 +0100 (CET)
Date:   Wed, 28 Oct 2020 14:44:45 +0100
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
Subject: Re: [PATCH 1/2] tools, bpftool: Avoid array index warnings.
Message-ID: <20201028134444.qt44rvpdekwr6m4w@distanz.ch>
References: <20201027233646.3434896-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027233646.3434896-1-irogers@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-28 at 00:36:45 +0100, Ian Rogers <irogers@google.com> wrote:
> The bpf_caps array is shorter without CAP_BPF, avoid out of bounds reads
> if this isn't defined. Working around this avoids -Wno-array-bounds with
> clang.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>

Reviewed-by: Tobias Klauser <tklauser@distanz.ch>
