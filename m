Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80145E5539
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 23:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiIUVda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 17:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiIUVd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 17:33:28 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39123A5C76
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 14:33:27 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id dv25so16560840ejb.12
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 14:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Okef8OIcSv6gcEF4vV5JgVoUea1p8bAncUjPQvnT9zg=;
        b=C/Qq7qFTSK1PigHsSXDMhOgSd3pfzPl5RtEQ7hmRCxnwxhXe1VB0JRuJkz53LlbEoo
         sigWvAlqwhgwJACRiCSyYx/9RGfkgzHajx01EeOXA1dGuJpXW06PrnRMyfHPeZMYwCJe
         T8Jy2pGRJZLCnFWLuWhehigMG4vcJM6I5r/vY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Okef8OIcSv6gcEF4vV5JgVoUea1p8bAncUjPQvnT9zg=;
        b=pjVJfkjendB9TDOqCETBtX8Pg0wl5zqCrfbLVL22p+8Csuj4iVDscJf8DN35EOm9cg
         oQoDdiKh4L3OOGdz++MBfN0nxI02JqFaqaF6WmLVCy9ZWHrYcrRwFUhthG4021T/wClc
         F4/Sm783HIyXMQ0qsIuN2IYhJ0XWQw32iBAtxEt67iFVWPaULKr/jd9VOv5e8xR1+p1A
         H16hVLkRg9v5difIvzE5IkFn6PEUWarb0cbPP2ysHaLMKF3EYwNAUdcf+Lazy+5eZN0C
         EEY8nwR3MX4YQtccD6qyAeE0wqb0g1iEVL+2RSXTSBndpbayCQFplg4wDsR55LZYheuH
         HKeg==
X-Gm-Message-State: ACrzQf0WnpfQb6qJYXh928I6dyBosNKVFiT3xwC87gYAkQnQFVBfMajp
        60p2zeF9xfJWSWqMTE/1YjIaoqhLj4dXCx56o9hClw==
X-Google-Smtp-Source: AMsMyM5/g+Ha11SWSRyfv8ICNp0y9Ui36VCWhSooyJet4XdJTRO0O4U3GWiec5g6QFz2g5RkKhupyou2SKq8W5pcv6E=
X-Received: by 2002:a17:907:1c04:b0:780:3341:b9e with SMTP id
 nc4-20020a1709071c0400b0078033410b9emr223916ejc.672.1663796005477; Wed, 21
 Sep 2022 14:33:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220919183907.6689-1-vfedorenko@novek.ru> <CACKFLikj17yP3KZfMCiq3pQk9DZrBCYjA7AFuqjTr72H=_Z-TQ@mail.gmail.com>
In-Reply-To: <CACKFLikj17yP3KZfMCiq3pQk9DZrBCYjA7AFuqjTr72H=_Z-TQ@mail.gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Wed, 21 Sep 2022 14:33:14 -0700
Message-ID: <CACKFLikxsS_arFNuqA8XkUBT09t2g0Qb0-9Z5jVQ5=W3KcV-_w@mail.gmail.com>
Subject: Re: [PATCH net] bnxt_en: replace reset with config timestamps
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e96b2e05e936b1d8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000e96b2e05e936b1d8
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 20, 2022 at 7:36 AM Michael Chan <michael.chan@broadcom.com> wrote:
>
> On Mon, Sep 19, 2022 at 11:39 AM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
> >
> > Any change to the hardware timestamps configuration triggers nic restart,
> > which breaks transmition and reception of network packets for a while.
> > But there is no need to fully restart the device because while configuring
> > hardware timestamps. The code for changing configuration runs after all
> > of the initialisation, when the NIC is actually up and running. This patch
> > changes the code that ioctl will only update configuration registers and
> > will not trigger carrier status change. Tested on BCM57504.
> >
> > Fixes: 11862689e8f1 ("bnxt_en: Configure ptp filters during bnxt open")
> > Cc: Richard Cochran <richardcochran@gmail.com>
> > Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> > ---
> >  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> > index 8e316367f6ce..36e9148468b5 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> > @@ -505,10 +505,8 @@ static int bnxt_hwrm_ptp_cfg(struct bnxt *bp)
> >         ptp->tstamp_filters = flags;
> >
> >         if (netif_running(bp->dev)) {
> > -               rc = bnxt_close_nic(bp, false, false);
> > -               if (!rc)
> > -                       rc = bnxt_open_nic(bp, false, false);
> > -               if (!rc && !ptp->tstamp_filters)
> > +               bnxt_ptp_cfg_tstamp_filters(bp);
> > +               if (!ptp->tstamp_filters)
>
> Closing and opening is the correct sequence, but this might work too.
> Please give us a day to review this.  Thanks.

We have internally discussed this issue in great detail.  If the user
is changing the ALL_RX setting (enabling it or disabling it), just
calling bnxt_ptp_cfg_tstamp_filters() is not sufficient.  The reason
is that there is no synchronization after we send the new setting to
the FW.  We don't know when valid timestamps will start showing up in
the RX completion ring after turning on ALL_RX.  That's why we need to
close and open.  After open, all RX packets are guaranteed to have
valid timestamps.

So what we can do is to detect any changes to ALL_RX setting.  If
ALL_RX is not changing, we can just do what this patch is doing.  If
ALL_RX is changing, we can do something less intrusive than
close/open.  We can just shutdown RX and restart RX.  This way we
don't have to toggle carrier and cause a bigger disruption.

My colleague Pavan will take a few days to work on this.  Thanks.

--000000000000e96b2e05e936b1d8
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
OnaLEot1MoQO7BIe5S9H4AcCEXXcrJJiAtMCl47ARpyHmvQFQFFTrHgUYEd9V+9bOzY7MBIGSV1N
/JfsT1sZw6HT0lJkSQefhPGpBniAob62DJP3qr11tu8CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU31rAyTdZweIF0tJTFYwfOv2w
L4QwDQYJKoZIhvcNAQELBQADggEBACcuyaGmk0NSZ7Kio7O7WSZ0j0f9xXcBnLbJvQXFYM7JI5uS
kw5ozATEN5gfmNIe0AHzqwoYjAf3x8Dv2w7HgyrxWdpjTKQFv5jojxa3A5LVuM8mhPGZfR/L5jSk
5xc3llsKqrWI4ov4JyW79p0E99gfPA6Waixoavxvv1CZBQ4Stu7N660kTu9sJrACf20E+hdKLoiU
hd5wiQXo9B2ncm5P3jFLYLBmPltIn/uzdiYpFj+E9kS9XYDd+boBZhN1Vh0296zLQZobLfKFzClo
E6IFyTTANonrXvCRgodKS+QJEH8Syu2jSKe023aVemkuZjzvPK7o9iU7BKkPG2pzLPgxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxeQGjDntHGb2iaQkIw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJpTSkDoDCcLs0a6/Zi+TUaqekhiU+jp
dH7yijo0zeQWMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDky
MTIxMzMyNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAqqxLJ3kO86VTJGvEE9LzmDLJDCEnKMiPglzTgxAVp45YN3Pp1
rjHoGGyNCqq0rCx691Z388h3araFnSMhJQHsFnax/ur+zJxYy8E6h/SCiMgehxnBQp28vQ3hxnMd
PrkEStgXRGQo56TP877fPYcpOTVkwW/GvQqHrWFxVA9gemIFqy8CBZxU2j5jheLTdQnBAz4CJyGZ
hJ2M0fCbZV9isMnS43vvoOQzHFBs83VZ2n1QS52vM3qFPd3/NktWcAF1qaZSbHFqJtfk0yo3TNz9
oMdUQfwSGgvZo4s54Eq+zAno1oTpfmSFto3C7xxz7JjXw7RcoVuVUTvJ0jfRmu74
--000000000000e96b2e05e936b1d8--
