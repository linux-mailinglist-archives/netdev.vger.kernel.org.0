Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8914EBCD
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfFUPTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:19:43 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33178 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfFUPTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 11:19:43 -0400
Received: by mail-pf1-f194.google.com with SMTP id x15so3786165pfq.0;
        Fri, 21 Jun 2019 08:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wkYJv093Ph/iPqswb4+lpc13NRD+hmqJJxad6v6T4Wg=;
        b=JG74n1GEpv3kCeplvo4x/WuN7VNLAV3o6XmJ5NxsplUNZojG8xOuo4wLMtEfwA3UFP
         DNVnx7x8a6Hwedzhz84nYPdNwjT4Y4ft0QUOtVSaiIR6QP2p1WZOQbdNz8PraDw2nFRr
         lzIRaPAJMrJy+XiaQ7RJcHOoI06br0TzTijIq5ar1nuEvTHTgNm0JArmd9FGbnBKOvJC
         9lJbEzJOrgYrfCW8jYb27HnFH8NS8Fqqi02DpvXiAdNN/8gL2O0A0C2kzqZKwZqJd2hU
         2FohhOBL3ghbeKuNnGJnCiTMpNNV7mDXryE4UTyCHHub3QD2HLm8Tx43UroDd1+r4yQ4
         RHDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wkYJv093Ph/iPqswb4+lpc13NRD+hmqJJxad6v6T4Wg=;
        b=BH+6Xoill4yCvbKRHnxRSwDNICrkudVi5THQLaQRltiQHMCpShY+KxAVhM/ZbjEYqc
         CRE/u5ltQbwQ9tZgetD9OxwLe5HV/nHMJLSv7dP62qFNuW8eL6LMrOAixxVvbODvoLCt
         k4iV2axa/fHPfNb/5hPQ0iL7Bhr87XWQ7YJ9hf0NnnyO/M6BVTJSRSGvI6xry34OMtim
         c7mJiM+wxNgSm+USaAXx1K1MMuoASx8sqgIK0FTFFUqfCq8AEq/NnnwJdR13o19e8qbI
         E+RrtGESeaGsUW/yoc+l9S8l6NDKq2cqaZfea/PBhaM0xnQ6QZ4EfGqbQCJXXwIkIjSo
         h1Aw==
X-Gm-Message-State: APjAAAUSpFl4XCRp67YL1ZzgfZ1ky6MRTTAvHG35I4wtfArSQVF14EAR
        XtPbfa/ZSGumUS5k0Zsm/EuCSLRBJXVIPQ==
X-Google-Smtp-Source: APXvYqwdKO8QnReTZDmtgPmfnr2ABDKp3jxXDz3DL9xxFZWLD9xyLVdfrqcULfi/6Fo47NOHO+Wksw==
X-Received: by 2002:a63:5c19:: with SMTP id q25mr19314252pgb.215.1561130382498;
        Fri, 21 Jun 2019 08:19:42 -0700 (PDT)
Received: from arch ([112.196.181.13])
        by smtp.gmail.com with ESMTPSA id b6sm2800521pgd.5.2019.06.21.08.19.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 08:19:42 -0700 (PDT)
Date:   Fri, 21 Jun 2019 20:49:28 +0530
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v4 0/3] net: fddi: skfp: Use PCI generic definitions
 instead of private duplicates
Message-ID: <20190621151927.GA12091@arch>
References: <20190621151415.10795-1-puranjay12@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621151415.10795-1-puranjay12@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 08:44:12PM +0530, Puranjay Mohan wrote:
> This patch series removes the private duplicates of PCI definitions in
> favour of generic definitions defined in pci_regs.h.
> 
> This driver only uses some of the generic PCI definitons,
> which are included from pci_regs.h and thier private versions
> are removed from skfbi.h with all other private defines.
> 
> The skfbi.h defines PCI_REV_ID and other private defines with different
> names, these are renamed to Generic PCI names to make them
> compatible with defines in pci_regs.h.
> 
> All unused defines are removed from skfbi.h.
>
I left some of the definitions in v4 too!
will remove them all and send v5
sorry for the inconvenience
> Changes in v4:
> Removed unused PCI definitions which were left in v3
> 
> Changes in v3:
> Renamed all local PCI definitions to Generic names.
> Corrected coding style mistakes.
> 
> Changes in v2:
> Converted individual patches to a series.
> Made sure that individual patches build correctly
> 
> Puranjay Mohan (3):
>   net: fddi: skfp: Rename local PCI defines to match generic PCI defines
>   net: fddi: skfp: Include generic PCI definitions
>   net: fddi: skfp: Remove unused private PCI definitions
> 
>  drivers/net/fddi/skfp/drvfbi.c  |   3 +-
>  drivers/net/fddi/skfp/h/skfbi.h | 217 +-------------------------------
>  2 files changed, 6 insertions(+), 214 deletions(-)
> 
> -- 
> 2.21.0
> 
