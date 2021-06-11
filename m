Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472DC3A462A
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhFKQKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:10:14 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:33404 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhFKQKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 12:10:12 -0400
Received: by mail-wm1-f47.google.com with SMTP id s70-20020a1ca9490000b02901a589651424so6623204wme.0;
        Fri, 11 Jun 2021 09:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y4C/j8fDmkF8F2f66X7DXEUPmSO7gkABoscrxSq9XiA=;
        b=nI6Gqei7FQyaAEPK3N9pcZAp0i4dF4wt30vgb2lMVaxrcXZfQ8IErbShfHHNSVwduD
         ZuoC4wlBU3p27QNYM/fdDDbjZNUarPwKq8cRhC4cU19jpQoPpq9mVojJAqtj+v0SW1lV
         dA9A9Pb9JqvRzm+VeDMxosFkwAFaZRk9LLZZi63er920hbJW8Ocf+rjwi42+oxFBpHLN
         vN7wf0GAqpXV++4Vpsa6Lva3SDmAXGIVlWBbYdNTZkSjoSSVJSZKF573aaASTGSrWrkP
         ILPIYgkg1gWyBpMrT9oH20v30Zx4R9woa7llCC9LQVaxYLx58NwSTh8o9gk38lQQJAQZ
         KjJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y4C/j8fDmkF8F2f66X7DXEUPmSO7gkABoscrxSq9XiA=;
        b=RMYDZPr9wkmQwRiHpHdIiY7Mb5TrJBit+L4fLv/8eqeg11e0OcEnGUWDkQMZ/ImRgJ
         gpNbsmHzH7f8XPasuvjnKs27Fsm/CcZBuMfDyBKqrq9+GVGn8jKL+7QghLJ8068bp7J4
         CmghJTgiw3pkBUf0CLwEjbILS9/x6oTwBDB6YzXdcW0oAaw8eMPey2FWjAiCjjTlTOnG
         ewtxKtkZFbWYRfxElNiMTasQr/+PEHPsr08ErwO3RkqSlTibQaQP+31UhMjvUdzq4tO7
         KPrAhvZhyJ+VT3yKxy4fTe98lkTxvH8LgZquZBklFK4KR6q/PJSNM7rV+fY1VR++a9i6
         k1aQ==
X-Gm-Message-State: AOAM5310SwVlrB/5rzosz8hNVdyTGSAYvQ93ku6vm79t9PBVP7d0mpLm
        Qyw0FvgkDL00qX5ha3jI6amw10MmPwzp0KgyhDs=
X-Google-Smtp-Source: ABdhPJzA0zs07wMJ3XvA1oqrOkPDf6tVWFUKkAKlOXgjRdU1XWw5boYiUcRe2B4kW/wCI521ZjMI4h15CfzbK/6zWsA=
X-Received: by 2002:a7b:c1c5:: with SMTP id a5mr4794416wmj.134.1623427618524;
 Fri, 11 Jun 2021 09:06:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210611132428.74f6c1f9@canb.auug.org.au>
In-Reply-To: <20210611132428.74f6c1f9@canb.auug.org.au>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Fri, 11 Jun 2021 11:06:47 -0500
Message-ID: <CAOhMmr5jwij9TU9nv6nRv53iiCM4GpED+DPXamZmquHnEPqLDg@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 10:26 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the net-next tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
>
> drivers/net/ethernet/ibm/ibmvnic.c: In function 'adapter_state_to_string':
> drivers/net/ethernet/ibm/ibmvnic.c:855:2: warning: enumeration value 'VNIC_DOWN' not handled in switch [-Wswitch]
>   855 |  switch (state) {
>       |  ^~~~~~
> drivers/net/ethernet/ibm/ibmvnic.c: In function 'reset_reason_to_string':
> drivers/net/ethernet/ibm/ibmvnic.c:1958:2: warning: enumeration value 'VNIC_RESET_PASSIVE_INIT' not handled in switch [-Wswitch]
>  1958 |  switch (reason) {
>       |  ^~~~~~
>
> Introduced by commit
>
>   53f8b1b25419 ("ibmvnic: Allow device probe if the device is not ready at boot")
>
> --
> Cheers,
> Stephen Rothwell

https://lore.kernel.org/netdev/20210611153537.83420-1-lijunp213@gmail.com/T/#u

Thanks,
Lijun
