Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4463A9681
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 11:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbhFPJwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 05:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbhFPJwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 05:52:49 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43C3C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 02:50:42 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id a11so1902455wrt.13
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 02:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TWCV/GOgTiT+5v4mB6bkQ62Ynk/a4vKkccEaBlfJiHc=;
        b=OgfOA2yt/AUpyDyn/LDR7A8GX3noZcpvhwMIflQkPWRE/cuGEWKqG8N4KIHfiqnyDU
         eyJVFvUX0gO1vxRYNa8IZoLvHIjtfkfHiLkkrXJt6w94QWSSWTC6pS4gF2MJAWVS5ABD
         EZgLDPGutoigG7hjeVsb3hadKpOgPIlnZyUeVBdmH58UkdSrjsC5ViLacKQ29lbsWN2U
         Lh5taizfrgaNGFLN8tY8/d7I+cibXfcP/e9ishgFFnZYgAC7fzx34eg9eNDZJ5xZ3vUT
         ijDg7dWGhqSso6VxeRf4EBtPosqokIvqiGX+NIGd1/DPrasgHONliENno6ITDrpIzI6Z
         HNsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TWCV/GOgTiT+5v4mB6bkQ62Ynk/a4vKkccEaBlfJiHc=;
        b=dtvZOcgDxpj+NvRY8hwAg3/dr0SfduNOzs31fUp7wjWCSIoe4EjtfNsr3lrtOpsbng
         Enb2gTeOrH/uC8FrmgyC+IrZET65XzRIOwnVl3JzT86Wo0FnnsPSCVv4Kp/AEe/XdURR
         1tyYiQtet9o7TtJbxEreVh6VMIN2foq12E2ZprYCBplS3HrZfKYXqhau1FQbrq7hbxzg
         3C2WWFDuKn1mveCHT+hlmxwh2fSY+sPzII+E4QPmT8DzmDTp1GYSubwX+GA4hJ8SWvFs
         4Kn50ijcBRwl4Y3nUOU4uMIa3LP8wrxpvJf7agqWEUe5dQeSa+T+Op1Sv+eG1QMWN0QO
         zefQ==
X-Gm-Message-State: AOAM533Y32dfloxSN495pjFTn4yJ8D4r3x9KL+qYcEeexQ/XMV6eB74Y
        P9VMYz23Uauw8pgJ4JbSSU4=
X-Google-Smtp-Source: ABdhPJyIAQwbkIUoyI2MoC/QDtc2T5m813Pb9pVrw7WG/DX2oqRL1ISyCjHe4KtdIsmgMBpYrxdV9Q==
X-Received: by 2002:a5d:5986:: with SMTP id n6mr4277881wri.60.1623837041154;
        Wed, 16 Jun 2021 02:50:41 -0700 (PDT)
Received: from linux-dev (host81-153-178-248.range81-153.btcentralplus.com. [81.153.178.248])
        by smtp.gmail.com with ESMTPSA id v15sm4512110wmj.39.2021.06.16.02.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 02:50:40 -0700 (PDT)
Date:   Wed, 16 Jun 2021 10:50:38 +0100
From:   Kev Jackson <foamdino@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: ethtool discrepancy between observed behaviour and comments
Message-ID: <YMnJbl1KiB4EaPVP@linux-dev>
References: <YMhJDzNrRNNeObly@linux-dev>
 <20210615124050.50138c05@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615124050.50138c05@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jun 15, 2021 at 12:40:50PM -0700, Jakub Kicinski wrote:
> I'm not sure I grasped what the problem is. Could you perhaps share
> what you're trying to do that works with netlink vs IOCTL? Best if
> it's in form of:
> 
> $ ethtool -l $ifc
> $ ./ethtool-ioctl -L $ifc ...
> # presumably fails IIUC?
> $ ./ethtool-nl -L $ifc ...
> # and this one succeeds?
> 
> where ethtool-ioctl and ethtool-nl would be hacked up ethtool binaries
> which only use one mechanism instead of trying to autoselect.

I have rechecked my assumptions that the EINVAL was propogating from the check
on the rx_count/tx_count and discovered that it wasn't.  After I realised this,
I found that the interface I was trying to call ETHTOOL_SCHANNEL with doesn't
support that operation - there are 2 NICs in this test machine.

Apologies for the noise on the mailing list/your inboxes, I now have a fully
working ETHTOOL_GCHANNEL/ETHTOOL_SCHANNEL test harness (so long as I point my
code at the correct interface!)

Thanks,
Kev
