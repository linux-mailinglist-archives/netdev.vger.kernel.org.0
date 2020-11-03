Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22FB2A3F33
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 09:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgKCIo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 03:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbgKCIo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 03:44:57 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FB9C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 00:44:57 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c16so11924746wmd.2
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 00:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5/WOZHBmz3EBH3+eCAudlxs+DpqVNBs0AEAQtQF3C0g=;
        b=D/tNDQgcgZFGx9ufo0kyX0caMAMLaJEDmZZar9aTdI+nTB9DiJS3uimqhClmlkv92N
         PTN2NgpbaMKPWw/6zwTa4o6wsGYC/QudW8o05fr9c9y3HXkac7wJD+cThiHUxfFGrXIO
         lUhf0X7R1ls37PqrduWqkrZSUYXq18N4k98mN4fSuvA1l9NqRyBlHyIX4w7jsaUPNOVi
         gzgTPFzgW9XrKjyCg5rrx4StYlo9blEfSZJUyBQOCS1jNCUaRhhK0oqP9o/MmzZUToJ1
         7v/Q5bkbJnDFrkGirDBHFrCtnRwV/tMNjQbYRD6NwJtOgvcw2Exk4tZ6mORjpINR9Os8
         IJmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5/WOZHBmz3EBH3+eCAudlxs+DpqVNBs0AEAQtQF3C0g=;
        b=E+0o1od8YjnwgmIJD026kWyyy8VkFslimT8iwvKZ++zQ+k4GiryiVvVliYqwpNYsQq
         lfutv3snyXJ2DAvI7jByShJb8BCJnHWBsmPpJkBMqClVVFw8SEyOvITJaJQdbokBLdkU
         oycAlTYqDdpqsvoPC8W4nW46S2cGmcYmX7jNt5l5ysQJizyVyhMvrgvoZVMS3U/wDGxW
         NxrhwBfjheeWTYzCYh6AcVT9uqIGWY5Tqv+OE2xFG7GVFRRwmHyQ39QFoSA38QsQQnn5
         7YqoRGCGiP/hACEJBEuQE1LUFX+ecbCxeRO1n6coXazymed1vizyYRyvJrILpcLkXJeC
         zePg==
X-Gm-Message-State: AOAM53227FJaebwMemrsg9sSDb1SVGslORmBgPtesG68Jc8SAebVKIXW
        CnFrFujN5VlaMqozZBKl+SqlCw==
X-Google-Smtp-Source: ABdhPJz8fx8VQuhvfzqJtAKCb4y9SD7Xt0brjcuk8KmNJ2RedYCauy94oAfQvnsKQQSqF2yMZLA6tA==
X-Received: by 2002:a7b:c4c3:: with SMTP id g3mr2313652wmk.65.1604393096021;
        Tue, 03 Nov 2020 00:44:56 -0800 (PST)
Received: from dell ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id c17sm2084243wml.14.2020.11.03.00.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 00:44:55 -0800 (PST)
Date:   Tue, 3 Nov 2020 08:44:53 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>
Subject: Re: [PATCH 41/41] realtek: rtw88: pci: Add prototypes for .probe,
 .remove and .shutdown
Message-ID: <20201103084453.GJ4488@dell>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
 <20201102112410.1049272-42-lee.jones@linaro.org>
 <CA+ASDXOobW1_qL5SCGS86aoGvhKDMoBzjxbAwn+QjHfkqZhukw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+ASDXOobW1_qL5SCGS86aoGvhKDMoBzjxbAwn+QjHfkqZhukw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 02 Nov 2020, Brian Norris wrote:

> On Mon, Nov 2, 2020 at 3:25 AM Lee Jones <lee.jones@linaro.org> wrote:
> > --- a/drivers/net/wireless/realtek/rtw88/pci.h
> > +++ b/drivers/net/wireless/realtek/rtw88/pci.h
> > @@ -212,6 +212,10 @@ struct rtw_pci {
> >         void __iomem *mmap;
> >  };
> >
> > +int rtw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id);
> > +void rtw_pci_remove(struct pci_dev *pdev);
> > +void rtw_pci_shutdown(struct pci_dev *pdev);
> > +
> >
> 
> These definitions are already in 4 other header files:
> 
> drivers/net/wireless/realtek/rtw88/rtw8723de.h
> drivers/net/wireless/realtek/rtw88/rtw8821ce.h
> drivers/net/wireless/realtek/rtw88/rtw8822be.h
> drivers/net/wireless/realtek/rtw88/rtw8822ce.h
> 
> Seems like you should be moving them, not just adding yet another duplicate.

I followed the current convention.

Happy to optimise if that's what is required.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
