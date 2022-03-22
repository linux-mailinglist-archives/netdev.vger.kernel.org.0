Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6AF24E45A6
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 19:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240113AbiCVSFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 14:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbiCVSFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 14:05:51 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E389457BC
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 11:04:22 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id kk12so2850905qvb.13
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 11:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1YfB3nU21Rzm/vAgcQvdDap+ZTZjSQsJRZz+sAiYNZA=;
        b=fARpXCi3/DUCzryC/k+nPzkbHi9oKVzGUf/OljbHTQA0fZRuBLK5mDelUQlRIvRybt
         yNUteX/Ge6zWYP8kC//RPvua0k2hQfzorklPHM5CnpD7DA8NTPfHtnpmZ3f8dmepKyw0
         hgpAR4Ex9vcjeCtuoXR4BLqjcxZjj5LA/gdls=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1YfB3nU21Rzm/vAgcQvdDap+ZTZjSQsJRZz+sAiYNZA=;
        b=hAlR9Pot11/RSS3ySvqMpcu818AU1ZZ4fOnlGhzoa63DvQ9BeajWZZnEsJm+EvNiaP
         i6olUCaUhW5W3QRiXVkpC8SApocLbTeEZCKXOZIoxjcpnP/uLMEL1mjJFBmM4fbiFn6p
         4X6xHIlISn4H1CfWef0oj6/m32lCEQCgIghGpS9bTRZjnZgaV/5AjhINFziHp4zd1PMn
         rbpDyt0BSSf4WmyeiRIUoNXOF8mU9+NuX29S0x6cf0P2RRlPsKrthA+HZ2klzMxQuUDk
         Z1ZoIRvWo+F1LAnbCXqteIMq+eZMQ72/29CYdqSHOpQ53M+JXr1HomK9ts8o9PONCSLQ
         t4wg==
X-Gm-Message-State: AOAM531aVEJn3KA3siMtzjPIfTDAdkXSHwyfLqQET0sIYgvhNE/BofL2
        AuUPWbKj8/ekbQSAfMzK7IocDLWyvJ5Vxsc2UM2uOwDYODk=
X-Google-Smtp-Source: ABdhPJwebXlThdsfwh6AvNoYCUsQIlLG6yU6y3ILe/REeUoOELNe5caaBAyOvb34ZgEx6ShGvO/CJ571s0b6HMy2IH8=
X-Received: by 2002:a05:6214:f2c:b0:441:2a14:aa36 with SMTP id
 iw12-20020a0562140f2c00b004412a14aa36mr7685217qvb.43.1647972260939; Tue, 22
 Mar 2022 11:04:20 -0700 (PDT)
MIME-Version: 1.0
References: <1647806284-8529-1-git-send-email-michael.chan@broadcom.com>
 <1647806284-8529-12-git-send-email-michael.chan@broadcom.com>
 <20220321230958.784fe3e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <YjmkXC0rLxsihCMx@C02YVCJELVCG>
In-Reply-To: <YjmkXC0rLxsihCMx@C02YVCJELVCG>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Tue, 22 Mar 2022 11:04:09 -0700
Message-ID: <CACKFLi=CB7nFEbKLPpJsPuBBLv2XqATjLjENJgfYiRcLzgXk3A@mail.gmail.com>
Subject: Re: [PATCH net-next v2 11/11] bnxt: XDP multibuffer enablement
To:     Andy Gospodarek <andrew.gospodarek@broadcom.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003d4a8905dad271fe"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000003d4a8905dad271fe
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 22, 2022 at 3:26 AM Andy Gospodarek
<andrew.gospodarek@broadcom.com> wrote:
>
> On Mon, Mar 21, 2022 at 11:09:58PM -0700, Jakub Kicinski wrote:
> > On Sun, 20 Mar 2022 15:58:04 -0400 Michael Chan wrote:
> > > From: Andy Gospodarek <gospo@broadcom.com>
> > >
> > > Allow aggregation buffers to be in place in the receive path and
> > > allow XDP programs to be attached when using a larger than 4k MTU.
> > >
> > > Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
> > > Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> > > ---
> > >  drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 3 +--
> > >  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 5 -----
> > >  2 files changed, 1 insertion(+), 7 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > > index 84c89ee7dc2f..4f7213af1955 100644
> > > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > > @@ -1937,8 +1937,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
> > >             xdp_active = true;
> > >     }
> > >
> > > -   /* skip running XDP prog if there are aggregation bufs */
> > > -   if (!agg_bufs && xdp_active) {
> > > +   if (xdp_active) {
> > >             if (bnxt_rx_xdp(bp, rxr, cons, xdp, data, &len, event)) {
> > >                     rc = 1;
> > >                     goto next_rx;
> > > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> > > index adbd92971209..3780b491a1d4 100644
> > > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> > > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> > > @@ -374,11 +374,6 @@ static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
> > >     int tx_xdp = 0, rc, tc;
> > >     struct bpf_prog *old;
> > >
> > > -   if (prog && bp->dev->mtu > BNXT_MAX_PAGE_MODE_MTU) {
> >
> > This seems to be missing taking prog->aux->xdp_has_frags into account.
> >
>
> Thanks for the review!  I've sent Michael an updated patch and we should be
> able to get a v3 out this morning to cover this.
>

We'll send v3 when net-next opens up again in 2 weeks.

--0000000000003d4a8905dad271fe
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINFtmmbKvvMpSJbg0XNQq/uUKpcmet7b
vFp++r9RCk0hMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMy
MjE4MDQyMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBOcsNyJaiPDKdoBPL546/HEFwhl4aY+TuwgRA413fVc3ke6SUm
4t+cUlUEsCfY7nfJVlBaLqzj4pBlmfBjNmiWpROybvlXbSRmcoEqBoLe/1HxG2BVScGtm4IZrU0K
KVjDzT9PKaGZQ1nf+R8R1wJ792KgDjRp71QcHBl4kbRAp5si32ormDtnMU0Y6eXb3RX9pbWvv75n
26/lQigHVpSo8XVs4TSnbyFxEaziQud85S7nYWTG0f0binPsQSM40OOMYKbfygB+Z/TBPdT10pgF
+0V6+j6B+khBoSgSj/bUAR1Wr7XrUbIOLua/f2X9MAvpFsxfzY67BerF5FLJRURV
--0000000000003d4a8905dad271fe--
