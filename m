Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE8CA17C40E
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 18:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgCFRRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 12:17:53 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37087 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgCFRRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 12:17:52 -0500
Received: by mail-pj1-f65.google.com with SMTP id mt4so636630pjb.2
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 09:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PqoNxF7YSq276eb0T6mYjC4MPZB53ux70sz8XMDxMWk=;
        b=mVkfhhfUuFheVuWJ0iAe2Ivg9al6M3WovWk79tXXnm/dD57dm/XXH8HCfENjuK19oF
         hDBdfbEqKasrEkZELvrkFAhM2OJcVmjiLuiWdu64TKgdd7M45nqwv19cdvBAniP5Wi1X
         a4VSM/uaqN995/JTm1WonY0Y1KkLdhRAJQP4YBuqBTSTMYoTaE5wQTyoXDVFPVHTelgj
         9KNBqhseYChMGMmDjNXtWjIxuYZuIWal2hy2QgOZZlZUug167egJ+2SxC21fArW3B130
         0vTOeD1FSnQiX+LrmJT1AskZ6BAQqghsjLt0RlKDrYvb5QGridMOWkaYs1dmbhDBNszO
         0eRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PqoNxF7YSq276eb0T6mYjC4MPZB53ux70sz8XMDxMWk=;
        b=r2bL9A5uQIvWVCKSiLlKc7TYt6LBKtNcdlqK52NZZNYSLTkzpsql1gNDCGyvc509dq
         L8+IC6CC9qPvxdzTDkgLrQGqylJlHtFg2uVXlJ3fnlCcClQpLS2EcV+38lUvCpK/BT1B
         oFc2lFtaltmHbn0eVHDvw2Z+RYI6Um8rgk0Jo2RYoPgyD/x+6qt5aFlJDbHlILedo+07
         bxJBEk8ctpaiZ3HJONw7HDuV+mVl5mpYKanQSclxDkJdN3CxYZimBfzZs1x+QSajHQJ3
         RAFBmwgcn9YX/TBLIIbh2pm28J6nC4/DpPdss8OxPeK2pJUG7osNSBYWOldnIHvQ4Uc9
         dHkA==
X-Gm-Message-State: ANhLgQ3yF8psjSaXwdFrXqW71xgGfiffb3JOOUjcfk/PENCDAadowUxU
        tf3rjxbUjGnOB2e9KVtdnkU7
X-Google-Smtp-Source: ADFU+vs9n504icpcgBRWS8dnnvqO26KvHaArPJDCaoPpwfCavpuYcrvN3HP5MAoT5BX8aEvuS8C0VQ==
X-Received: by 2002:a17:90a:2370:: with SMTP id f103mr4437987pje.187.1583515071837;
        Fri, 06 Mar 2020 09:17:51 -0800 (PST)
Received: from Mani-XPS-13-9360 ([2409:4072:6493:b6ea:b913:73f:c15a:6595])
        by smtp.gmail.com with ESMTPSA id j12sm10349346pjd.4.2020.03.06.09.17.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 06 Mar 2020 09:17:51 -0800 (PST)
Date:   Fri, 6 Mar 2020 22:47:42 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: [PATCH v2 0/2] Migrate QRTR Nameservice to Kernel
Message-ID: <20200306171742.GA14558@Mani-XPS-13-9360>
References: <20200220151327.4823-1-manivannan.sadhasivam@linaro.org>
 <CAGRyCJGMxMO-8b3QniJP0XVgTT4zxSd=pm_O=4T5N3f3H3aM2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGRyCJGMxMO-8b3QniJP0XVgTT4zxSd=pm_O=4T5N3f3H3aM2w@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Mar 06, 2020 at 05:18:01PM +0100, Daniele Palmas wrote:
> Hello Mani,
> 
> Il giorno gio 20 feb 2020 alle ore 16:15 Manivannan Sadhasivam
> <manivannan.sadhasivam@linaro.org> ha scritto:
> >
> > Hello,
> >
> > This patchset migrates the Qualcomm IPC Router (QRTR) Nameservice from userspace
> > to kernel under net/qrtr.
> >
> 
> I saw those and the MHI driver related patches, thanks for doing them.
> 
> Are you going to submit also the controller and device (uci, netdev)
> drivers for SDX55 modem?
> 

This is certainly on the TODO list but there is no fixed timeline. Current
patchset focuses QCA6390 only, which does not need these drivers. So maybe
sometime later, we can expect these drivers to get upstreamed.

Thanks,
Mani

> Thanks,
> Daniele
> 
> > The userspace implementation of it can be found here:
> > https://github.com/andersson/qrtr/blob/master/src/ns.c
> >
> > This change is required for enabling the WiFi functionality of some Qualcomm
> > WLAN devices using ATH11K without any dependency on a userspace daemon. Since
> > the QRTR NS is not usually packed in most of the distros, users need to clone,
> > build and install it to get the WiFi working. It will become a hassle when the
> > user doesn't have any other source of network connectivity.
> >
> > The original userspace code is published under BSD3 license. For migrating it
> > to Linux kernel, I have adapted Dual BSD/GPL license.
> >
> > This patchset has been verified on Dragonboard410c and Intel NUC with QCA6390
> > WLAN device.
> >
> > Thanks,
> > Mani
> >
> > Changes in v2:
> >
> > * Sorted the local variables in reverse XMAS tree order
> >
> > Manivannan Sadhasivam (2):
> >   net: qrtr: Migrate nameservice to kernel from userspace
> >   net: qrtr: Fix the local node ID as 1
> >
> >  net/qrtr/Makefile |   2 +-
> >  net/qrtr/ns.c     | 751 ++++++++++++++++++++++++++++++++++++++++++++++
> >  net/qrtr/qrtr.c   |  51 +---
> >  net/qrtr/qrtr.h   |   4 +
> >  4 files changed, 767 insertions(+), 41 deletions(-)
> >  create mode 100644 net/qrtr/ns.c
> >
> > --
> > 2.17.1
> >
