Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC89730E1D9
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 19:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbhBCSGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 13:06:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232230AbhBCSFv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 13:05:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E879A64F8D;
        Wed,  3 Feb 2021 18:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612375510;
        bh=nN7G9KQLLEC2hXxjXAPVce/sjv7lbc72ZvMgGM+YbUw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FteG5V+1q9Q1i1j6qqzoC01a3FgiHgkhX6N6Alr55EDXoqR1CKHnFJPBZbkbShJIz
         FgybpCDZ+4lZ5LMTESW6MRbrVkWtRfYoVZpRvzgesXTU8oiimNBf0AnMlnBkVPvl+n
         IzMEAJPCG40o4me9FjLFR6arB0jj/60cs4YtZuiMaVqlPs9qtkQtw1Xg2WR11xf8p1
         HyaxfLxn1APGKLg+hDGrbBnIOkxn1VUMNlugFqYTVjyWP3eQ4SrvcxBF/Ci70ZUSX3
         anCYCa92RVLXAjJ03WB1wXkwkdSgBcHqshMPw/kct8McU4rQXUFZSt8apaFBasmZ6U
         TfZTfid9lAmxA==
Date:   Wed, 3 Feb 2021 10:05:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
Message-ID: <20210203100508.1082f73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <835B2E08-7B84-4A02-B82F-445467D69083@linaro.org>
References: <1609958656-15064-1-git-send-email-hemantk@codeaurora.org>
        <20210113152625.GB30246@work>
        <YBGDng3VhE1Yw6zt@kroah.com>
        <20210201105549.GB108653@thinkpad>
        <YBfi573Bdfxy0GBt@kroah.com>
        <20210201121322.GC108653@thinkpad>
        <20210202042208.GB840@work>
        <20210202201008.274209f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <835B2E08-7B84-4A02-B82F-445467D69083@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 03 Feb 2021 09:45:06 +0530 Manivannan Sadhasivam wrote:
> >> Jakub, Dave, Adding you both to get your reviews on this series. I've
> >> provided an explanation above and in the previous iteration [1].  
> >
> >Let's be clear what the review would be for. Yet another QMI chardev 
> >or the "UCI" direct generic user space to firmware pipe?  
> 
> The current patchset only supports QMI channel so I'd request you to
> review the chardev node created for it. The QMI chardev node created
> will be unique for the MHI bus and the number of nodes depends on the
> MHI controllers in the system (typically 1 but not limited). 

If you want to add a MHI QMI driver, please write a QMI-only driver.
This generic "userspace client interface" driver is a no go. Nobody will
have the time and attention to police what you throw in there later.
