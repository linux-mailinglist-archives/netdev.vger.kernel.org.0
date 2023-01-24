Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D990679352
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 09:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbjAXIny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 03:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbjAXIny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 03:43:54 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37023526B
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 00:43:52 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id bk15so36958755ejb.9
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 00:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WoLCMAj0vVtyFYvVH85gtYOxuuRRuWkOyYgJcpF9FRo=;
        b=ECtgMnNNLvD8yZFcXjqyPoDvxPmnTCmlTCeRmOVNzLmYS6tvnQl+KR5Ltwk6dQ22+N
         KZwd1X+vJ2JS2Dzeo4xc+OrTLjYpgnwW3pNf9E/y+mLiViwzipCsYdRD0Uy9HnriweFj
         LS0YLwbNAmmeLdoreR4ImxD16BQ4+eGpy3q9A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WoLCMAj0vVtyFYvVH85gtYOxuuRRuWkOyYgJcpF9FRo=;
        b=xYxwzZe3L37NTdg1DIyPVz6i/CoXeeSNzVMfseyfSdAK0UYcryMm0oVBAp2cLQZxx7
         3NW9aXoYSUzT8GT2sqrieruggOQIcxXuMgizFFCHIkaJBq8u2MRTDoYy2A4TmVPqVnBr
         wsENstpMVT4C3gV3Hn8p1ewuCUE83D3yhD5IKcKchO41MGWRz8crTCvcMkM3FBwiuvtk
         oGIpIxIRVeOqOLJzU6CXMJbX+rTwh/J6eWsm9uze4kv2V2fnONyyseN0aaazF7eoYFvw
         s0L8jmUpUCmohezYFTucu7LpGcqum/wD0rCX4vZ1mof5sI3EM0I9oLEj2GU0LbSg/MEn
         y89A==
X-Gm-Message-State: AFqh2kp1XzlYcIA2fP+ji08VC+m8tnLot2kkxI4INE3RGgLyOTwDR1WY
        p+Bqk06pgZj/BPTGC1e5rawOTfFJ0E39uodNvN2jCQ==
X-Google-Smtp-Source: AMrXdXuW+0FazexgHjDkK9x/4YIQCs+QeqvkptcJh2KlTsMZeTA4LBJNe2ZHaazdnEl6P7lF1siWwpAsZ3HTZWO7JLM=
X-Received: by 2002:a17:906:dc4:b0:870:8c1b:a25a with SMTP id
 p4-20020a1709060dc400b008708c1ba25amr3385159eji.348.1674549830668; Tue, 24
 Jan 2023 00:43:50 -0800 (PST)
MIME-Version: 1.0
References: <20230124003107.214307-1-drc@linux.vnet.ibm.com> <CALs4sv1OYthkDYBbj9i-jytWo7VZ2rL9VcHiWP55svVX8R20RQ@mail.gmail.com>
In-Reply-To: <CALs4sv1OYthkDYBbj9i-jytWo7VZ2rL9VcHiWP55svVX8R20RQ@mail.gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Tue, 24 Jan 2023 00:43:38 -0800
Message-ID: <CACKFLikyHar-H46VvN1cgTubdw88nQyh7pJ=zUq0V=kWx8CoVg@mail.gmail.com>
Subject: Re: [PATCH] net/tg3: resolve deadlock in tg3_reset_task() during EEH
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc:     David Christensen <drc@linux.vnet.ibm.com>, netdev@vger.kernel.org,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000dda72405f2fe833c"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000dda72405f2fe833c
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 23, 2023 at 11:25 PM Pavan Chebbi <pavan.chebbi@broadcom.com> wrote:
>
> On Tue, Jan 24, 2023 at 6:01 AM David Christensen
> <drc@linux.vnet.ibm.com> wrote:
> >
> >
> > diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
> > index 59debdc344a5..ee4604e6900e 100644
> > --- a/drivers/net/ethernet/broadcom/tg3.c
> > +++ b/drivers/net/ethernet/broadcom/tg3.c
> > @@ -11166,7 +11166,8 @@ static void tg3_reset_task(struct work_struct *work)
> >         rtnl_lock();
> >         tg3_full_lock(tp, 0);
> >
> > -       if (!netif_running(tp->dev)) {
> > +       // Skip reset task if no netdev or already in PCI recovery
> > +       if (!tp->dev || tp->pcierr_recovery || !netif_running(tp->dev)) {
>
> Thanks for the patch. Can we not use netif_device_present() here?

Take a look at the beginning of tg3_io_error_detected().  I think he
is trying to follow the same recipe there.  Basically, if a PCIe AER
has already been detected, then let it finish and do nothing here.

I don't think the tp->dev check is needed though.  We always call
tg3_reset_task_cancel() before we call unregister_netdev() and
free_netdev().

>
> >                 tg3_flag_clear(tp, RESET_TASK_PENDING);
> >                 tg3_full_unlock(tp);
> >                 rtnl_unlock();
> > @@ -18101,6 +18102,9 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
> >
> >         netdev_info(netdev, "PCI I/O error detected\n");
> >
> > +       /* Want to make sure that the reset task doesn't run */
> > +       tg3_reset_task_cancel(tp);
> > +
> >         rtnl_lock();
> >
> >         /* Could be second call or maybe we don't have netdev yet */
> > @@ -18117,9 +18121,6 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
> >
> >         tg3_timer_stop(tp);
> >
> > -       /* Want to make sure that the reset task doesn't run */
> > -       tg3_reset_task_cancel(tp);
> > -
> >         netif_device_detach(netdev);
> >
> >         /* Clean up software state, even if MMIO is blocked */
> > --
> > 2.31.1
> >

--000000000000dda72405f2fe833c
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQbQYJKoZIhvcNAQcCoIIQXjCCEFoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3EMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBUwwggQ0oAMCAQICDF5AaMOe0cZvaJpCQjANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAwODIxMzhaFw0yNTA5MTAwODIxMzhaMIGO
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFTATBgNVBAMTDE1pY2hhZWwgQ2hhbjEoMCYGCSqGSIb3DQEJ
ARYZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBALhEmG7egFWvPKcrDxuNhNcn2oHauIHc8AzGhPyJxU4S6ZUjHM/psoNo5XxlMSRpYE7g7vLx
J4NBefU36XTEWVzbEkAuOSuJTuJkm98JE3+wjeO+aQTbNF3mG2iAe0AZbAWyqFxZulWitE8U2tIC
9mttDjSN/wbltcwuti7P57RuR+WyZstDlPJqUMm1rJTbgDqkF2pnvufc4US2iexnfjGopunLvioc
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIB01EFoXFouS8aRLauwe83oIMzrbf0PT
pYEfH4Cc2JhkMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDEy
NDA4NDM1MVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCB54Vy1lIlYN5d9q8a5xmaI1vcH8HM9njTzZStM/dXw0F5NwvF
fQ5aBqsKuLy+TkFsIqRgCRAXIprWXR8Zqb8/GzRaBcvrDy6KuNGVP3BkYUFG9jkxFfiigsrpPaZS
dSxhz3cNdvX0TGZaJfzauGrcRypogcvNNeZO2gpcA7finDEyqU9VWaDt/JGZcWb0jTupEFDzJA0F
97eL55ZBQw6sRQfw2ItlXk8QxEUvzaem/NgwWqxOwuOxUanwGzG7IEfM7dPMCnwxXTwQoJMaNdd2
CTLR9jASZa2cB58rMqJ6ZT5YgcdmjEkQDgCV7dcSsbI5iHAEyazPTM+GrxVIkRt/
--000000000000dda72405f2fe833c--
