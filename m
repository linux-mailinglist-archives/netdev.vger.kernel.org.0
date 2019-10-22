Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7BCE0CAC
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 21:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732615AbfJVTix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 15:38:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:45430 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730186AbfJVTiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 15:38:52 -0400
Received: from 13.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.13] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iMzzW-0005DT-SY; Tue, 22 Oct 2019 21:38:50 +0200
Date:   Tue, 22 Oct 2019 21:38:50 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next] libbpf: make DECLARE_LIBBPF_OPTS macro
 strictly a variable declaration
Message-ID: <20191022193850.GC31343@pc-66.home>
References: <20191022172100.3281465-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022172100.3281465-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25610/Tue Oct 22 10:54:26 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 10:21:00AM -0700, Andrii Nakryiko wrote:
> LIBBPF_OPTS is implemented as a mix of field declaration and memset
> + assignment. This makes it neither variable declaration nor purely
> statements, which is a problem, because you can't mix it with either
> other variable declarations nor other function statements, because C90
> compiler mode emits warning on mixing all that together.
> 
> This patch changes LIBBPF_OPTS into a strictly declaration of variable
> and solves this problem, as can be seen in case of bpftool, which
> previously would emit compiler warning, if done this way (LIBBPF_OPTS as
> part of function variables declaration block).
> 
> This patch also renames LIBBPF_OPTS into DECLARE_LIBBPF_OPTS to follow
> kernel convention for similar macros more closely.
> 
> v1->v2:
> - rename LIBBPF_OPTS into DECLARE_LIBBPF_OPTS (Jakub Sitnicki).
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
