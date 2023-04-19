Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EFF6E7771
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 12:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbjDSKa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 06:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbjDSKae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 06:30:34 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400C45B81
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 03:30:32 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-52160b73bdfso36399a12.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 03:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1681900231; x=1684492231;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6gy/euricSNF+aLRTnRcmsEVzEjDTSXwKPU4BP/eHUw=;
        b=SnnqXOrUslqmW/oLfzu0EX5MtZZmVeaZtUf6aCFnPtyOxuGWtx9iul41m5RvR2eoKi
         mQIZtusO6lZywwMtQUO/VkzfB2WqR7ZhERvzAP9vR4jQ25tSQPn70OGqTualKDcMixT9
         hc0ES0jIWvbk9Hq4rHhYPk9AYzHly4PC5pCeA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681900231; x=1684492231;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6gy/euricSNF+aLRTnRcmsEVzEjDTSXwKPU4BP/eHUw=;
        b=ebu2W2Rmfj9UobCKn6JNMrauX4hPOpeutoTE7lxHhys9A4Ezj4DsPpLpKTvHAcVl5l
         VmrvO0vP4FIy9aVuUdxeoQdqBQfLOdP8tQRXU2p1NBA5+ncxK1H9DZMfWlKi1l3WJph8
         62mR6Y5VjmQ3Wl2601FCe3CVRdmvyf5k/8zfM7sVVhOd8+Akf7DTQLUcE0Vrm5iPLtEw
         zg4ZGUJyY39eU8ln6Bzwfugjvl6vRAOqJqcMRG1jPAXOslVxGgc8pWNkHxqaeGlme7mY
         to6D+MRIKk6EcNTuFV9Ri1p0QtVJgwkyqN7/ChHsFuB3ER75zMJwsz28kokcnulqM4+q
         puIA==
X-Gm-Message-State: AAQBX9fADs8ZkFM5q1FGup98EtPOefmQNA3DmktOmtzIxMKn5EUPa9XE
        aC8z08sj0J7WDJckSkIv/79QG9sI3dxj7bFuR4EzfleBb9hKEjGe
X-Google-Smtp-Source: AKy350aTW929i0Yrm1SYOsPz1OgTCoTScb/Cs0Os6x+IuQ94Nrgeuet666TylTcR+RFSwR10cIv0CJZOLa183OrzE5k=
X-Received: by 2002:a17:90a:d787:b0:23f:58a2:7d86 with SMTP id
 z7-20020a17090ad78700b0023f58a27d86mr2577015pju.10.1681900231335; Wed, 19 Apr
 2023 03:30:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230418221313.39112-1-alexberliner@google.com>
In-Reply-To: <20230418221313.39112-1-alexberliner@google.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Wed, 19 Apr 2023 16:00:19 +0530
Message-ID: <CALs4sv3s4bA7E5FV2GrCZb7m_0rs5AXjOXO7p-GqKvMudi_dNA@mail.gmail.com>
Subject: Re: [PATCH net-next] gve: Add modify ring size support
To:     Alex Berliner <alexberliner@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000dfb46b05f9ade9c6"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000dfb46b05f9ade9c6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 3:45=E2=80=AFAM Alex Berliner <alexberliner@google.=
com> wrote:
>
> +static int gve_set_ringparam(struct net_device *netdev,
> +                            struct ethtool_ringparam *cmd,
> +                            struct kernel_ethtool_ringparam *kernel_cmd,
> +                            struct netlink_ext_ack *extack)
> +{
> +       struct gve_priv *priv =3D netdev_priv(netdev);
> +       int old_rx_desc_cnt =3D priv->rx_desc_cnt;
> +       int old_tx_desc_cnt =3D priv->tx_desc_cnt;
> +       int new_tx_desc_cnt =3D cmd->tx_pending;
> +       int new_rx_desc_cnt =3D cmd->rx_pending;
> +       int new_max_registered_pages =3D
> +               new_rx_desc_cnt * gve_num_rx_qpls(priv) +
> +                       GVE_TX_PAGE_COUNT * gve_num_tx_qpls(priv);
> +
> +       if (!priv->modify_ringsize_enabled) {
> +               dev_err(&priv->pdev->dev, "Modify ringsize disabled\n");
> +               return -EINVAL;
> +       }
> +
> +       if (new_tx_desc_cnt < GVE_RING_LENGTH_LIMIT_MIN ||
> +               new_rx_desc_cnt < GVE_RING_LENGTH_LIMIT_MIN) {
> +               dev_err(&priv->pdev->dev, "Ring size cannot be less than =
%d\n",
> +                       GVE_RING_LENGTH_LIMIT_MIN);
> +               return -EINVAL;
> +       }
> +
> +       if (new_tx_desc_cnt > GVE_RING_LENGTH_LIMIT_MAX ||
> +               new_rx_desc_cnt > GVE_RING_LENGTH_LIMIT_MAX) {
> +               dev_err(&priv->pdev->dev,
> +                       "Ring size cannot be greater than %d\n",
> +                       GVE_RING_LENGTH_LIMIT_MAX);
> +               return -EINVAL;
> +       }
> +
> +       /* Ring size must be a power of 2, will fail if passed values are=
 not
> +        * In the future we may want to update to round down to the
> +        * closest valid ring size
> +        */
> +       if ((new_tx_desc_cnt & (new_tx_desc_cnt - 1)) !=3D 0 ||
> +               (new_rx_desc_cnt & (new_rx_desc_cnt - 1)) !=3D 0) {
> +               dev_err(&priv->pdev->dev, "Ring size must be a power of 2=
\n");
> +               return -EINVAL;
> +       }
> +
> +       if (new_tx_desc_cnt > priv->max_tx_desc_cnt) {
> +               dev_err(&priv->pdev->dev,
> +                       "Tx ring size passed %d is larger than max tx rin=
g size %u\n",
> +                       new_tx_desc_cnt, priv->max_tx_desc_cnt);
> +               return -EINVAL;
> +       }
> +
> +       if (new_rx_desc_cnt > priv->max_rx_desc_cnt) {
> +               dev_err(&priv->pdev->dev,
> +                       "Rx ring size passed %d is larger than max rx rin=
g size %u\n",
> +                       new_rx_desc_cnt, priv->max_rx_desc_cnt);
> +               return -EINVAL;
> +       }
> +
> +       if (new_max_registered_pages > priv->max_registered_pages) {
> +               dev_err(&priv->pdev->dev,
> +                               "Allocating too many pages %d; max %llu",
> +                               new_max_registered_pages,
> +                               priv->max_registered_pages);
> +               return -EINVAL;
> +       }
> +
> +       // Nothing to change return success

I think we should have /* */ comments?
Also, as is evident from the checkpatch report, the alignment of the
parenthesis needs to be fixed.

> +       if (new_tx_desc_cnt =3D=3D old_tx_desc_cnt && new_rx_desc_cnt =3D=
=3D old_rx_desc_cnt)
> +               return 0;

Having this condition right at the beginning can avoid unnecessary checks?

> +
> +       return gve_adjust_ring_sizes(priv, new_tx_desc_cnt, new_rx_desc_c=
nt);
> +}
> --
> 2.40.0.634.g4ca3ef3211-goog
>

--000000000000dfb46b05f9ade9c6
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
OltyqaGBuzv+bJTUL+bmV7E4QBLIqGt4jVr1R9hJdH6KxXwJdyfHZ9C6qXmoe2NQhiFUyBOJ0wgk
dB9Z1IU7nCwvNKYg2JMoJs93tIgbhPJg/D7pqW8gabkCAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcGF2YW4uY2hlYmJpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUEV6y/89alKPoFbKUaJXsvWu5
fdowDQYJKoZIhvcNAQELBQADggEBAEHSIB6g652wVb+r2YCmfHW47Jo+5TuCBD99Hla8PYhaWGkd
9HIyD3NPhb6Vb6vtMWJW4MFGQF42xYRrAS4LZj072DuMotr79rI09pbOiWg0FlRRFt6R9vgUgebu
pWSH7kmwVXcPtY94XSMMak4b7RSKig2mKbHDpD4bC7eGlwl5RxzYkgrHtMNRmHmQor5Nvqe52cFJ
25Azqtwvjt5nbrEd81iBmboNTEnLaKuxbbCtLaMEP8xKeDjAKnNOqHUMps0AsQT8c0EGq39YHpjp
Wn1l67VU0rMShbEFsiUf9WYgE677oinpdm0t2mdCjxr35tryxptoTZXKHDxr/Yy6l6ExggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwV/XkICjVscn4SNZMw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIALEkPOrr3W0dj+Si/VdKpEq0fwYNMn2
/ldrAncn/RDuMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDQx
OTEwMzAzMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBqw1i4uq8EKVJoUvVTJApOVBC3XfEqZ9x0pWGaT9aV69tAaJhV
r2lasNqCdX5kIrkt6wuO+8Tn/ZhMiTCY5noUbPkGXPiaGG9cwQToQELc/2awGe3MNojw72W5vTfU
74L4D2eYx5Cg/Os+3+JJJ9BXljprtFGIYA5A2neazt2UwgMdmeg1yL+AYuUdcDReAtI0DorQVMjb
YmlqIwk4lsYyzw6tM1oM51020438qpCOcKEVfLh9z0i1kIEd6szXFv9gokFS56uwyNGjIGd7xIv5
69hlsadrZbIH78VmVbjfNDO9ir2ZWLoR3SADW+fK2HXLxthJZOHYW/oZ3n44GokW
--000000000000dfb46b05f9ade9c6--
