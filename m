Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4939880F90
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 02:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfHEAKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 20:10:11 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46052 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfHEAKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 20:10:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rrSge+Ou39enQtggjfw97C05S0AT6/LDL4+Td7GzXqo=; b=rt+Cwu4aN9dj8FNJ9j8WimAWw
        /voDELMBcEZqVCTnt2wiJwQ64mtmAQJg8N0vJhM/dY3yDbuqKn+k9RJzYn74HbRzV5PH800Ft20zq
        Zy+twK1dRca2Gzk7CeXQUz6f1IpIx+eOJOs4knnmEetbE7du8Xx1CY6c43zdjIipL+sZHvLsggODA
        jyh3K/IBGAR3BMcC0ypc0gBrIoYpI3GOso5ufIuocnV2Fjv2MPHDVkXFqWfFSjgjSqsmqZpEJore1
        U8f0o7WtMhhPY4BfuPGOedN7GMjkakTRfbjPQouq1fhSAC6TPpYc8Ho7OJrNyM+CyfJNk5rX8PRzc
        OspzJK32Q==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1huQZf-00055K-CZ; Mon, 05 Aug 2019 00:10:03 +0000
Date:   Sun, 4 Aug 2019 17:10:03 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Sheriff Esseson <sheriffesseson@gmail.com>
Cc:     skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
Subject: Re: [PATCH] Documentation: virt: Fix broken reference to virt tree's
 index
Message-ID: <20190805001003.GA30179@bombadil.infradead.org>
References: <20190804154635.GA18475@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190804154635.GA18475@localhost>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 04, 2019 at 04:46:35PM +0100, Sheriff Esseson wrote:
> Fix broken reference to virt/index.rst.
> 
> Sequel to: 2f5947dfcaec ("Documentation: move Documentation/virtual to
> Documentation/virt")

'Sequel to'?  Do you mean 'Fixes'?

> Reported-by: Sphinx

Reported-by is used for people.  See
Documentation/process/submitting-patches.rst section 13.

