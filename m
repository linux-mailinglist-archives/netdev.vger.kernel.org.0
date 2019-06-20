Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E164C611
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 06:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfFTESF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 00:18:05 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43682 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfFTESF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 00:18:05 -0400
Received: by mail-pl1-f193.google.com with SMTP id cl9so812264plb.10;
        Wed, 19 Jun 2019 21:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uIKAfcrE5wvjrEwo/ngslnyTESd49q8bNyvlhkJI9LI=;
        b=ErUXyLwyQCwKHSZAS0VjZD5xhd+A30Wo/fHnePHtZPsaNEXtoCe9J+HCHYIhptN2Wd
         yIUfiNzk6TMpAceTKhtA06BmCDi4BTUUBXREnFSUjK2GI0oQ+IF+VxupF2leJe9J0VVZ
         3B7DPrcHOhpMIaclC/k79dQJTCpIccHOH1kV8mF4oCPmewjD44P196Od+1BiStleTEie
         quTOZRg/BMk1sEIr9p+W0rF81P/DGzdXhTbpezwFswLjFLoruDKKyaONXkCvTZWmINT3
         YDfvTmD2FIwGQRWNYjod2YaWg9XaIgBFpXEZSDdxEKZdTheN5g/Zl+1WOceMbPHI8D98
         fcJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uIKAfcrE5wvjrEwo/ngslnyTESd49q8bNyvlhkJI9LI=;
        b=Ya23Z9LLO2eKompdh3Duk0dFKrBBRakWC18Gqcz7NDGNdTROICWxY7IlbTb0fErmke
         D8iz7uDu32jzdz2bx/HaZe54K9W/t8S07lkmSRuhXHWwxruX9M/lmdes+B7vn7+NkIiI
         zQLg2VoqU2zvrub0pS88hFhizR0roOI9uJR4j2bx+N0MLDddochfZ67JOiy3fsqnO4Cv
         8FtULbcsuEvBgvBWletxghYdXcAGhkds11unrjVYQ+KbmF0wwyr7N/CEGSBMnNqaKqgl
         TGuc6VVf+bKPEUSGl0Fzn3hj2xWyUt9nRwbJHp14JCGEJx9ms1Isl7aqaNNcZ7/r0eTi
         dnhw==
X-Gm-Message-State: APjAAAU86vP2Ohks5r0PFGX5nSBG7BSCqTsrH2+z87CZWEglNQ2Hw9Y4
        u3INlGLeMEFIyge+QgIqrnc=
X-Google-Smtp-Source: APXvYqwCMcfwt8z1yRvGP466jwPF7+Yv6bmJDIB66iCMbDJqxjXXP+UziDsPgqIau2/Dttcr1/5rXw==
X-Received: by 2002:a17:902:7295:: with SMTP id d21mr104244303pll.299.1561004284069;
        Wed, 19 Jun 2019 21:18:04 -0700 (PDT)
Received: from arch ([2405:204:3084:2253:a5c0:c41b:d911:976b])
        by smtp.gmail.com with ESMTPSA id y5sm18704348pgv.12.2019.06.19.21.17.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 21:18:03 -0700 (PDT)
Date:   Thu, 20 Jun 2019 09:47:46 +0530
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] net: fddi: skfp: remove generic PCI defines from skfbi.h
Message-ID: <20190620041744.GA6343@arch>
References: <20190619174643.21456-1-puranjay12@gmail.com>
 <CAErSpo7-AjCAc8pGpTftd7U-W2kjp1jfbPzk3SOa=Bg5-d6W5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7-AjCAc8pGpTftd7U-W2kjp1jfbPzk3SOa=Bg5-d6W5w@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 02:10:22PM -0500, Bjorn Helgaas wrote:
> On Wed, Jun 19, 2019 at 12:48 PM Puranjay Mohan <puranjay12@gmail.com> wrote:
> >
> > skfbi.h defines its own copies of PCI_COMMAND, PCI_STATUS, etc.
> > remove them in favor of the generic definitions in
> > include/uapi/linux/pci_regs.h
> 
> 1) Since you're sending several related patches, send them as a
> "series" with a cover letter, e.g.,
> 
>   [PATCH v2 0/2] Use PCI generic definitions instead of private duplicates
>   [PATCH v2 1/2] Include generic PCI definitions
>   [PATCH v2 2/2] Remove unused private PCI definitions
> 
> Patches 1/2 and 2/2 should be replies to the 0/2 cover letter.  "git
> send-email" will do this for you if you figure out the right options.
> 
> 2) Make sure all your subject lines match.  One started with "Include"
> and the other with "remove".  They should both be capitalized.
> 
> 3) Start sentences with a capital letter, i.e., "Remove them" above.
> 
> 4) This commit log needs to explicitly say that you're removing
> *unused* symbols.  Since they're unused, you don't even need to refer
> to pci_regs.h.
> 
> 5) "git grep PCI_ drivers/net/fddi/skfp" says there are many more
> unused PCI symbols than just the ones below.  I would just remove them
> all at once.
> 
> 6) Obviously you should compile this to make sure it builds.  It must
> build cleanly after every patch, not just at the end.  I assume you've
> done this already.
>
Yes, I build the driver after every change and I do it again before
sending the patch to be sure that it works.
> 7) Please cc: linux-pci@vger.kernel.org since you're making PCI-related changes.
> 
sure.
> > Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
> > ---
> >  drivers/net/fddi/skfp/h/skfbi.h | 23 -----------------------
> >  1 file changed, 23 deletions(-)
> >
> > diff --git a/drivers/net/fddi/skfp/h/skfbi.h b/drivers/net/fddi/skfp/h/skfbi.h
> > index 89557457b352..ed144a8e78d1 100644
> > --- a/drivers/net/fddi/skfp/h/skfbi.h
> > +++ b/drivers/net/fddi/skfp/h/skfbi.h
> > @@ -27,29 +27,6 @@
> >  /*
> >   * Configuration Space header
> >   */
> > -#define        PCI_VENDOR_ID   0x00    /* 16 bit       Vendor ID */
> > -#define        PCI_DEVICE_ID   0x02    /* 16 bit       Device ID */
> > -#define        PCI_COMMAND     0x04    /* 16 bit       Command */
> > -#define        PCI_STATUS      0x06    /* 16 bit       Status */
> > -#define        PCI_REV_ID      0x08    /*  8 bit       Revision ID */
> > -#define        PCI_CLASS_CODE  0x09    /* 24 bit       Class Code */
> > -#define        PCI_CACHE_LSZ   0x0c    /*  8 bit       Cache Line Size */
> > -#define        PCI_LAT_TIM     0x0d    /*  8 bit       Latency Timer */
> > -#define        PCI_HEADER_T    0x0e    /*  8 bit       Header Type */
> > -#define        PCI_BIST        0x0f    /*  8 bit       Built-in selftest */
> > -#define        PCI_BASE_1ST    0x10    /* 32 bit       1st Base address */
> > -#define        PCI_BASE_2ND    0x14    /* 32 bit       2nd Base address */
> > -/* Byte 18..2b:        Reserved */
> > -#define        PCI_SUB_VID     0x2c    /* 16 bit       Subsystem Vendor ID */
> > -#define        PCI_SUB_ID      0x2e    /* 16 bit       Subsystem ID */
> > -#define        PCI_BASE_ROM    0x30    /* 32 bit       Expansion ROM Base Address */
> > -/* Byte 34..33:        Reserved */
> > -#define PCI_CAP_PTR    0x34    /*  8 bit (ML)  Capabilities Ptr */
> > -/* Byte 35..3b:        Reserved */
> > -#define        PCI_IRQ_LINE    0x3c    /*  8 bit       Interrupt Line */
> > -#define        PCI_IRQ_PIN     0x3d    /*  8 bit       Interrupt Pin */
> > -#define        PCI_MIN_GNT     0x3e    /*  8 bit       Min_Gnt */
> > -#define        PCI_MAX_LAT     0x3f    /*  8 bit       Max_Lat */
> >  /* Device Dependent Region */
> >  #define        PCI_OUR_REG     0x40    /* 32 bit (DV)  Our Register */
> >  #define        PCI_OUR_REG_1   0x40    /* 32 bit (ML)  Our Register 1 */
> > --
> > 2.21.0
> >

Thanks for the feedback!
I will send the patch series soon.

Thanks

--Puranjay
