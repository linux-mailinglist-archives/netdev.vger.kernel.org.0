Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7161D2A874E
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 20:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732046AbgKETfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 14:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbgKETfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 14:35:15 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9D9C0613CF;
        Thu,  5 Nov 2020 11:35:14 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id 62so2009924pgg.12;
        Thu, 05 Nov 2020 11:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cAfagP6TptglHcLWx7VFwM6m74Lt2pq3ChoS3N6uj8U=;
        b=Zcw0GfYhdne29HCTrnIEk0TkhM73039JthrNHXghC30fSft9V2EsPLVoCPCRKDAZbO
         ynwmyHAqac97AVrqyPH/i6kD0YsmRhJDdBp4315/8WJCDXhgAAVM8e0BjIURDJH1X/Hq
         QC8US1CfvJuTMGwiQrJWhqYkT8DJBUwFB2E6nCXOYFb1UkKHzrY0hC59Qknpw7tc56nt
         gDYOS5tmN8bWP4OZ6hhhj9mxGF0GPZs+kIF+g4GGTySBrjdsdnizWcd/43b0pP7lqcWD
         io6WVjBkfjX50qUI5uisTAsHeOG/9UHf9VOu2qgrsu+RUhGae2WAHzAl+fRcIFFKq4VX
         Lcxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cAfagP6TptglHcLWx7VFwM6m74Lt2pq3ChoS3N6uj8U=;
        b=XmkMb45wXUn6JGBr3F7VsjEx4RRR5G/BLdXb+9QbmNxAZrHK8Xju6PUQucgTYi9Sgt
         e+GIcNMDsjpmeHMn/bRMLnV9hWMjs0nfwqPm6WYqWclF6kZQr7wfbQSZsCeTXHhEnya5
         xSowBnviajMFWee2v6aTMaUxtUW4HSteM71OF3/Rk+jy1wFFccGfQL4hYVDWA+I8hNo8
         73eGpW7yElHkxqnZ2cxjDxzm1KAzUDCh/sfzXPfIgI97LFdne5A/fPlFl0LdYDT6ijtO
         G6c5EVhv23NtUAGmU1gjpbxfZ04kB9Og2AsCrNuPPXrsjiiSD55dxs0auguG7k6O5QX/
         CNPw==
X-Gm-Message-State: AOAM530Vf7m+tXdEyJu7S3SDl8PDJy77s8OrDcKborasO91Hmnj87G+X
        xNUw2P39l9x7qJM+p+euxIy4Kp1jRJkskw2wEaHPkSg2
X-Google-Smtp-Source: ABdhPJwuSlGa4EaJUDEsPQqaKLhqqhHPZKlV3e2nlshqrKsNUdm+GzhG38tEQnm1CJZWT0v26yw6SWggKb8fMGjwBWE=
X-Received: by 2002:a17:90a:f2c5:: with SMTP id gt5mr3996781pjb.66.1604604914542;
 Thu, 05 Nov 2020 11:35:14 -0800 (PST)
MIME-Version: 1.0
References: <20201105073434.429307-1-xie.he.0141@gmail.com> <1d7f669ba4e444f1b35184264e5da601@AcuMS.aculab.com>
In-Reply-To: <1d7f669ba4e444f1b35184264e5da601@AcuMS.aculab.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 5 Nov 2020 11:35:05 -0800
Message-ID: <CAJht_EM6rXw2Y6NOw9npqUx-MSscwaZ54q7KM4V2ip_CCQsdeg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: x25_asy: Delete the x25_asy driver
To:     David Laight <David.Laight@aculab.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 1:10 AM David Laight <David.Laight@aculab.com> wrote:
>
> > This driver transports LAPB (X.25 link layer) frames over TTY links.
>
> I don't remember any requests to run LAPB over anything other
> than synchronous links when I was writing LAPB implementation(s)
> back in the mid 1980's.
>
> If you need to run 'comms over async uart links' there
> are better options.
>
> I wonder what the actual use case was?

I think this driver was just for experimental purposes. According to
the author's comment at the beginning of x25_asy.c, this driver didn't
implement FCS (frame check sequence), which was required by CCITT's
standard. So I think this driver was not suitable for real-world use
anyway.
