Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308413EA62A
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 16:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237821AbhHLOFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 10:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236421AbhHLOFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 10:05:47 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E04C061756
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 07:05:22 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id b7so7407889plh.7
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 07:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gP2G3tZAkUADNHHh/7cqHmT2JtwBy3/o75K9ELP5C/0=;
        b=OpGITyk3mZ9ejerOdrg/Sw0Mu6K4OfiBzDoYMol5XDuTborJbvLdTNUQFgDS5P/Sfr
         47GGDKFxg9aQYuXGAfMHHLRSEZPG58xnxP7IUm/32rm0OGk5hQHENShAbWEtHZYm8V4M
         E0dnmaIGrdZhIImkYtyc/wF9jscyf6xVlN/mJ1nthOKO00NYrTR/33qPHnB0SDCQ4p8V
         fXVpgQnG5U02jovLOg+EqfMmzrBWB0Ztys55PMc7jiYPRNNcv3Lrofl8CIOlG9BSY4TW
         hs9sK336nTqzryvbr4YTZLV3Mj6aydjk7bpCZJ06JYgq67rKK1JwnHGBoro+Gu7pkRUH
         gTbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gP2G3tZAkUADNHHh/7cqHmT2JtwBy3/o75K9ELP5C/0=;
        b=cGlYpJVyzRYDKapIfYxiwkNGUbWElZxN4v5RGT6S1g8d/8Vk0WGuHYlsltfHC3jXbx
         /jyipOfT96RVU8HACpNtVbY5A10RNSsocq5yiKh0sLjiD4/FlQi1eTmE3COSOLgA7Y+4
         XVZCB76945ORVyaRcgAE+JY98v6JQu+PNDgTTyeIuQxIjGH6aiFMB4VjTS1vU9ikJnJ/
         v8BQ6d6mGgYwc7CYEgLYCK9n+biuDKA+c5xGsiQUrrcBPhEr6gr+jofXfLBRDzdiLXI3
         ZQ2oJjY6JshlgXrGzrpIkOjPC0tvAnR7dKPdq95AqorKR7MqQtwyttYIp7SW4Dg/w1R5
         aIlQ==
X-Gm-Message-State: AOAM531t4hw3QLYgfybA/1HpVlyy2yYox+/zt7Hobaxvuwul95OZeyze
        +/w7dQbwM9gEw+IXOzDuizAE
X-Google-Smtp-Source: ABdhPJwVTBJ2w56C9WM0U5a6Nlza471rAevLHMUQ7Zd66dc666wAdwEkHoOPubrk5R47sSUyuFTw1Q==
X-Received: by 2002:a17:90a:4ecb:: with SMTP id v11mr4468895pjl.63.1628777122129;
        Thu, 12 Aug 2021 07:05:22 -0700 (PDT)
Received: from workstation ([120.138.12.52])
        by smtp.gmail.com with ESMTPSA id i1sm11020132pjs.31.2021.08.12.07.05.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 12 Aug 2021 07:05:21 -0700 (PDT)
Date:   Thu, 12 Aug 2021 19:35:18 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        richard.laing@alliedtelesis.co.nz, linux-arm-msm@vger.kernel.org
Subject: Re: [RESEND] Conflict between char-misc and netdev
Message-ID: <20210812140518.GC7897@workstation>
References: <20210812133215.GB7897@workstation>
 <20210812065113.04cc1a66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812065113.04cc1a66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 06:51:13AM -0700, Jakub Kicinski wrote:
> On Thu, 12 Aug 2021 19:02:15 +0530 Manivannan Sadhasivam wrote:
> > Due to the below commit in netdev there is a conflict between char-misc
> > and netdev trees:
> > 
> > 5c2c85315948 ("bus: mhi: pci-generic: configurable network interface MRU")
> > 
> > Jakub, I noticed that you fixed the conflict locally in netdev:
> > 
> > d2e11fd2b7fc ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
> > 
> > But the commit touches the MHI bus and it should've been merged into mhi
> > tree then it goes via char-misc. It was unfortunate that neither
> > linux-arm-msm nor me were CCed to the patch :/
> > 
> > Could you please revert the commit?
> 
> Apologies for missing the lacking CC list, the extra resolution work,
> etc. etc. Let me try to sharpen the "were maintainers CCed" check in
> patchwork to make this less likely in the future.
> 

No worries. I know how loaded the netdev list is :)

> About the situation at hand - is the commit buggy? Or is there work
> that's pending in char-misc that's going to conflict in a major way? 
> Any chance you could just merge the same patch into mhi and git will 
> do its magic?

I'm not happy with the MHI change and I do have a comment about the
variable "mru_default". So it'd be good if we revert the commit
entirely!

Also I do have few more patches coming for the same driver touched by
5c2c85315948.

Thanks,
Mani
