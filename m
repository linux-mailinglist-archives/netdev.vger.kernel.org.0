Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6F3BB9C7B
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 07:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbfIUF6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 01:58:00 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37472 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730832AbfIUF6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 01:58:00 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7D43C613A3; Sat, 21 Sep 2019 05:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569045479;
        bh=w9bocaMK07bA6RbZkz/42TCpHEi65s53ZBFGd9Ga/MA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=EjF6wjlcCi5IIBGvVfhLMIYtKsLD8QyACEI7CArnRMTjIOhsvFCuvHawTZP7Widzd
         O7v366ssM4T6MdmeyU1cbq+I9jUMcEf3jIN5XUBjk9oImaJwn5DQrcSYSG3iBTYKg2
         TlG2y0/Tf9Ck0H66Aytla3mCFOXQKNoc1p1Q+BrY=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D14D961196;
        Sat, 21 Sep 2019 05:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569045478;
        bh=w9bocaMK07bA6RbZkz/42TCpHEi65s53ZBFGd9Ga/MA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=cWlzKUfGdItoaGOtH8EuZ3udfmzSkuqyGffjCXDX3PzstiKOhYxi1t8/GurajvtOw
         EU/z42Z2+cN0Iw+AsIlYmkRPZ9v+SH+KWFAuWnNMAtM656AxohYAeYl/XcEHSTz3u/
         gD+CUyjntL24iavhpUzavKyA2iL1QZjfo4ZYO/KM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D14D961196
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -net] zd1211rw: zd_usb: Use "%zu" to format size_t
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190919091532.24951-1-geert@linux-m68k.org>
References: <20190919091532.24951-1-geert@linux-m68k.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190921055759.7D43C613A3@smtp.codeaurora.org>
Date:   Sat, 21 Sep 2019 05:57:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On 32-bit:
> 
>     drivers/net/wireless/zydas/zd1211rw/zd_usb.c: In function ‘check_read_regs’:
>     drivers/net/wireless/zydas/zd1211rw/zd_def.h:18:25: warning: format ‘%ld’ expects argument of type ‘long int’, but argument 6 has type ‘size_t’ {aka ‘unsigned int’} [-Wformat=]
>       dev_printk(level, dev, "%s() " fmt, __func__, ##args)
> 			     ^~~~~~~
>     drivers/net/wireless/zydas/zd1211rw/zd_def.h:22:4: note: in expansion of macro ‘dev_printk_f’
> 	dev_printk_f(KERN_DEBUG, dev, fmt, ## args)
> 	^~~~~~~~~~~~
>     drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1635:3: note: in expansion of macro ‘dev_dbg_f’
>        dev_dbg_f(zd_usb_dev(usb),
>        ^~~~~~~~~
>     drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1636:51: note: format string is defined here
> 	 "error: actual length %d less than expected %ld\n",
> 						     ~~^
> 						     %d
> 
> Fixes: 84b0b66352470e64 ("zd1211rw: zd_usb: Use struct_size() helper")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Patch applied to wireless-drivers.git, thanks.

6355592e6b55 zd1211rw: zd_usb: Use "%zu" to format size_t

-- 
https://patchwork.kernel.org/patch/11151959/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

