Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F39216749
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 09:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgGGHXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 03:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgGGHXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 03:23:36 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199CEC061755;
        Tue,  7 Jul 2020 00:23:36 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id h1so9091732vkn.12;
        Tue, 07 Jul 2020 00:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eTRuakPnfWXbOPA0YuwVEGPF6BELfW2YGI8FV22a3D8=;
        b=DX1im+xZt1K0FqBnN82RJezZvsKYs0Ot3lUUcTTGBlMKlp+7o+X/rD0/E+KA+LvbOs
         0LK4bY9K2Rx2nQL1KZy5N1IPbLnTB8RgRjZK+Zg2QmdfbTR//xPfQKb8gV66Y0vcP+2s
         bE7AQYkBA2ACbzQiJnBDUsEp3MWpblmDAKIlcn56SW1XK9qy6L3YZni32LMm8YRYFoNk
         MVAQo7SSFj2C9T5mSDI5zr+BzgQJQWDBnKkFJWV3v7uBZqNRLLe5tHqGh5Z15/xXGsyv
         tCAVvPqYQ/ZKp+7hqT/2Zqax3U9WMNyWw+M1keUkQ7vkrG3TVmRv44A0aci2goBrlK5Y
         YCAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eTRuakPnfWXbOPA0YuwVEGPF6BELfW2YGI8FV22a3D8=;
        b=tyihyG+CT/fSaC2UF2JJGwB0qNnKD0Mn2gj3zyDqPpPi/vY0cjNPb2wzWaGI1mkFcV
         mlqiYJqC3WPYb/HvqLOlQN3n+XmbC4l6fFcMWswd5Ghjj5/T0/KdU86f94wqSYBVmhDp
         nYpCu2epzw3aCnNAh3RHBAfyEQgYhjH/V2InZi0k6OFuk0eO+c76f741KC36643qgPB1
         2UBNK0IbKEAVeKQ7Ik/b4oyuiXXOu57SD5iSk4SHDX9k4KIvXFgcnMjPrBj/rjZaU6E+
         0fVrwxolf26KRVRd8Ohj4uc/IVFQdlmNwR4NtPSx8vkM0eJvPx2KvPA0TON3QqtPM7Nm
         0FNw==
X-Gm-Message-State: AOAM5313kbmd74mODc3yF9vHqD/8MOtzm4QqTPgBGXZvKJMXIQp599iU
        iAfwLOO+ZVzpGLx84dQZnsDEekIKbLz//DDTQtyP7j6MpDY=
X-Google-Smtp-Source: ABdhPJwDoGUthv+zTNF0YQ+DIJ6TUQ/UQkySAGd4cH60E4xW8nEVh/n1Kk8o+49qubrZkhgotuQDWZVp2wGV2w1BEpY=
X-Received: by 2002:a1f:2409:: with SMTP id k9mr8926758vkk.80.1594106615240;
 Tue, 07 Jul 2020 00:23:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200707170650.692c98f0@canb.auug.org.au>
In-Reply-To: <20200707170650.692c98f0@canb.auug.org.au>
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
Date:   Tue, 7 Jul 2020 12:51:53 +0530
Message-ID: <CAP+cEOOUoD6f6DByqC-YF3WN1nO2BMUh5t39Ud6Vz6JEge7oKg@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 12:36 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the net-next tree, today's linux-next build (sparc64
> defconfig) produced this warning:
>
> drivers/net/ethernet/sun/niu.c:9903:12: warning: 'niu_resume' defined but not used [-Wunused-function]
>  static int niu_resume(struct device *dev_d)
>             ^~~~~~~~~~
> drivers/net/ethernet/sun/niu.c:9876:12: warning: 'niu_suspend' defined but not used [-Wunused-function]
>  static int niu_suspend(struct device *dev_d)
>             ^~~~~~~~~~~
>
> Introduced by commit
>
>   b0db0cc2f695 ("sun/niu: use generic power management")
This warning should not have come as the earlier definition of.suspend() and
.resume(), they were not inside "#ifdef CONFIG_PM" container. Or any other
container. Hence I thought adding the "__maybe_unused" attribute to them
would be unnecessary.

I am sending a patch to do the same.

-- Vaibhav Gupta
>
> --
> Cheers,
> Stephen Rothwell
