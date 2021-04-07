Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5DF356CD3
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 15:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbhDGNCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 09:02:50 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:41532 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbhDGNCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 09:02:42 -0400
Received: by mail-wr1-f48.google.com with SMTP id a6so11888866wrw.8;
        Wed, 07 Apr 2021 06:02:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TXqZuGdXJPW/fK3TUxeru63BFIL4FbmmIS0HzVxdfbM=;
        b=X5lgGmvUnMRNLWpHy7Jb6gw+p79mrEfBjWHd4xO2vcxcdcmwq7CniF9mz288CoG0i5
         f8mdrwz4E3woXsEIgNzmxlnW6Ax3F6hAPDTsydjmfWt7o40tMW+rI/zgFGR5DuuCuCR5
         4pzCrTBF0HKJwo+/XB7hXT5g5LR+BwNbCLQS2mqHHUQFPWCq+6hAtisxn/yyfqaqP68v
         1FGEFw4eAMYeTlm4hzmFCoKRyyCPWxZm6lUXSnVKWoki099Ojt24z7acZXlcKJt2irRq
         377HHdGrnbz0Ay1GEmFAsWJWL4AzKOa/NGMrD+TyG3Cz5irIopShJ0lOhtU5qTSVfqFJ
         9uBQ==
X-Gm-Message-State: AOAM533d5fACy50zky3lR0cyA81coFYx5AUnHRwDbhIwqf68Z09xvyzv
        bhf8J2p9OvHc+k+jZqUBa5Pnd1QwnUA=
X-Google-Smtp-Source: ABdhPJx+FU4wwVRbC/815ENUwoRonsyYzkZ47GQ+CV42wf052MLj642jIYNSgfCL+WAfMu8b1Qz2EA==
X-Received: by 2002:a05:6000:22f:: with SMTP id l15mr4361456wrz.364.1617800551854;
        Wed, 07 Apr 2021 06:02:31 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id k3sm19846458wrc.67.2021.04.07.06.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 06:02:31 -0700 (PDT)
Date:   Wed, 7 Apr 2021 13:02:30 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     kernel test robot <lkp@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <20210407130230.3yszl6zhqzf4pmgm@liuwe-devbox-debian-v2>
References: <20210406232321.12104-1-decui@microsoft.com>
 <202104070929.mWRaVyO2-lkp@intel.com>
 <MW2PR2101MB08922BFEFEBFA44744C5795BBF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB08922BFEFEBFA44744C5795BBF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 08:08:59AM +0000, Dexuan Cui wrote:
> > From: kernel test robot <lkp@intel.com>
> > Sent: Tuesday, April 6, 2021 6:31 PM
> > ...
> > Hi Dexuan, 
> > I love your patch! Perhaps something to improve:
> > 
> > All warnings (new ones prefixed by >>):
> > 
> >    drivers/pci/controller/pci-hyperv.c: In function 'hv_irq_unmask':
> >    drivers/pci/controller/pci-hyperv.c:1220:2: error: implicit declaration of
> > function 'hv_set_msi_entry_from_desc'
> > [-Werror=implicit-function-declaration]
> >     1220 |  hv_set_msi_entry_from_desc(&params->int_entry.msi_entry,
> > msi_desc);
> 
> This build error looks strange, because the patch doesn't even touch the driver
> drivers/pci/controller/pci-hyperv.c.
> 

I think this is normal. The bot doesn't restrict itself to the changed
code from my experience.

Wei.
