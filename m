Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE313A36E7
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 00:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhFJWRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 18:17:16 -0400
Received: from smtprelay0009.hostedemail.com ([216.40.44.9]:35646 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230155AbhFJWRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 18:17:15 -0400
Received: from omf16.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id F1676837F24C;
        Thu, 10 Jun 2021 22:15:16 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf16.hostedemail.com (Postfix) with ESMTPA id 2C534255104;
        Thu, 10 Jun 2021 22:15:04 +0000 (UTC)
Message-ID: <fa180c7093b946f2bd86d26d5875db28f80957de.camel@perches.com>
Subject: Re: [PATCH 1/7] checkpatch: check Makefiles and Kconfigs for SPDX
 tag
From:   Joe Perches <joe@perches.com>
To:     trix@redhat.com, robh+dt@kernel.org, tsbogend@alpha.franken.de,
        jic23@kernel.org, lars@metafoo.de, tomas.winkler@intel.com,
        arnd@arndb.de, gregkh@linuxfoundation.org, nbd@nbd.name,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, mcoquelin.stm32@gmail.com,
        alexandre.torgue@foss.st.com, apw@canonical.com,
        dwaipayanray1@gmail.com, lukas.bulwahn@gmail.com,
        chenhuacai@kernel.org, jiaxun.yang@flygoat.com,
        zhangqing@loongson.cn, jbhayana@google.com, sean.wang@mediatek.com,
        shayne.chen@mediatek.com, Soul.Huang@mediatek.com,
        shorne@gmail.com, gsomlo@gmail.com,
        pczarnecki@internships.antmicro.com, mholenko@antmicro.com,
        davidgow@google.com
Cc:     devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Date:   Thu, 10 Jun 2021 15:15:02 -0700
In-Reply-To: <20210610214438.3161140-3-trix@redhat.com>
References: <20210610214438.3161140-1-trix@redhat.com>
         <20210610214438.3161140-3-trix@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.56
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 2C534255104
X-Stat-Signature: hbs5edjb7ssp137oygbp83agndwobmm6
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX188Q7ACCxeE8e0t3mWcK2DFYS2XGLRcOCk=
X-HE-Tag: 1623363304-278120
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-06-10 at 14:44 -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Both Makefiles and Kconfigs should carry an SPDX tag.
> Something like
>  # SPDX-License-Identifier: GPL-2.0-only
> 
> Add a matcher to existing check
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Seems fine, thanks.

There's a Makefile with two tags that could be updated too.
---
 drivers/staging/media/atomisp/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/Makefile b/drivers/staging/media/atomisp/Makefile
index 51498b2e85b8f..cee03e31f420d 100644
--- a/drivers/staging/media/atomisp/Makefile
+++ b/drivers/staging/media/atomisp/Makefile
@@ -11,7 +11,6 @@ DEFINES += -DDEBUG
 
 atomisp = $(srctree)/drivers/staging/media/atomisp/
 
-# SPDX-License-Identifier: GPL-2.0
 atomisp-objs += \
 	pci/atomisp_acc.o \
 	pci/atomisp_cmd.o \


