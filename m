Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7661C2C805A
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 09:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgK3Iyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 03:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727622AbgK3Iyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 03:54:39 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E800C061A04
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 00:53:58 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id f190so20618726wme.1
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 00:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=FRggsmJEJBZrm6qC3AK/y0P+qJy2/Ul08/OGbBmv0AM=;
        b=FYeBMEmssZ5UHXSFDpPVop6jg0svPPuiKlDGY6NcN3unsoPFwerGs4wBWvOWmBf2LH
         SvGNp3uGt7sDCf9Qehe2rBjegjEfEG0voxHq4TL48utsbQIn1T5vkOPnb9ojYxFQGYZL
         jPpJr6TSmxn0wYYQTQiMwqP8fl3uKwAFiRvSjb7e9FW5XUd5GcbWZ9HvvTkRZ/9tjDIL
         +M6csFZ64VrrhPX86p74qLTJ/TAFugOUq6CcxSrumlnY6X5QcTc0li6UP9pBlQphwyEN
         BUYa7lDmQff5J5iXTl2uO+DHO/NKBZEO8rSA2z4cXth4pz5sRe+9LteRh2o8xqOphJIl
         uZJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=FRggsmJEJBZrm6qC3AK/y0P+qJy2/Ul08/OGbBmv0AM=;
        b=KaW0MyNFSsy/cizzW4ViXz1ZoCXu4JkWKYtCCNR8hNQ7hAt+PQ6pGLzJLxVyzjoHpf
         bzu44YZFZ1F38qwn9x63nUndcJkZNv2mOL1Tq1+oPkMENSYS0FrPdaM2amWpnghBokUL
         3SFBAZm6sYp+zwyi/Uy4pMfJi7wt/4AvvehG+URcWx1YgK8wRnIXLVBo/aV0rtfm3HRp
         TvFP5ujvjYD7UmbZTzUmNGyUnHNYAPUjj+u5WxeHICdvorGmkbuMa6mzeEyYNrNUK0Nm
         AE/+d2AqhKC1N4x1uTi00rDbBahY7PziDJBXW85s6ZqJgu0LhwAhmPhVfHOk3zij5/tQ
         eniw==
X-Gm-Message-State: AOAM531GF83IMq7mmo6ZhjWjRKBY1ZauBVMyNE/hoX/3/F3fFWPkSMLk
        BFl6yh+1Z6cXNUpAU9ldXW6zZg==
X-Google-Smtp-Source: ABdhPJz+rgB4g/X5ZhcmmUS1RWJXefYKmauDXBpoHuszC+uYgFdGpS9GRw6ux1TE/Sykl8FRc5PNXw==
X-Received: by 2002:a1c:7f81:: with SMTP id a123mr22302995wmd.6.1606726436830;
        Mon, 30 Nov 2020 00:53:56 -0800 (PST)
Received: from dell ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id g78sm3347493wme.33.2020.11.30.00.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 00:53:56 -0800 (PST)
Date:   Mon, 30 Nov 2020 08:53:54 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Pkshih <pkshih@realtek.com>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH 17/17] realtek: rtw88: pci: Add prototypes for .probe,
 .remove and .shutdown
Message-ID: <20201130085354.GA4801@dell>
References: <20201126133152.3211309-1-lee.jones@linaro.org>
 <20201126133152.3211309-18-lee.jones@linaro.org>
 <1606448026.14483.4.camel@realtek.com>
 <20201127073816.GF2455276@dell>
 <1606465839.26661.2.camel@realtek.com>
 <20201127085705.GL2455276@dell>
 <0f8e7ac5a30a4f63a0a6aa923fa6d100@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f8e7ac5a30a4f63a0a6aa923fa6d100@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020, Pkshih wrote:

> 
> 
> > -----Original Message-----
> > From: Lee Jones [mailto:lee.jones@linaro.org]
> > Sent: Friday, November 27, 2020 4:57 PM
> > To: Pkshih
> > Cc: Tony Chuang; kvalo@codeaurora.org; linux-kernel@vger.kernel.org; linux-wireless@vger.kernel.org;
> > davem@davemloft.net; netdev@vger.kernel.org; kuba@kernel.org
> > Subject: Re: [PATCH 17/17] realtek: rtw88: pci: Add prototypes for .probe, .remove and .shutdown
> > 
> > On Fri, 27 Nov 2020, Pkshih wrote:
> > 
> > > On Fri, 2020-11-27 at 07:38 +0000, Lee Jones wrote:
> > > > On Fri, 27 Nov 2020, Pkshih wrote:
> > > >
> > > > >
> > > > > The subject prefix doesn't need 'realtek:'; use 'rtw88:'.
> > > > >
> > > > > On Thu, 2020-11-26 at 13:31 +0000, Lee Jones wrote:
> > > > > > Also strip out other duplicates from driver specific headers.
> > > > > >
> > > > > > Ensure 'main.h' is explicitly included in 'pci.h' since the latter
> > > > > > uses some defines from the former.  It avoids issues like:
> > > > > >
> > > > > >  from drivers/net/wireless/realtek/rtw88/rtw8822be.c:5:
> > > > > >  drivers/net/wireless/realtek/rtw88/pci.h:209:28: error:
> > > > > > ‘RTK_MAX_TX_QUEUE_NUM’ undeclared here (not in a function); did you mean
> > > > > > ‘RTK_MAX_RX_DESC_NUM’?
> > > > > >  209 | DECLARE_BITMAP(tx_queued, RTK_MAX_TX_QUEUE_NUM);
> > > > > >  | ^~~~~~~~~~~~~~~~~~~~
> > > > > >
> > > > > > Fixes the following W=1 kernel build warning(s):
> > > > > >
> > > > > >  drivers/net/wireless/realtek/rtw88/pci.c:1488:5: warning: no previous
> > > > > > prototype for ‘rtw_pci_probe’ [-Wmissing-prototypes]
> > > > > >  1488 | int rtw_pci_probe(struct pci_dev *pdev,
> > > > > >  | ^~~~~~~~~~~~~
> > > > > >  drivers/net/wireless/realtek/rtw88/pci.c:1568:6: warning: no previous
> > > > > > prototype for ‘rtw_pci_remove’ [-Wmissing-prototypes]
> > > > > >  1568 | void rtw_pci_remove(struct pci_dev *pdev)
> > > > > >  | ^~~~~~~~~~~~~~
> > > > > >  drivers/net/wireless/realtek/rtw88/pci.c:1590:6: warning: no previous
> > > > > > prototype for ‘rtw_pci_shutdown’ [-Wmissing-prototypes]
> > > > > >  1590 | void rtw_pci_shutdown(struct pci_dev *pdev)
> > > > > >  | ^~~~~~~~~~~~~~~~
> > > > > >
> > > > > > Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> > > > > > Cc: Kalle Valo <kvalo@codeaurora.org>
> > > > > > Cc: "David S. Miller" <davem@davemloft.net>
> > > > > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > > > > Cc: linux-wireless@vger.kernel.org
> > > > > > Cc: netdev@vger.kernel.org
> > > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > > > ---
> > > > > >  drivers/net/wireless/realtek/rtw88/pci.h       | 8 ++++++++
> > > > > >  drivers/net/wireless/realtek/rtw88/rtw8723de.c | 1 +
> > > > > >  drivers/net/wireless/realtek/rtw88/rtw8723de.h | 4 ----
> > > > > >  drivers/net/wireless/realtek/rtw88/rtw8821ce.c | 1 +
> > > > > >  drivers/net/wireless/realtek/rtw88/rtw8821ce.h | 4 ----
> > > > > >  drivers/net/wireless/realtek/rtw88/rtw8822be.c | 1 +
> > > > > >  drivers/net/wireless/realtek/rtw88/rtw8822be.h | 4 ----
> > > > > >  drivers/net/wireless/realtek/rtw88/rtw8822ce.c | 1 +
> > > > > >  drivers/net/wireless/realtek/rtw88/rtw8822ce.h | 4 ----
> > > > > >  9 files changed, 12 insertions(+), 16 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/net/wireless/realtek/rtw88/pci.h
> > > > > > b/drivers/net/wireless/realtek/rtw88/pci.h
> > > > > > index ca17aa9cf7dc7..cda56919a5f0f 100644
> > > > > > --- a/drivers/net/wireless/realtek/rtw88/pci.h
> > > > > > +++ b/drivers/net/wireless/realtek/rtw88/pci.h
> > > > > > @@ -5,6 +5,8 @@
> > > > > >  #ifndef __RTK_PCI_H_
> > > > > >  #define __RTK_PCI_H_
> > > > > >
> > > > > > +#include "main.h"
> > > > > > +
> > > > >
> > > > > Please #include "main.h" ahead of "pci.h" in each of rtw8xxxxe.c.
> > > >
> > > > You mean instead of in pci.h?
> > > >
> > > > Surely that's a hack.
> > > >
> > >
> > > I mean don't include main.h in pci.h, but include both of them in each
> > > of rtw8xxxxe.c.
> > >
> > > +#include "main.h"
> > > +#include "pci.h"
> > 
> > Yes, that's what I thought you meant.  I think that's a hack.
> > 
> > Source files shouldn't rely on the ordering of include files to
> > resolve dependencies.  In fact, a lot of subsystems require includes to
> > be in alphabetical order.
> > 
> > If a source or header file references a resource from a specific
> > header file (for instance here pci.h uses defines from main.h) then it
> > should explicitly include it.
> > 
> > Can you tell me the technical reason as to why these drivers are
> > handled differently please?
> > 
> 
> No technical reason, but that's our coding convention that needs some
> changes now.
> Could you point out where kernel or subsystem describes the rules?
> Or, point out the subsystem you mentioned above.
> Then, I can study and follow the rules for further development.

I don't think any subsystem explicitly lists this as a rule.  At least
not to my knowledge.  However you can see the many patches enforcing
the rule by doing something like:

 $ git log -p --all-match --grep=include --grep=alphabetical

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
