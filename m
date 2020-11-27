Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEF72C6089
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 08:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392724AbgK0HiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 02:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729248AbgK0HiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 02:38:21 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E54C0613D1
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 23:38:21 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id z7so4528086wrn.3
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 23:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=xhN+Y7X7T3hr9xnUPO5BFNWxespYdkDTx9HcEbrzWhM=;
        b=beIM+9ahTQ1AqkPeAxt48OELKHMEyMjXVA/AEbv7IXZ6g0eF4UO9s/Bq6BFDgVUQcJ
         LR/f0Zi4OsTSRb75ADfSbIf8pQ4ays4k79cBiW4NCefehZDgvjO54K/l33M59Id1zkW9
         90vLD3k0V/rnVnKpl1GreKEN5gyVJh6U2b1vVCO38GFDmvAFgi4zIPhaNI8whsbzMEbo
         Wx5NQSWG7FR2LX0F7hnu2SE4Csc1yGGt2NurIYbRgSe3Bxq4+Vrz3QsBSZAm9Ag4TsYY
         TyX4//Hksp1MLJYBb7GHpSrDDj7RU2CgX+MnMK5tV3wZyAahvhf6p94P84zzRMnKYqIr
         le5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xhN+Y7X7T3hr9xnUPO5BFNWxespYdkDTx9HcEbrzWhM=;
        b=pvQShPB+jDepFa00VF0fDQzB7rkQ45MiUt47POvnafHfCJijmCwg6dDGL7nX3ZN9TN
         mQro6IRWlm7dmRRbVA+j2onE1+YizKB/DZ+Z88jg3PqlHV9salDeSeyrjyztPR6TC04d
         C7ywBNuMPTq6morFGgVsVzwnh/xo7BB+X8P3gjKGLrGKK4tQyPiJJQlJ3UOakiDxmBfK
         uYQNje/EKoIDNgZ7PPfEhh8AMizpDwrK39J77MQENt7LY7dEqlc9ORiDhdhmercq8+nP
         FfV7bNDxJKc+kJOembjT0P5aki7SVwsC8CfupuQOidnhTGh6NC2HkY/OCR9LOJIyThVV
         whwA==
X-Gm-Message-State: AOAM531wpyrkO8uHUWTQD4/HaPrDHPEouOpfu9M2DF687zCfPELTI6z3
        0zGzcah2juSogBzDpLo3Ej3Ms5Yk3zCtfVJY
X-Google-Smtp-Source: ABdhPJyZ8f2wwkDP5ycrhe9Hsl8TbK+clrvhynd75HH+ayMXnM9WrqZww3nzZbp3r6Zve8DPd4zS3A==
X-Received: by 2002:adf:ed11:: with SMTP id a17mr8760413wro.197.1606462699889;
        Thu, 26 Nov 2020 23:38:19 -0800 (PST)
Received: from dell ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id f18sm12912432wru.42.2020.11.26.23.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 23:38:19 -0800 (PST)
Date:   Fri, 27 Nov 2020 07:38:16 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Pkshih <pkshih@realtek.com>
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Tony Chuang <yhchuang@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 17/17] realtek: rtw88: pci: Add prototypes for .probe,
 .remove and .shutdown
Message-ID: <20201127073816.GF2455276@dell>
References: <20201126133152.3211309-1-lee.jones@linaro.org>
 <20201126133152.3211309-18-lee.jones@linaro.org>
 <1606448026.14483.4.camel@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1606448026.14483.4.camel@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020, Pkshih wrote:

> 
> The subject prefix doesn't need 'realtek:'; use 'rtw88:'.
> 
> On Thu, 2020-11-26 at 13:31 +0000, Lee Jones wrote:
> > Also strip out other duplicates from driver specific headers.
> > 
> > Ensure 'main.h' is explicitly included in 'pci.h' since the latter
> > uses some defines from the former.  It avoids issues like:
> > 
> >  from drivers/net/wireless/realtek/rtw88/rtw8822be.c:5:
> >  drivers/net/wireless/realtek/rtw88/pci.h:209:28: error:
> > ‘RTK_MAX_TX_QUEUE_NUM’ undeclared here (not in a function); did you mean
> > ‘RTK_MAX_RX_DESC_NUM’?
> >  209 | DECLARE_BITMAP(tx_queued, RTK_MAX_TX_QUEUE_NUM);
> >  | ^~~~~~~~~~~~~~~~~~~~
> > 
> > Fixes the following W=1 kernel build warning(s):
> > 
> >  drivers/net/wireless/realtek/rtw88/pci.c:1488:5: warning: no previous
> > prototype for ‘rtw_pci_probe’ [-Wmissing-prototypes]
> >  1488 | int rtw_pci_probe(struct pci_dev *pdev,
> >  | ^~~~~~~~~~~~~
> >  drivers/net/wireless/realtek/rtw88/pci.c:1568:6: warning: no previous
> > prototype for ‘rtw_pci_remove’ [-Wmissing-prototypes]
> >  1568 | void rtw_pci_remove(struct pci_dev *pdev)
> >  | ^~~~~~~~~~~~~~
> >  drivers/net/wireless/realtek/rtw88/pci.c:1590:6: warning: no previous
> > prototype for ‘rtw_pci_shutdown’ [-Wmissing-prototypes]
> >  1590 | void rtw_pci_shutdown(struct pci_dev *pdev)
> >  | ^~~~~~~~~~~~~~~~
> > 
> > Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/net/wireless/realtek/rtw88/pci.h       | 8 ++++++++
> >  drivers/net/wireless/realtek/rtw88/rtw8723de.c | 1 +
> >  drivers/net/wireless/realtek/rtw88/rtw8723de.h | 4 ----
> >  drivers/net/wireless/realtek/rtw88/rtw8821ce.c | 1 +
> >  drivers/net/wireless/realtek/rtw88/rtw8821ce.h | 4 ----
> >  drivers/net/wireless/realtek/rtw88/rtw8822be.c | 1 +
> >  drivers/net/wireless/realtek/rtw88/rtw8822be.h | 4 ----
> >  drivers/net/wireless/realtek/rtw88/rtw8822ce.c | 1 +
> >  drivers/net/wireless/realtek/rtw88/rtw8822ce.h | 4 ----
> >  9 files changed, 12 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/realtek/rtw88/pci.h
> > b/drivers/net/wireless/realtek/rtw88/pci.h
> > index ca17aa9cf7dc7..cda56919a5f0f 100644
> > --- a/drivers/net/wireless/realtek/rtw88/pci.h
> > +++ b/drivers/net/wireless/realtek/rtw88/pci.h
> > @@ -5,6 +5,8 @@
> >  #ifndef __RTK_PCI_H_
> >  #define __RTK_PCI_H_
> >  
> > +#include "main.h"
> > +
> 
> Please #include "main.h" ahead of "pci.h" in each of rtw8xxxxe.c.

You mean instead of in pci.h?

Surely that's a hack.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
