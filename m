Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975E03A48C4
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 20:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhFKSkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 14:40:05 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:55913 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhFKSkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 14:40:04 -0400
Received: by mail-wm1-f50.google.com with SMTP id g204so8565388wmf.5
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 11:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=opvuVJz+DjWenBUhH3u8+GxXMO3eYLaFOvpeSH8t3rI=;
        b=t27Sb8Jd3hRKIwhxyA74tSSY+nZG0MMdJSOj0MmNrrxJC7vzZi4C617ebN+BLuYmUl
         wJGNHKwQBzsznHG6g8G1GAb66EQ/a/SKbD6Wzya3tYB8BvHDFqHND9PChueAg8ncGpjt
         OYsdIMukcsmQYhOZcY1/GaUVh4vC/cFQ2KmX/JwcW0XVnk0xRmYoRvrc2cryRHiwJg2W
         pdJm1o4yq/Pec1IcDlJlpQZsNgS7QFJXrm6Y/EaSp2zajU4IhzPmYfSCHMjNL+lZWn7p
         mLi85jaGFysUwuoKfI23NEwfPmoAfILTRra7qrwAfw35uOzYNvl6+Gd6m0z8ih6xJaHL
         kNIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=opvuVJz+DjWenBUhH3u8+GxXMO3eYLaFOvpeSH8t3rI=;
        b=tLlh3Xu+xx8KaXTT8+LJKzvdC5o5CGYwRzqaPGpoZOiD4yDRXYndq2mYWLH+omN2T6
         UuaFzn/qvB7LHVVFNp/mBsFBJhefjeWWs6dfyZEp6cJO616t23konIDawxBWmLLdwzH9
         p/8vIsPGOXPCq+FvlLmsa+7Xj3QdmfbgdYm1La1W63E9UQqeWZD3ukjiSyvHWzjMchEx
         70Mh/RotRLop01kfu0N2VdkWEIEBolqeXY1kpJ18KmUaLf4QKkgF/U0xMwf3LInz24uX
         S+DCxdj4CAC92ty6xlvzZsFao5/Gei85JXY77z5kidQ18EMpDzEJ5CPeGvvhE1SM7+tr
         5A8Q==
X-Gm-Message-State: AOAM531qH/X2WNhl+MbrIwQs0kIXP83NWpQyJ3TQXIRnyl6V5OKFx37d
        vPEN5ing4mPfWA17BQvgRdkJMuBF5wsaYXAa5NI=
X-Google-Smtp-Source: ABdhPJwG2z/kgTOIW56/u4FnkLAf2Uj1VdFTSdZ0vOIE+ED2NH5Pr+FiDYVpSI+6dA3aQflux3/8+wKuH6U2oJR0tlc=
X-Received: by 2002:a05:600c:290:: with SMTP id 16mr5331440wmk.162.1623436625993;
 Fri, 11 Jun 2021 11:37:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210611160529.88936-1-lijunp213@gmail.com> <e53a2d46-fd6d-d0cc-8b78-205c5bd6784b@pensando.io>
In-Reply-To: <e53a2d46-fd6d-d0cc-8b78-205c5bd6784b@pensando.io>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Fri, 11 Jun 2021 13:36:55 -0500
Message-ID: <CAOhMmr4Kumw7XCUG1RaN9U+nYR_a6NcY6Z28FnhswV2+ceQuhw@mail.gmail.com>
Subject: Re: [PATCH net-next] ibmvnic: fix kernel build warning in strncpy
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 11:28 AM Shannon Nelson <snelson@pensando.io> wrote=
:
>
> On 6/11/21 9:05 AM, Lijun Pan wrote:
> > drivers/net/ethernet/ibm/ibmvnic.c: In function =E2=80=98handle_vpd_rsp=
=E2=80=99:
> > drivers/net/ethernet/ibm/ibmvnic.c:4393:3: warning: =E2=80=98strncpy=E2=
=80=99 output truncated before terminating nul copying 3 bytes from a strin=
g of the same length [-Wstringop-truncation]
> >   4393 |   strncpy((char *)adapter->fw_version, "N/A", 3 * sizeof(char)=
);
> >        |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~
> >
> > Signed-off-by: Lijun Pan <lijunp213@gmail.com>
> > ---
> >   drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/=
ibm/ibmvnic.c
> > index 497f1a7da70b..2675b2301ed7 100644
> > --- a/drivers/net/ethernet/ibm/ibmvnic.c
> > +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> > @@ -4390,7 +4390,7 @@ static void handle_vpd_rsp(union ibmvnic_crq *crq=
,
> >
> >   complete:
> >       if (adapter->fw_version[0] =3D=3D '\0')
> > -             strncpy((char *)adapter->fw_version, "N/A", 3 * sizeof(ch=
ar));
> > +             memcpy((char *)adapter->fw_version, "N/A", 3 * sizeof(cha=
r));
> >       complete(&adapter->fw_done);
> >   }
> >
>
> This doesn't fix the real problem.  The error message is saying that
> there is no string terminating '\0' byte getting set after the "N/A"
> string, meaning that there could be garbage in the buffer after the
> string that could allow for surprising and bad things to happen when
> that string is used later, including buffer overruns that can cause
> stack smash or other memory munging.
>
> Better would be to use strlcpy() with a limiter of
> sizeof(adapter->fw_version).
>
> sln

Thanks for the tip. I looked up both strscpy and strlcpy. It seems nowadays
strscpy is preferred.
