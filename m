Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9623231F33
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 15:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgG2NWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 09:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbgG2NWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 09:22:50 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB0DC061794;
        Wed, 29 Jul 2020 06:22:49 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k4so11777109pld.12;
        Wed, 29 Jul 2020 06:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dZVkEmQto56AmO9M+KODR9+FXiNg4THi2B1DDl0qH74=;
        b=RWKI0VB42RHJGqcMkvesW4CLvXoeicTe46yk22J3WanwTaBUL4YtE8IKorU9KiKCNN
         vJyYbYPBBOokZboD5Trd8uT2uAFLLebivVHhMI9pdWYgfa/ZNExmBQZqLPT/MZhfm2eX
         8uRX8wOQqTPALEFZ1e2rCkbcL5HlR3XEGfJC+BVImp39oPZkbPhABKXht8aaOH93iTdB
         zxgjEKDcTx9bV2MXWc0cwek+1catpwycUsTk1AUN294kBGM46lfAgtCYe9ejGQYyVLR6
         ZvCx6XwQehErsZMxDhgDmCECRU4V/QF5yEC8ncrzKpweoK5P/HtJDd8MXfrMiTzUytpC
         Bm5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dZVkEmQto56AmO9M+KODR9+FXiNg4THi2B1DDl0qH74=;
        b=lg7Q2cVXIeM3tCEWyRfN3nj+5Y5z1LQCYCaR6k5GfRiSQ6ncb4BqnQCa045wmlfcM6
         wEtU14h37RJgcyAOn1xO2CfTmsn26tJ1TLpUruTYwFxkDPhsveM/+GG7lr+Rg42iekIa
         s18lNYSbB7plfL8LKVsSnSgsgEpBfZg4TemCEI7J2P8WfONLWVYr6Sh9610SjrsNNZqN
         VFUYKzYcc2fR7RyXSZbOaDiP37bADT+jXBqUrobwGmncJKK87t0Js6Ln7LY68dDHNX1W
         OuhxmENCGIGvRZslN27eCHjQhVHgvsjcqjKNa+0TXz/+f/VQqoJGG0c4Y4kAEQDAY0MW
         dC1A==
X-Gm-Message-State: AOAM533uC64hEO7t2ABLZN+4N7CUIy+YH19fywOMjKzYwNRznM2PXbGu
        FM+PTyu4MNmBUtflPUZtYmM=
X-Google-Smtp-Source: ABdhPJxn+Kx8ezIh3hRWCXBEAP2NSusIhx5YhewG4epzxBfAUTrNmzqbreB9W9/ynlMFo9omo1skgQ==
X-Received: by 2002:a17:902:b20a:: with SMTP id t10mr26885947plr.185.1596028969400;
        Wed, 29 Jul 2020 06:22:49 -0700 (PDT)
Received: from gmail.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id r25sm2244428pgv.88.2020.07.29.06.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 06:22:48 -0700 (PDT)
Date:   Wed, 29 Jul 2020 18:51:10 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Curtis <kevin.curtis@farsite.co.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v1] farsync: use generic power management
Message-ID: <20200729132110.GA605@gmail.com>
References: <20200729101730.GA215923@gmail.com>
 <20200729122954.GA1920458@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200729122954.GA1920458@bjorn-Precision-5520>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 07:29:54AM -0500, Bjorn Helgaas wrote:
> On Wed, Jul 29, 2020 at 03:47:30PM +0530, Vaibhav Gupta wrote:
> >
> > Agreed. Actually, as their presence only causes PCI core to call
> > pci_legacy_suspend/resume() for them, I thought that after removing
> > the binding from "struct pci_driver", this driver qualifies to be
> > grouped under genric framework, so used "use generic power
> > management" for the heading.
> > 
> > I should have written "remove legacy bindning".
> 
> This removed the *mention* of fst_driver.suspend and fst_driver.resume,
> which is important because we want to eventually remove those members
> completely from struct pci_driver.
> 
> But fst_driver.suspend and fst_driver.resume *exist* before and after
> this patch, and they're initialized to zero before and after this
> patch.
> 
> Since they were zero before, and they're still zero after this patch,
> the PCI core doesn't call pci_legacy_suspend/resume().  This patch
> doesn't change that at all.
>
Got it. Thanks :) 
> > But David has applied the patch, should I send a v2 or fix to update
> > message?
> 
> No, I don't think David updates patches after he's applied them.  But
> if the situation comes up again, you'll know how to describe it :)
> 
Thanks a lot. :D

Vaibhav Gupta
> Bjorn
