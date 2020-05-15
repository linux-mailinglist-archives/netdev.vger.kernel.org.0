Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86A61D588E
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 20:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgEOSBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 14:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726144AbgEOSBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 14:01:10 -0400
X-Greylist: delayed 387 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 May 2020 11:01:09 PDT
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA54C061A0C;
        Fri, 15 May 2020 11:01:09 -0700 (PDT)
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id D3C3572D;
        Fri, 15 May 2020 18:01:08 +0000 (UTC)
Date:   Fri, 15 May 2020 12:01:07 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
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
        Mike Rapoport <rppt@linux.ibm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 07/14] docs: add IRQ documentation at the core-api book
Message-ID: <20200515120107.459b63e8@lwn.net>
In-Reply-To: <2da7485c3718e1442e6b4c2dd66857b776e8899b.1588345503.git.mchehab+huawei@kernel.org>
References: <cover.1588345503.git.mchehab+huawei@kernel.org>
        <2da7485c3718e1442e6b4c2dd66857b776e8899b.1588345503.git.mchehab+huawei@kernel.org>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  1 May 2020 17:37:51 +0200
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> There are 4 IRQ documentation files under Documentation/*.txt.
> 
> Move them into a new directory (core-api/irq) and add a new
> index file for it.
> 
> While here, use a title markup for the Debugging section of the
> irq-domain.rst file.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Applied, thanks.

jon
