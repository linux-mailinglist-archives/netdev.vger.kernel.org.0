Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35B9628EA7
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 01:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237380AbiKOArx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 19:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237069AbiKOArv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 19:47:51 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9E71D646
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 16:47:49 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id b29so12621254pfp.13
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 16:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5EnAueiTnQeXAH4QHon2v3Qq5CD3Mwx/ZDcgozrLBkw=;
        b=BuvxUxt6RzHkNzuuMeVecAMB4e4AVGP9H/P3ux5M3wVynm4+ViRPwoQsgB62wKgjGZ
         T1Jvg+d+JTu382CHRW2IbUYygyf/nS5MQ9oxTHz/NbLff07fg0z8lfbRnprIZJdqyJWf
         kDNxG27CKrv+seT599a0odi1gN+/DJf9tWnSU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5EnAueiTnQeXAH4QHon2v3Qq5CD3Mwx/ZDcgozrLBkw=;
        b=piZZCuKGaEuCF7tREVJosuxB+9L2cPWAySMNj33fR/XK9EIJ5VdlUoH4ZGiRbb9v4/
         GKwNTYZwIjTNTGyrROSZ2IV6be/zG82mFFoRH+oJ3you4tx1uV7OT/9AHt3fPWyAYcQJ
         XE4Nj9ov8cl3vAQyxZEcVoXyqcH85G+UHlINV24FNNLrAOP7RWvpYZHK4is2cHoq3VU1
         heGd59TnnP2Rjs9xJBJcXzbD51udDh33zKE4QWxGrMejYTeQLV0eeNBQRDbrhVsBl1u1
         EtnhIdGiz4AS/aWKOv5LkI33is5iwRPB8lsJcGjfsZxy/qiHhAYGZkDAIxZSWfdYSwKk
         HomA==
X-Gm-Message-State: ANoB5pkoER0WYbNS/pQ8qfq1FwO4aFJqo6YqNJK4hUwKfS1aFc10eiiM
        lrtbiIREk4cBcW864P15p6hNL0GUx7cA+IZucTPNew==
X-Google-Smtp-Source: AA0mqf7owQZoevPTTU+xDStBSgPJ8JVWN7i6YXwx31PQwbPAHiS60nGYn9jyVrBNbfjAUBmsBNPmc18Xg6ysXRehi/M=
X-Received: by 2002:a05:6a00:c8b:b0:56e:d7f4:3c49 with SMTP id
 a11-20020a056a000c8b00b0056ed7f43c49mr16085745pfv.50.1668473268532; Mon, 14
 Nov 2022 16:47:48 -0800 (PST)
MIME-Version: 1.0
References: <20221109184244.7032-1-ajit.khaparde@broadcom.com> <Y2zYPOUKgoArq7mM@unreal>
In-Reply-To: <Y2zYPOUKgoArq7mM@unreal>
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
Date:   Mon, 14 Nov 2022 16:47:31 -0800
Message-ID: <CACZ4nhu_2FoOTmXPuq+amRYAipusq1XcobavytN0cFK=TSE5mQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] Add Auxiliary driver support
To:     Leon Romanovsky <leon@kernel.org>
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000082434005ed77b4fc"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000082434005ed77b4fc
Content-Type: text/plain; charset="UTF-8"

Leon,
We appreciate your valuable feedback.
Please see inline.

On Thu, Nov 10, 2022 at 2:53 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Wed, Nov 09, 2022 at 10:42:38AM -0800, Ajit Khaparde wrote:
> > Add auxiliary device driver for Broadcom devices.
> > The bnxt_en driver will register and initialize an aux device
> > if RDMA is enabled in the underlying device.
> > The bnxt_re driver will then probe and initialize the
> > RoCE interfaces with the infiniband stack.
> >
> > We got rid of the bnxt_en_ops which the bnxt_re driver used to
> > communicate with bnxt_en.
> > Similarly  We have tried to clean up most of the bnxt_ulp_ops.
> > In most of the cases we used the functions and entry points provided
> > by the auxiliary bus driver framework.
> > And now these are the minimal functions needed to support the functionality.
> >
> > We will try to work on getting rid of the remaining if we find any
> > other viable option in future.
>
> I still see extra checks for something that was already checked in upper
> functions, for example in bnxt_re_register_netdev() you check rdev, which
> you already checked before.
Sure. I will do another sweep and clean up.

>
> However, the most important part is still existence of bnxt_ulp_ops,
> which shows completely no-go thing - SR-IOV config in RDMA code.
>
>    302 static struct bnxt_ulp_ops bnxt_re_ulp_ops = {
>    303         .ulp_sriov_config = bnxt_re_sriov_config,
>    304         .ulp_irq_stop = bnxt_re_stop_irq,
>    305         .ulp_irq_restart = bnxt_re_start_irq
>    306 };
>
> All PCI management logic and interfaces are needed to be inside eth part
> of your driver and only that part should implement SR-IOV config. Once
> user enabled SR-IOV, the PCI driver should create auxiliary devices for
> each VF. These device will have RDMA capabilities and it will trigger RDMA
> driver to bind to them.
I agree and once the PF creates the auxiliary devices for the VF, the RoCE
Vf indeed get probed and created. But the twist in bnxt_en/bnxt_re
design is that
the RoCE driver is responsible for making adjustments to the RoCE resources.

So once the VF's are created and the bnxt_en driver enables SRIOV adjusts the
NIC resources for the VF,  and such, it tries to call into the bnxt_re
driver for the
same purpose.

1. We do something like this to the auxiliary_device structure:

diff --git a/include/linux/auxiliary_bus.h b/include/linux/auxiliary_bus.h
index de21d9d24a95..4e581fbf458f 100644
--- a/include/linux/auxiliary_bus.h
+++ b/include/linux/auxiliary_bus.h
@@ -148,6 +148,7 @@ struct auxiliary_device {
  * @shutdown: Called at shut-down time to quiesce the device.
  * @suspend: Called to put the device to sleep mode. Usually to a power state.
  * @resume: Called to bring a device from sleep mode.
+ * @sriov_configure: Called to allow configuration of VFs .
  * @name: Driver name.
  * @driver: Core driver structure.
  * @id_table: Table of devices this driver should match on the bus.
@@ -183,6 +184,7 @@ struct auxiliary_driver {
        void (*shutdown)(struct auxiliary_device *auxdev);
        int (*suspend)(struct auxiliary_device *auxdev, pm_message_t state);
        int (*resume)(struct auxiliary_device *auxdev);
+       int (*sriov_configure)(struct auxiliary_device *auxdev, int
num_vfs); /* On PF */
        const char *name;
        struct device_driver driver;
        const struct auxiliary_device_id *id_table;

Then the bnxt_en driver could call into bnxt_re via that interface.

Please let me know what you feel.

2. While it may take care of the first function in the ulp_ops, it
leaves us with two.
And that is where I will need some input if we need to absolutely get
rid of the ops.

2a. We may be able to use the auxiliary_device suspend & resume with a
private flag
in the driver's aux_dev pointer.
2b. Or just like (1) above, add another hook to auxiliary_driver
void (*restart)(struct auxiliary_device *auxdev);
And then use the auxiliary_driver shutdown & restart with a private flag.

Note that we may get creative right now and get rid of the ulp_ops.
But the bnxt_en driver having a need to update the bnxt_re driver is a
part of the
design. So it will help if we can consider beyond the ulp_irq_stop,
ulp_irq_restart.
2c. Maybe keep the bnxt_ulp_ops for that reason?

Thank you for your time.

Thanks
Ajit

>
> Thanks

--00000000000082434005ed77b4fc
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
pZEyqKnwS1lKCzjX7mV5W955rFsFxChdAKfw0HilwtqdY24mhy62+GeaEkD0gYIj1tCmw9gnQToc
K+0s7xEunfR9pBrzmOwS3OQbcP0nJ8SmQ8R+reroH6LYuFpaqK1rgQIDAQABo4IB2zCCAdcwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAlBgNVHREEHjAcgRphaml0LmtoYXBhcmRlQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUbrcTuh0mr2qP
xYdtyDgFeRIiE/gwDQYJKoZIhvcNAQELBQADggEBALrc1TljKrDhXicOaZlzIQyqOEkKAZ324i8X
OwzA0n2EcPGmMZvgARurvanSLD3mLeeuyq1feCcjfGM1CJFh4+EY7EkbFbpVPOIdstSBhbnAJnOl
aC/q0wTndKoC/xXBhXOZB8YL/Zq4ZclQLMUO6xi/fFRyHviI5/IrosdrpniXFJ9ukJoOXtvdrEF+
KlMYg/Deg9xo3wddCqQIsztHSkR4XaANdn+dbLRQpctZ13BY1lim4uz5bYn3M0IxyZWkQ1JuPHCK
aRJv0SfR88PoI4RB7NCEHqFwARTj1KvFPQi8pK/YISFydZYbZrxQdyWDidqm4wSuJfpE6i0cWvCd
u50xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwM2Vrj
4nZK0WWosNswDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILMn68UJU4SjJ5mkWWum
V5u1HdaJhWwtmyr5Et4elC/dMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMTExNTAwNDc0OFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAo5oNmDgiol2bdfYr17dme64p+/TABvoVYgCXu
VkVoLrb6TiPWEkI+m/AK0LM/sAVNuG0083XcQpukT0ygKMdBAXmqPEySKhrWgGeBfeXkSzCzaYq2
z/VOAwLyFQtxmzDlwi81do0jO6vTqlptXf93ekrI6C2Za7/y1eJTnjsHMAuNiFX8ZoBqDh5jZ52R
PHpOv9KQ4++uyAaJ6PeK42yinFH/FtB0JdRQ6rUeF+QiiaqIWokN6ny09f1IyBbcpRb124GLm+Rb
dRvn1wecliePmBKwCkuNMAoF48xlbSQnppIBo104lDVi/9mXu10pf1BgEYPWgsLR18RvrQcsKPxr
--00000000000082434005ed77b4fc--
