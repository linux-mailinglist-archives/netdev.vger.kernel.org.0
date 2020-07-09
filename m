Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6029121ABAF
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 01:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgGIXdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 19:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgGIXdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 19:33:41 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D27C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 16:33:41 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id h28so3193832edz.0
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 16:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=awu71g6w9tVgShIVUktwo147GkD8GiWeBYlmNc1SKDw=;
        b=PpM30GWzgEHwBOF1GT+MF/Loman6ouO3iaC8qXu2FRTonT2eoNDBg311ybSkj9md77
         3yrFFIEMPebQA1BwU/Xwlh4p+d40YSIb/+fH8LAqoHMP7I5vXVoO4l62oJtLihA2Z540
         ixjlm1j9pMf83yeaRHK/2siGzFn+6GUeK/iaMOdWNX8B4z+lkifJhPTBULVfqV47pGNF
         5HMU3S0Be/sbmkv1rpSUyOHjcTpSwL8KyNDlUsAY18fus86l39arifPvtGuRaS+U6oY1
         LgxI+CFB4uR3ViE+kFyVYhEk0pNN+850rpTAhDzCeIkI8kLxLHzwt4NsbbvH3nt9Y6xH
         RTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=awu71g6w9tVgShIVUktwo147GkD8GiWeBYlmNc1SKDw=;
        b=QBhLERuhCmIxJdgV8GKAWDA54PaV0r/5dViriBsAM0WNH/2ThQa1tEE3j2kVFHF4Gn
         fGCizrmX66ARHaeEcNyLMHcF8VVTwpsHQjn7qMbdlb3o48k8ooJQUrURIZKH+J855WgN
         X8h8GIv1XUveqtuNhLlGpPvpvW7TuAd/AIJAjDfusbGfA1K8g9cl+WKLjvvog69kUOPg
         77F6iBU9M3xRUP5eWDMJp9Z1g+uPPt0PNye/rFEIPKHL/yM7pBzA4fiURsC0fFPlcMCY
         h9sFQ9FC2EjeyjW/Z9i9JbTIFXaFqD5pX9WxFf/clTPgAZ/sG6GEci1tl1NaYEXOEkJ/
         bdtw==
X-Gm-Message-State: AOAM533v8vGkVGKlE8GPcKLfv4gb7nUPK62EB9FapvsOtObe/o3rchQr
        XTqPzYusFb22jJQZ2Ucmf0E=
X-Google-Smtp-Source: ABdhPJw2B+YdIxz50k+YxpFQx0LSSBwlmvgxjV/7Y6lxH9eWioD13DhBbY8Lln4G4KBbM9+cdXb/Og==
X-Received: by 2002:a05:6402:1a3c:: with SMTP id be28mr65624587edb.140.1594337620226;
        Thu, 09 Jul 2020 16:33:40 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id m13sm2599007ejc.1.2020.07.09.16.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 16:33:39 -0700 (PDT)
Date:   Fri, 10 Jul 2020 02:33:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, netdev@vger.kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: MDIO Debug Interface
Message-ID: <20200709233337.xxneb7kweayr4yis@skbuf>
References: <C42DZQLTPHM5.2THDSRK84BI3T@wkz-x280>
 <20200709223936.GC1014141@lunn.ch>
 <20200709225725.xwmyhny4hmiyb5nt@skbuf>
 <20200709232035.GE1014141@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709232035.GE1014141@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 01:20:35AM +0200, Andrew Lunn wrote:
> > Virtualization is a reasonable use case in my opinion and it would
> > need something like this, for the guest kernel to have access to its
> > PHY.
> 
> And i would like a better understanding of this use case. It seems odd
> you are putting the driver for a PHY in the VM. Is the MAC driver also
> in the VM? As you said, VM context switches are expensive, so it would
> seem to make more sense to let the host drive the hardware, which it
> can do without all these context switches, and export a much simpler
> and efficient API to the VM.
> 
>     Andrew

The MAC driver is also in the VM, yes, and the VM can be given
pass-through access to the MAC register map. But the PHY is on a shared
bus. It is not desirable to give the VM access to the entire MDIO
controller's register map, for a number of reasons which I'm sure I
don't need to enumerate. So QEMU should be instructed which PHY should
each network interface use and on which bus, and it should fix-up the
device tree of the guest with a phy-handle to a PHY on a
para-virtualized MDIO bus, guest-side driver of which is going to be
accessing the real MDIO bus through this UAPI which we're talking about.
Then the host-side MDIO driver can ensure serialization of MDIO
accesses, etc etc.

It's been a while since I looked at this, so I may be lacking some of
the technical details, and brushing them up is definitely not something
for today.

-Vladimir
