Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF471C2476
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 12:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgEBKQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 06:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbgEBKQu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 May 2020 06:16:50 -0400
Received: from coco.lan (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FC192137B;
        Sat,  2 May 2020 10:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588414609;
        bh=gRdDQ4UPhds1fw6akroO5DSN+kXJ/Jobhw+m6BxY8+c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0xTBaLfvRm2dyp/S59pNxBJoQqhHdn1nlD9DQiWfNSCqbETQzIzai5qoNA4v81yJd
         c6n0A2ipkMXhaYQJDgOSg6DzCGjO23LrWhQ7Yi4U6u/1Ipy1HF2RVYEY2D9lMgqu2O
         5QgApv55CZMZ2JCHyClrvvw1d3yXbX06r551M5hA=
Date:   Sat, 2 May 2020 12:16:41 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Harry Wei <harryxiyou@gmail.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Tejun Heo <tj@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 07/14] docs: add IRQ documentation at the core-api book
Message-ID: <20200502110438.1aad7d86@coco.lan>
In-Reply-To: <20200502074133.GC342687@linux.ibm.com>
References: <cover.1588345503.git.mchehab+huawei@kernel.org>
        <2da7485c3718e1442e6b4c2dd66857b776e8899b.1588345503.git.mchehab+huawei@kernel.org>
        <20200502074133.GC342687@linux.ibm.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sat, 2 May 2020 10:41:33 +0300
Mike Rapoport <rppt@linux.ibm.com> escreveu:

> Hello Mauro,
> 
> On Fri, May 01, 2020 at 05:37:51PM +0200, Mauro Carvalho Chehab wrote:
> > There are 4 IRQ documentation files under Documentation/*.txt.
> > 
> > Move them into a new directory (core-api/irq) and add a new
> > index file for it.  
> 
> Just curious, why IRQ docs got their subdirectory and DMA didn't :)

Heh, you got me... :-)

The rationale I used is that DMA fits nicely being close to other 
memory related documents.  As those currently don't have a subdir,
I opted to not create a DMA-specific dir. I admit that his is a
weak reason. I wouldn't mind placing them on a separate subdir,
if you think it would be worth.

Thanks,
Mauro
