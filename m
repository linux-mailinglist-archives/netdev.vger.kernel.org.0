Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7758F722E1
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 01:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfGWXRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 19:17:20 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42566 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfGWXRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 19:17:20 -0400
Received: by mail-io1-f68.google.com with SMTP id e20so55162477iob.9;
        Tue, 23 Jul 2019 16:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EREJRt7jj49C0rCcr5qS3pbZo7kgePF2Gv4OWisb4Ck=;
        b=hEawseaKHXb8tX1P7iXvi+EekI5fvqzo9CjFSlo+KONp03bCmEzukex+gesX7PBkX+
         DtaSmMdIjbxj93e6Rr8OSwFHOSH6xByvnphjQSNP5G9SHdFgky+0pCPymTa8Xx83JuaS
         XjcpcjqUpabkua+14OxhBg12CugEP0Cn4gS65nnyJ/4GGuZtTKHGGrp3ZzfvlRH84084
         eiB31zYb/uhxLg6lWJgyPTQyR5o+PtgEbD1HHJ6ZKb1JCGfa2ZYBFg2lfV4VYR4s2kCs
         FF0OmK8hOU9oyrzmM5Y5zngF+sVBdtyJ79KKQOwxC1rA/PcqcEk/2bhxAKyyjv+s3nUI
         vgAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EREJRt7jj49C0rCcr5qS3pbZo7kgePF2Gv4OWisb4Ck=;
        b=qrarTHdfk05MF5OumVkxX1CCe77RD4qELZ1wayz/1HdxLQO2+L6K6MlqcnoVCeLzHN
         nG7YKeE8tPtFi1qvxELXM2SshSKW2d4+xlsiuHmQvXh1f+Cwd499W0+4vmaZVMFZX+FO
         lzxwh4qZ8ZW67UfiAaHljdTKwmtl8fSkRl6stE/6WMQHOSp6d80d2+q3xOYK9jXoJPoN
         dFYiDflxQGZbkCmURWYNp/v3Xao2+izvtqaw4lbulyr9sZbXOFIRHaj7MdL579lByfGr
         6oMyXEPyXSKnPYd1dppyAHCzH0rkdsIbEgfZtx+WIeGVATK37R6rK12PYjzV3lU9U6vh
         WStQ==
X-Gm-Message-State: APjAAAVSCaRaI4UpvOAsd4QQQ+LkVJynbLHxCZ0pP8bmf/k1ksIoCxgK
        UDi6gZYffvl99qgq4p+H0iU=
X-Google-Smtp-Source: APXvYqyuCGs6UKeGsAre7PLltaWi/oMLM4yfYi/ennnGMQwTepvb8u+x6KbwnWAD7OKXXwNG/xUwpg==
X-Received: by 2002:a6b:da01:: with SMTP id x1mr48189572iob.216.1563923839654;
        Tue, 23 Jul 2019 16:17:19 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id y5sm46436289ioc.86.2019.07.23.16.17.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 16:17:18 -0700 (PDT)
Date:   Tue, 23 Jul 2019 17:17:17 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     bjorn@helgaas.com
Cc:     iyappan@os.amperecomputing.com, keyur@os.amperecomputing.com,
        quan@os.amperecomputing.com, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v2] drivers: net: xgene: Remove acpi_has_method() calls
Message-ID: <20190723231717.GA16776@JATN>
References: <20190722030401.69563-1-skunberg.kelsey@gmail.com>
 <20190723185811.8548-1-skunberg.kelsey@gmail.com>
 <CABhMZUVAcJwJpN8BKZTTU7jUW6881KdBtoYs_3kSn+tDtOVqNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABhMZUVAcJwJpN8BKZTTU7jUW6881KdBtoYs_3kSn+tDtOVqNw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 05:56:04PM -0500, Bjorn Helgaas wrote:
> On Tue, Jul 23, 2019 at 1:59 PM Kelsey Skunberg
> <skunberg.kelsey@gmail.com> wrote:
> >
> > acpi_evaluate_object will already return an error if the needed method
> > does not exist. Remove unnecessary acpi_has_method() calls and check the
> > returned acpi_status for failure instead.
> 
> > diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c b/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
> > index 6453fc2ebb1f..5d637b46b2bf 100644
> > --- a/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
> > +++ b/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
> > @@ -437,6 +437,7 @@ static void xgene_sgmac_tx_disable(struct xgene_enet_pdata *p)
> >  static int xgene_enet_reset(struct xgene_enet_pdata *p)
> >  {
> >         struct device *dev = &p->pdev->dev;
> > +       acpi_status status;
> >
> >         if (!xgene_ring_mgr_init(p))
> >                 return -ENODEV;
> > @@ -460,14 +461,13 @@ static int xgene_enet_reset(struct xgene_enet_pdata *p)
> >                 }
> >         } else {
> >  #ifdef CONFIG_ACPI
> > -               if (acpi_has_method(ACPI_HANDLE(&p->pdev->dev), "_RST"))
> > -                       acpi_evaluate_object(ACPI_HANDLE(&p->pdev->dev),
> > -                                            "_RST", NULL, NULL);
> > -               else if (acpi_has_method(ACPI_HANDLE(&p->pdev->dev), "_INI"))
> > +               status = acpi_evaluate_object(ACPI_HANDLE(&p->pdev->dev),
> > +                                             "_RST", NULL, NULL);
> > +               if (ACPI_FAILURE(status)) {
> >                         acpi_evaluate_object(ACPI_HANDLE(&p->pdev->dev),
> >                                              "_INI", NULL, NULL);
> > +               }
> >  #endif
> > -       }
> 
> Oops, I don't think you intended to remove that brace.
> 
> If you haven't found it already, CONFIG_COMPILE_TEST is useful for
> building things that wouldn't normally be buildable on your arch.

Thank you very much for catching that. I did not know about
CONFIG_COMPILE_TEST yet and that will be very useful. It's clear why my
build test wasn't coming up with the same errors now. I know for future
patches now and will certainly get this one fixed.
Thank you again.

-Kelsey
