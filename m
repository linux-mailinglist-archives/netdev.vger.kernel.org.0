Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C1D3E9B17
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 01:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhHKXBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 19:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbhHKXBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 19:01:33 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57096C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 16:01:09 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id s132so4317086qke.9
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 16:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G9sic39ftNKRPKJmbxxgkfKNQfzpUT50XdtDi1T0fio=;
        b=L167tzZaAr4oZgGY4eE3+nEg4EGT+bjnXxwWTOTMiCKHpOyGlM0jPxbfwGBSPkXksr
         To8LuQN1vEpHbxLxDI8562MUAZ+NKt19mMGjdiiPSSS9K+/veGr4DHh9LGIw8vPaE9Zq
         bPBCsAsGpwkWKmVgPxUEP8AQE7epDERhcuLpY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G9sic39ftNKRPKJmbxxgkfKNQfzpUT50XdtDi1T0fio=;
        b=Nq3WgIFE0LkvoXCYopU11QfP9PahoHwariOmIw83g2Mr2eW+Q1AWm267hvkP8IWm8s
         w8adNebg3PZ3ZwuKxIbvSpxQ8yiEEGDZJTrTYZwL0zd+3IAbyUCB+BUqnQBy0FwNNXDw
         7ICz8Vucjt+sazTr5/A9VClwWrk+uHUFEK24p3h0XsFbp1vJ9DeMKAk9Y3d8GXANuLCw
         D12aEPl5wZh7uJHdiW1QFwCE2a1k7HNqLUm98ZOfD6Ty1juDPXA71RZACbyCdpEFkaXt
         ahprLprGGjlBBxdQzq3yDvgvggElzHek7CQNCN3Ap3beVPqtJ+gZ0SACh7zyM4MIiyUL
         UfWg==
X-Gm-Message-State: AOAM532MFnehTxubZXfiEF3KIkPeAj+HM9ZvgK1gCfIoRBTT/lqryaLb
        pq4Y4In5lP+xTdyHwdcG6AhiZzWyt/f8QQtm3+YQTQ==
X-Google-Smtp-Source: ABdhPJyDru0UmdkgkDs2vH5/QlWtZCbO8u03v1h1+f0/R8qpt5FPUo9lh2LaDBMGZf6xGDVAXqtmCrEJDKjnMxL5Gfo=
X-Received: by 2002:a37:2747:: with SMTP id n68mr1413520qkn.431.1628722863368;
 Wed, 11 Aug 2021 16:01:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210811213749.3276687-1-kuba@kernel.org> <20210811213749.3276687-4-kuba@kernel.org>
 <CACKFLinMd6a9Lwq_H1yNp8PFpvNmBsG5R+YGAYuCiF+i0OF+3w@mail.gmail.com> <20210811154441.3b593d94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210811154441.3b593d94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Wed, 11 Aug 2021 16:00:52 -0700
Message-ID: <CACKFLikXmSem_anENYaxh63e9uQNf-9W3cUtMmBoDUoZ+XsOkQ@mail.gmail.com>
Subject: Re: [PATCH net v2 3/4] bnxt: make sure xmit_more + errors does not
 miss doorbells
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jeffrey Huang <huangjw@broadcom.com>,
        Eddie Wai <eddie.wai@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Andrew Gospodarek <gospo@broadcom.com>,
        Netdev <netdev@vger.kernel.org>,
        Edwin Peer <edwin.peer@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000480cc05c9509851"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000000480cc05c9509851
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 11, 2021 at 3:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 11 Aug 2021 15:36:34 -0700 Michael Chan wrote:
> > On Wed, Aug 11, 2021 at 2:38 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > @@ -367,6 +368,13 @@ static u16 bnxt_xmit_get_cfa_action(struct sk_buff *skb)
> > >         return md_dst->u.port_info.port_id;
> > >  }
> > >
> > > +static void bnxt_txr_db_kick(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
> > > +                            u16 prod)
> > > +{
> > > +       bnxt_db_write(bp, &txr->tx_db, prod);
> > > +       txr->kick_pending = 0;
> > > +}
> > > +
> > >  static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> > >  {
> > >         struct bnxt *bp = netdev_priv(dev);
> > > @@ -396,6 +404,8 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> > >         free_size = bnxt_tx_avail(bp, txr);
> > >         if (unlikely(free_size < skb_shinfo(skb)->nr_frags + 2)) {
> > >                 netif_tx_stop_queue(txq);
> > > +               if (net_ratelimit() && txr->kick_pending)
> > > +                       netif_warn(bp, tx_err, dev, "bnxt: ring busy!\n");
> >
> > You forgot to remove this.
>
> I changed my mind. I added the && txr->kick_pending to the condition,
> if there is a race and napi starts the queue unnecessarily the kick
> can't be pending.

I don't understand.  The queue should be stopped if we have <=
MAX_SKB_FRAGS + 1 descriptors left.  If there is a race and the queue
is awake, the first TX packet may slip through if
skb_shinfo(skb)->nr_frags is small and we have enough descriptors for
it.  Let's say xmit_more is set for this packet and so kick is
pending.  The next packet may not fit anymore and it will hit this
check here.

>
> > >                 return NETDEV_TX_BUSY;
> > >         }
> > >
> > > @@ -516,21 +526,16 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> > >  normal_tx:
> > >         if (length < BNXT_MIN_PKT_SIZE) {
> > >                 pad = BNXT_MIN_PKT_SIZE - length;
> > > -               if (skb_pad(skb, pad)) {
> > > +               if (skb_pad(skb, pad))
> > >                         /* SKB already freed. */
> > > -                       tx_buf->skb = NULL;
> > > -                       return NETDEV_TX_OK;
> > > -               }
> > > +                       goto tx_kick_pending;
> > >                 length = BNXT_MIN_PKT_SIZE;
> > >         }
> > >
> > >         mapping = dma_map_single(&pdev->dev, skb->data, len, DMA_TO_DEVICE);
> > >
> > > -       if (unlikely(dma_mapping_error(&pdev->dev, mapping))) {
> > > -               dev_kfree_skb_any(skb);
> > > -               tx_buf->skb = NULL;
> > > -               return NETDEV_TX_OK;
> > > -       }
> > > +       if (unlikely(dma_mapping_error(&pdev->dev, mapping)))
> > > +               goto tx_free;
> > >
> > >         dma_unmap_addr_set(tx_buf, mapping, mapping);
> > >         flags = (len << TX_BD_LEN_SHIFT) | TX_BD_TYPE_LONG_TX_BD |
> > > @@ -617,13 +622,15 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> > >         txr->tx_prod = prod;
> > >
> > >         if (!netdev_xmit_more() || netif_xmit_stopped(txq))
> > > -               bnxt_db_write(bp, &txr->tx_db, prod);
> > > +               bnxt_txr_db_kick(bp, txr, prod);
> > > +       else
> > > +               txr->kick_pending = 1;
> > >
> > >  tx_done:
> > >
> > >         if (unlikely(bnxt_tx_avail(bp, txr) <= MAX_SKB_FRAGS + 1)) {
> > >                 if (netdev_xmit_more() && !tx_buf->is_push)
> > > -                       bnxt_db_write(bp, &txr->tx_db, prod);
> > > +                       bnxt_txr_db_kick(bp, txr, prod);
> > >
> > >                 netif_tx_stop_queue(txq);
> > >
> > > @@ -661,7 +668,12 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> > >                                PCI_DMA_TODEVICE);
> > >         }
> > >
> > > +tx_free:
> > >         dev_kfree_skb_any(skb);
> > > +tx_kick_pending:
> > > +       tx_buf->skb = NULL;
> >
> > I think we should remove the setting of tx_buf->skb to NULL in the
> > tx_dma_error path since we are setting it here now.
>
> But tx_buf gets moved IIRC - if we hit tx_dma_error tx_buf will be one
> of the fragment bufs at this point. It should be legal to clear the skb
> pointer on those AFAICT.

Ah, you're right.

>
> Are you suggesting to do something along the lines of:
>
>         txr->tx_buf_ring[txr->tx_prod].skb = NULL;

Yeah, I like this the best.

>
> ?
>
> > > +       if (txr->kick_pending)
> > > +               bnxt_txr_db_kick(bp, txr, txr->tx_prod);
> > >         return NETDEV_TX_OK;
> > >  }
> > >
>

--0000000000000480cc05c9509851
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
XzCCBUwwggQ0oAMCAQICDBB5T5jqFt6c/NEwmzANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxNDE0MTRaFw0yMjA5MjIxNDQzNDhaMIGO
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFTATBgNVBAMTDE1pY2hhZWwgQ2hhbjEoMCYGCSqGSIb3DQEJ
ARYZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBANtwBQrLJBrTcbQ1kmjdo+NJT2hFaBFsw1IOi34uVzWz21AZUqQkNVktkT740rYuB1m1No7W
EBvfLuKxbgQO2pHk9mTUiTHsrX2CHIw835Du8Co2jEuIqAsocz53NwYmk4Sj0/HqAfxgtHEleK2l
CR56TX8FjvCKYDsIsXIjMzm3M7apx8CQWT6DxwfrDBu607V6LkfuHp2/BZM2GvIiWqy2soKnUqjx
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMaiUVC68Q5ZpmMddLDHzTIrTnpvshiK
OLOqlt7aOQ04MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgx
MTIzMDEwOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDQPUEvYITm16SEdRRI3LjnpfHbgNBKhiiuFDAAd5xV8na1j3py
pLNsJkqcHJ7GkKnsQb31X9bnFCcJxidK35JXJs7+0uslG2Jql1thI7UEx+WKKRLEAKPHq8PPj0+6
5UgEQkQBtavt4HmberZU2HCOn3zLZ/PtOI5hxJZVQEMoOgG5zRNxBC4fmlTXggK6wvo5sT5Hnm+V
nWiW+9uxCIqtrWqbt1lrWnTnZgm/Jje7RE5j8d19jHXXGBqMlGWFE4abbJIoAjI7KACpfofXfRKP
mVmi156T/ad8wgh1ts8/YzE6+b7h+riVi3dgQm4Rc2QeWq7t2rv2Y1rKDdvfwhEI
--0000000000000480cc05c9509851--
