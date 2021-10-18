Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2125043266C
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbhJRSfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhJRSfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:35:15 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BACDC06161C;
        Mon, 18 Oct 2021 11:33:04 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id g5so11895101plg.1;
        Mon, 18 Oct 2021 11:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:content-transfer-encoding:from:to:cc:subject:date
         :message-id:in-reply-to;
        bh=QHlN/204mE0WcKuSOglcG6xZsaKzcaN6bu3nCZc3A54=;
        b=f8mAhQDAjRALeuc1BUBw4uKKKeKxyC0PIYlnXV8DCvR9/D6aqJW0knsDvzIElj6S9j
         zspOFAKG/Q0SEHx3R1aooXGxlMGZ5FdkqMySGrE2fhNgRQDNmUhfFzSuTmeQ23q84OGU
         /eDAdOYIWMyPjXGiYU9E3WllxJlUh2RUMgwBTLcOxnQcjQg5GP6nNAu29DhDVXkedjE8
         nekNRWyQXk/zmY9HtfnFFzSixWH/G5VK1CYPGLoPvFEOMZckhZ+g76VMBTx7+rglNmFD
         lzWs0EytG1IEui4gsKxceOwr/G5QxG4rGD1SYRbc0HF5QQf0YNyMad5xoFGNmRumuPnr
         UN4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:content-transfer-encoding:from:to
         :cc:subject:date:message-id:in-reply-to;
        bh=QHlN/204mE0WcKuSOglcG6xZsaKzcaN6bu3nCZc3A54=;
        b=eHLL+PQfo5rkegDuVQqzDW1IPGOY/YbhNN2V3SKGZA4BCiyqeQ8B72/IfaVJLQTXQS
         p+aNbmrd9/Ce+ADzAdNPPF9DMD9GPcGJVeYspvUx04qaJfhfkZPW/JV8nY4/R8YYve8E
         YefynqRCKsI9ySUNEfTl4MSbnsnsIzEDJTlGe1mUlOXEZ/lqkik4OPASVFp59XR1sbdt
         s5PyRcQTgrTbNXP9k929ekXrk9f6FLgPAKEnbO3/cY9vmMm+0NDDi5l33lspagEEV10E
         Dc9Z3fvhgbkfMTWtFVz/xHBUErj7RhN7sW81dUxt3dRVytix/GXpZLbRalhB45UOYRkQ
         zJUw==
X-Gm-Message-State: AOAM531xFHu3aVD6noTMy2OuZR3sXSx5GawcfwAUYYbBNa4gvgDz1Sf2
        YjC3e+ter4RDQm/IezClVp4=
X-Google-Smtp-Source: ABdhPJzohKb+BBfkUsYjIM+G8WLgV2xm9AqEYmGnRbdffL+zGwv4a4+mOnFDLhM+OZxczD36QUInvg==
X-Received: by 2002:a17:902:db01:b0:13e:d9ac:b8ff with SMTP id m1-20020a170902db0100b0013ed9acb8ffmr29181455plx.46.1634581983804;
        Mon, 18 Oct 2021 11:33:03 -0700 (PDT)
Received: from localhost ([117.200.53.211])
        by smtp.gmail.com with ESMTPSA id g7sm9701710pgp.17.2021.10.18.11.32.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 11:33:03 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
From:   "Sireesh Kodali" <sireeshkodali1@gmail.com>
To:     "Alex Elder" <elder@ieee.org>, <phone-devel@vger.kernel.org>,
        <~postmarketos/upstreaming@lists.sr.ht>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <elder@kernel.org>
Cc:     "Vladimir Lypak" <vladimir.lypak@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: [RFC PATCH 13/17] net: ipa: Add support for IPA v2.x in the
 driver's QMI interface
Date:   Mon, 18 Oct 2021 23:52:31 +0530
Message-Id: <CF2QQACAFQQ9.3H61DJ29ALVVI@skynet-linux>
In-Reply-To: <d50312f8-823d-01b1-47a5-7190be93408d@ieee.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu Oct 14, 2021 at 4:00 AM IST, Alex Elder wrote:
> On 9/19/21 10:08 PM, Sireesh Kodali wrote:
> > On IPA v2.x, the modem doesn't send a DRIVER_INIT_COMPLETED, so we have
> > to rely on the uc's IPA_UC_RESPONSE_INIT_COMPLETED to know when its
> > ready. We add a function here that marks uc_ready =3D true. This functi=
on
> > is called by ipa_uc.c when IPA_UC_RESPONSE_INIT_COMPLETED is handled.
>
> This should use the new ipa_mem_find() interface for getting the
> memory information for the ZIP region.
>

Got it, thanks

> I don't know where the IPA_UC_RESPONSE_INIT_COMPLETED gets sent
> but I presume it ends up calling ipa_qmi_signal_uc_loaded().
>

IPA_UC_RESPONSE_INIT_COMPLETED is handled by the ipa_uc sub-driver. The
handler calls ipa_qmi_signal_uc_loaded() once the response is received,
at which point we know the uc has been inited.

> I think actually the DRIVER_INIT_COMPLETE message from the modem
> is saying "I finished initializing the microcontroller." And
> I've wondered why there is a duplicate mechanism. Maybe there
> was a race or something.
>

This makes sense. Given that some modems rely on the IPA block for
initialization, I wonder if Qualcomm decided it would be easier to allow
the modem to complete the uc initialization and send the signal instead.

Regards,
Sireesh
> -Alex
>
> > Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
> > Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
> > ---
> >   drivers/net/ipa/ipa_qmi.c | 27 ++++++++++++++++++++++++++-
> >   drivers/net/ipa/ipa_qmi.h | 10 ++++++++++
> >   2 files changed, 36 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
> > index 7e2fe701cc4d..876e2a004f70 100644
> > --- a/drivers/net/ipa/ipa_qmi.c
> > +++ b/drivers/net/ipa/ipa_qmi.c
> > @@ -68,6 +68,11 @@
> >    * - The INDICATION_REGISTER request and INIT_COMPLETE indication are
> >    *   optional for non-initial modem boots, and have no bearing on the
> >    *   determination of when things are "ready"
> > + *
> > + * Note that on IPA v2.x, the modem doesn't send a DRIVER_INIT_COMPLET=
E
> > + * request. Thus, we rely on the uc's IPA_UC_RESPONSE_INIT_COMPLETED t=
o know
> > + * when the uc is ready. The rest of the process is the same on IPA v2=
.x and
> > + * later IPA versions
> >    */
> >  =20
> >   #define IPA_HOST_SERVICE_SVC_ID		0x31
> > @@ -345,7 +350,12 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
> >   			req.hdr_proc_ctx_tbl_info.start + mem->size - 1;
> >   	}
> >  =20
> > -	/* Nothing to report for the compression table (zip_tbl_info) */
> > +	mem =3D &ipa->mem[IPA_MEM_ZIP];
> > +	if (mem->size) {
> > +		req.zip_tbl_info_valid =3D 1;
> > +		req.zip_tbl_info.start =3D ipa->mem_offset + mem->offset;
> > +		req.zip_tbl_info.end =3D ipa->mem_offset + mem->size - 1;
> > +	}
> >  =20
> >   	mem =3D ipa_mem_find(ipa, IPA_MEM_V4_ROUTE_HASHED);
> >   	if (mem->size) {
> > @@ -525,6 +535,21 @@ int ipa_qmi_setup(struct ipa *ipa)
> >   	return ret;
> >   }
> >  =20
> > +/* With IPA v2 modem is not required to send DRIVER_INIT_COMPLETE requ=
est to AP.
> > + * We start operation as soon as IPA_UC_RESPONSE_INIT_COMPLETED irq is=
 triggered.
> > + */
> > +void ipa_qmi_signal_uc_loaded(struct ipa *ipa)
> > +{
> > +	struct ipa_qmi *ipa_qmi =3D &ipa->qmi;
> > +
> > +	/* This is needed only on IPA 2.x */
> > +	if (ipa->version > IPA_VERSION_2_6L)
> > +		return;
> > +
> > +	ipa_qmi->uc_ready =3D true;
> > +	ipa_qmi_ready(ipa_qmi);
> > +}
> > +
> >   /* Tear down IPA QMI handles */
> >   void ipa_qmi_teardown(struct ipa *ipa)
> >   {
> > diff --git a/drivers/net/ipa/ipa_qmi.h b/drivers/net/ipa/ipa_qmi.h
> > index 856ef629ccc8..4962d88b0d22 100644
> > --- a/drivers/net/ipa/ipa_qmi.h
> > +++ b/drivers/net/ipa/ipa_qmi.h
> > @@ -55,6 +55,16 @@ struct ipa_qmi {
> >    */
> >   int ipa_qmi_setup(struct ipa *ipa);
> >  =20
> > +/**
> > + * ipa_qmi_signal_uc_loaded() - Signal that the UC has been loaded
> > + * @ipa:		IPA pointer
> > + *
> > + * This is called when the uc indicates that it is ready. This exists,=
 because
> > + * on IPA v2.x, the modem does not send a DRIVER_INIT_COMPLETED. Thus =
we have
> > + * to rely on the uc's INIT_COMPLETED response to know if it was initi=
alized
> > + */
> > +void ipa_qmi_signal_uc_loaded(struct ipa *ipa);
> > +
> >   /**
> >    * ipa_qmi_teardown() - Tear down IPA QMI handles
> >    * @ipa:		IPA pointer
> >=20

