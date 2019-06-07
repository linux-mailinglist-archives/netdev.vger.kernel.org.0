Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F13D393B3
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 19:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730728AbfFGRzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 13:55:23 -0400
Received: from ms.lwn.net ([45.79.88.28]:57982 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727391AbfFGRzX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 13:55:23 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 6B1AB737;
        Fri,  7 Jun 2019 17:55:22 +0000 (UTC)
Date:   Fri, 7 Jun 2019 11:55:21 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2 00/22] Some documentation fixes
Message-ID: <20190607115521.6bf39030@lwn.net>
In-Reply-To: <cover.1559656538.git.mchehab+samsung@kernel.org>
References: <cover.1559656538.git.mchehab+samsung@kernel.org>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  4 Jun 2019 11:17:34 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:

> Fix several warnings and broken links.
> 
> This series was generated against linux-next, but was rebased to be applied at
> docs-next. It should apply cleanly on either tree.
> 
> There's a git tree with all of them applied on the top of docs/docs-next
> at:
> 
> https://git.linuxtv.org/mchehab/experimental.git/log/?h=fix_doc_links_v2

So I'll admit I've kind of lost track of which of these are applied, which
have comments, etc.  When you feel things have settled, can you get me an
updated set and I'll get them applied?

Thanks,

jon
