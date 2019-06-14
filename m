Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 767EA46A12
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbfFNUgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:36:43 -0400
Received: from ms.lwn.net ([45.79.88.28]:54174 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbfFNUgn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 16:36:43 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 0E0D8128A;
        Fri, 14 Jun 2019 20:36:42 +0000 (UTC)
Date:   Fri, 14 Jun 2019 14:36:40 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v4 00/28] Convert files to ReST - part 1
Message-ID: <20190614143640.40ee353a@lwn.net>
In-Reply-To: <cover.1560361364.git.mchehab+samsung@kernel.org>
References: <cover.1560361364.git.mchehab+samsung@kernel.org>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jun 2019 14:52:36 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:

> This is mostly a rebase of the /33 series v3 I sent, on the top of the latest
> linux-next  (next-20190612).
> 
> Changes from v3:
> 
> - dropped cpufreq conversion - documents are too outdated;
> - infiniband patch is not here anymore - as it should be merged via RDMA;
> - s390 patches were already merged;
> - Dropped Geert as Maintainer from fb/framebuffer.rst, as per his request;
> - Did a minor editorial change at popwerpc/cxl.rst per Andrew Donellan
>   request;
> - Added acks/reviews;
> - trivial rebase fixups.

So I had to pull docs-next forward to -rc4, but then I was able to apply
this set except for parts 5, 6, 14, 18, and 19.  Some progress made, but
this is somewhat painful work...

jon
