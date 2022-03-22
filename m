Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FCC4E3C6C
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 11:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbiCVK2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 06:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiCVK2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 06:28:13 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBED1277F
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 03:26:45 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id mm17-20020a17090b359100b001c6da62a559so2136904pjb.3
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 03:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :in-reply-to;
        bh=dH53UrRmlV8jlC4jdNOb9n9oEGVJKlAT79R4srP7yfI=;
        b=DguvbFOTc3Ro4WxNU04UDHlxoLFl4G0u280vsPPfFQlGNml0Vo3cqjbOMWYo1MgbQg
         NkEqYx/f0gXu8XDAZj++bB/ZDb4kkdOBksSQN2ZIy11LMI9E2aW6RyHAlqIOxx4VDM4t
         oo8dtTKNUz9L6quAIoPw8HQrSpz7DGn5/PkAE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:in-reply-to;
        bh=dH53UrRmlV8jlC4jdNOb9n9oEGVJKlAT79R4srP7yfI=;
        b=oFi8B84GeVkyRZ1DY1xqEWkBmaPj1j9ZreWnnKeig6t4zX2se9dUHjT6zNANzXPKh8
         LNyZwc9lIn9n2XYc6rxzX67CEmkPQg4YVpMzC0rVA50GEe8EnrrRpVbfY/mOVzZG49H5
         /wIN8L77xJLuPujSD3A8yB4bWfcEyxEYlW1ngWKjz91F3g/+htlNnHrqUeJEEopeDjGe
         gAYtIxQeldk65Ge6h851bW1H/L7/vfEwltw5aOc/suTr1gQ+5hSN+GqX0zPb42StNWDt
         5sTP2rQQjcgw2/TrmhOlsooo/csV2nYZT1Ct+W16OSqIMZ+3zSkbXeaU3vWz3VOGZSPg
         olnw==
X-Gm-Message-State: AOAM5321SGwLjzBMNtEvFPiQnPph0qcseOz64hNhVLbOinh2pgBMDZZP
        JcaSLh4c5WJRn2CvxKzLejiccQ==
X-Google-Smtp-Source: ABdhPJzEOyAlLxfZbJlWIzqOmJqhqjLnUvTtbloeVHW2SAcL56P8qwE6SCDBd1HlS0wqkilADk8lIA==
X-Received: by 2002:a17:902:6944:b0:153:9866:7fea with SMTP id k4-20020a170902694400b0015398667feamr17520898plt.6.1647944804658;
        Tue, 22 Mar 2022 03:26:44 -0700 (PDT)
Received: from C02YVCJELVCG ([192.19.11.250])
        by smtp.gmail.com with ESMTPSA id ij17-20020a17090af81100b001c67c964d93sm2569587pjb.2.2022.03.22.03.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 03:26:43 -0700 (PDT)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Tue, 22 Mar 2022 06:26:36 -0400
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 11/11] bnxt: XDP multibuffer enablement
Message-ID: <YjmkXC0rLxsihCMx@C02YVCJELVCG>
References: <1647806284-8529-1-git-send-email-michael.chan@broadcom.com>
 <1647806284-8529-12-git-send-email-michael.chan@broadcom.com>
 <20220321230958.784fe3e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
In-Reply-To: <20220321230958.784fe3e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000bc6bd305dacc0cf7"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000bc6bd305dacc0cf7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 21, 2022 at 11:09:58PM -0700, Jakub Kicinski wrote:
> On Sun, 20 Mar 2022 15:58:04 -0400 Michael Chan wrote:
> > From: Andy Gospodarek <gospo@broadcom.com>
> > 
> > Allow aggregation buffers to be in place in the receive path and
> > allow XDP programs to be attached when using a larger than 4k MTU.
> > 
> > Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
> > Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> > ---
> >  drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 3 +--
> >  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 5 -----
> >  2 files changed, 1 insertion(+), 7 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > index 84c89ee7dc2f..4f7213af1955 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > @@ -1937,8 +1937,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
> >  		xdp_active = true;
> >  	}
> >  
> > -	/* skip running XDP prog if there are aggregation bufs */
> > -	if (!agg_bufs && xdp_active) {
> > +	if (xdp_active) {
> >  		if (bnxt_rx_xdp(bp, rxr, cons, xdp, data, &len, event)) {
> >  			rc = 1;
> >  			goto next_rx;
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> > index adbd92971209..3780b491a1d4 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> > @@ -374,11 +374,6 @@ static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
> >  	int tx_xdp = 0, rc, tc;
> >  	struct bpf_prog *old;
> >  
> > -	if (prog && bp->dev->mtu > BNXT_MAX_PAGE_MODE_MTU) {
> 
> This seems to be missing taking prog->aux->xdp_has_frags into account.
> 

Thanks for the review!  I've sent Michael an updated patch and we should be
able to get a v3 out this morning to cover this.

> > -		netdev_warn(dev, "MTU %d larger than largest XDP supported MTU %d.\n",
> > -			    bp->dev->mtu, BNXT_MAX_PAGE_MODE_MTU);
> > -		return -EOPNOTSUPP;
> > -	}
> >  	if (!(bp->flags & BNXT_FLAG_SHARED_RINGS)) {
> >  		netdev_warn(dev, "ethtool rx/tx channels must be combined to support XDP.\n");
> >  		return -EOPNOTSUPP;
> 

--000000000000bc6bd305dacc0cf7
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVkwggRBoAMCAQICDBPdG+g0KtOPKKsBCTANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxNDAyMzhaFw0yMjA5MjIxNDExNTVaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGDAWBgNVBAMTD0FuZHkgR29zcG9kYXJlazEtMCsGCSqGSIb3
DQEJARYeYW5kcmV3Lmdvc3BvZGFyZWtAYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAp9JFtMqwgpbnvA3lNVCpnR5ehv0kWK9zMpw2VWslbEZq4WxlXr1zZLZEFo9Y
rdIZ0jlxwJ4QGYCvxE093p9easqc7NMemeMg7JpF63hhjCksrGnsxb6jCVUreXPSpBDD0cjaE409
9yo/J5OQORNPelDd4Ihod6g0XlcxOLtlTk1F0SOODSjBZvaDm0zteqiVZb+7xgle3NOSZm3kiCby
iRuyS0gMTdQN3gdgwal9iC3cSXHMZFBXyQz+JGSHomhPC66L6j4t6dUqSTdSP07wg38ZPV6ct/Sv
/O2HcK+E/yYkdMXrDBgcOelO4t8AYHhmedCIvFVp4pFb2oit9tBuFQIDAQABo4IB3zCCAdswDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDApBgNVHREEIjAggR5hbmRyZXcuZ29zcG9kYXJla0Bicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYI
KwYBBQUHAwQwHwYDVR0jBBgwFoAUljPR5lgXWzR1ioFWZNW+SN6hj88wHQYDVR0OBBYEFKARn7Ud
RlGu+rBdUDirYE+Ee4TeMA0GCSqGSIb3DQEBCwUAA4IBAQAcWqh4fdwhDN0+MKyH7Mj0vS10E7xg
mDetQhQ+twwKk5qPe3tJXrjD/NyZzrUgguNaE+X97jRsEbszO7BqdnM0j5vLDOmzb7d6qeNluJvk
OYyzItlqZk9cJPoP9sD8w3lr2GRcajj5JCKV4pd2PX/i7r30Qco0VnloXpiesFmNTXQqD6lguUyn
nb7IGM3v/Nb7NTFH8/KUVg33xw829ztuGrOvfrHfBbeVcUoOHEHObXoaofYOJjtmSOQdMeJIiBgP
XEpJG8/HB8t4FF6A8W++4cHhv0+ayyEnznrbOCn6WUmIvV2WiJymRpvRG7Hhdlk0zA97MRpqK5yn
ai3dQ6VvMYICbTCCAmkCAQEwazBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBu
di1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMgUGVyc29uYWxTaWduIDIgQ0EgMjAyMAIM
E90b6DQq048oqwEJMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCBYKlkMK8zO2MaW
UxJwq978ehhunOIw1nQ+jGTE2zKykjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0yMjAzMjIxMDI2NDVaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCG
SAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEB
BzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAMUp/0vhRCXGHrxvESAY7/aFwdi6TXHWt
S2AaIc5ktzrBIxOLla6YWNLWRWNFk00sj0yUKFfLyN83ngs+y2D+4/OV2qFa3QzTTjUnJiMGGj0Q
W+7FFTD5PkizuQBULWgyrFN2WfTJDKX2qMPX42zh/qQLdBcW7llhNvt3uxDZfPjHNtj6D7+duJcl
vkDicNU3ue4IlAzSzKkwuUt4cBjuetQ1PmillbAKLcARWxmz9nqVOLNvEK98gI7js/Lbp8LC/dW7
Jr5vPpCKpLqAUcO4YrQpUnamA1H45PypE9pmBaYgBQV6wlD4upagBMJDibU6JrwU5Epw33E+9yyU
S1TXow==
--000000000000bc6bd305dacc0cf7--
