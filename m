Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5646C5F2411
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 18:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiJBQVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 12:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiJBQVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 12:21:24 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C402E6AC
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 09:21:23 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id u21so2665121pfc.13
        for <netdev@vger.kernel.org>; Sun, 02 Oct 2022 09:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=QX0PqE0LS4vDU0sO14SwImYrkDL8hR/Rav9S02jLgEk=;
        b=XQAOXp/RxHoJTSjKgAL98ZyS3VnyZaz5eK+qtM179XRavkckqykQLftA2BdXA9Dr7I
         Ex2G31fxfR6nDwqW/gUJjLBZ5llU0qkHIozZE7osAhPKXpy22o0WJdpK42NlPbZV1e74
         5XpKFZq0DvYqz7AvdOWVVoA4WVmK1RfnKC/z4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=QX0PqE0LS4vDU0sO14SwImYrkDL8hR/Rav9S02jLgEk=;
        b=zNr/XlwUCygjaxP0RUvhLNNU+e9NHt4uTvp8QrWw3xJGlI5F2+YG0lZN3bqCxc5+qI
         /OJXHX1daWU7p2QuM8fZKSp5hLo56SAiWks+Wf/d9F+zL8BExLHoCwHZXYmxh/6F1wqZ
         qLUvG2pFBeoGS2x/EO4gwSJV7IG0uBa6NjLwGbNOWwE6Fby+ai9qF9dxwRpR+Q0vXlng
         pWbWKH0R1Ga3a8nI2WXFZn6jpMAkV111W8guTBQh3dKi4XRuE7D91NHSIbvrY8DvF6ma
         39kpBbJEj844Qa9QdxW+Bbgqkme1UqkDGHAjfWREk/+oans4Ksl3eeQFFNFYkwlKMWbG
         N2XQ==
X-Gm-Message-State: ACrzQf0ZJfwj63Yx5FQxzVBgGFACBjuF61UfHC6PBooQcGZzrkrdkwPI
        Bq1wneSs2T7ixFsIrJmacS9uCPwSiRlpjM+VCqDAug==
X-Google-Smtp-Source: AMsMyM5jAufSSTzIidV29Pqae8IReKpUYDaVxk+KdsGgaAxnfVPi0RpJ+sCzaWUrk4x5lvPFi4XTuOoCI8n+FJMch4M=
X-Received: by 2002:a63:515d:0:b0:42a:cf33:4320 with SMTP id
 r29-20020a63515d000000b0042acf334320mr15063841pgl.21.1664727682706; Sun, 02
 Oct 2022 09:21:22 -0700 (PDT)
MIME-Version: 1.0
References: <1664648831-7965-1-git-send-email-michael.chan@broadcom.com>
 <1664648831-7965-3-git-send-email-michael.chan@broadcom.com> <YzmvdxQpWviawxuj@shredder>
In-Reply-To: <YzmvdxQpWviawxuj@shredder>
From:   Vikas Gupta <vikas.gupta@broadcom.com>
Date:   Sun, 2 Oct 2022 21:51:10 +0530
Message-ID: <CAHLZf_sEB=dR2skpVuTD-r=SW4ZF9aOUKuNxibrjAKFe=v5+=Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] bnxt_en: add .get_module_eeprom_by_page() support
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, gospo@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003302ca05ea0f9ecf"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000003302ca05ea0f9ecf
Content-Type: text/plain; charset="UTF-8"

Hi Ido,


On Sun, Oct 2, 2022 at 9:04 PM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Sat, Oct 01, 2022 at 02:27:10PM -0400, Michael Chan wrote:
> > +static int bnxt_get_module_eeprom_by_page(struct net_device *dev,
> > +                                       const struct ethtool_module_eeprom *page_data,
> > +                                       struct netlink_ext_ack *extack)
> > +{
> > +     struct bnxt *bp = netdev_priv(dev);
> > +     int rc;
> > +
> > +     if (bp->link_info.module_status >
> > +         PORT_PHY_QCFG_RESP_MODULE_STATUS_WARNINGMSG) {
> > +             NL_SET_ERR_MSG_MOD(extack, "Phy status unknown");
>
> Can you make this more helpful to users? The comment above this check in
> bnxt_get_module_info() suggests that it is possible:

Do you mean that we should elaborate something like
NL_SET_ERR_MSG_MOD(extack, "Module may be not inserted or powered down
or 10G Base-T");

>
> /* No point in going further if phy status indicates
>  * module is not inserted or if it is powered down or
>  * if it is of type 10GBase-T
>  */
> if (bp->link_info.module_status >
>         PORT_PHY_QCFG_RESP_MODULE_STATUS_WARNINGMSG)
>
> > +             return -EIO;
> > +     }
> > +
> > +     if (bp->hwrm_spec_code < 0x10202) {
> > +             NL_SET_ERR_MSG_MOD(extack, "Unsupported hwrm spec");
>
> Likewise. As a user I do not know what "hwrm spec" means... Maybe:
>
> NL_SET_ERR_MSG_MOD(extack, "Firmware version too old");
>
>
> > +             return -EOPNOTSUPP;
> > +     }
> > +
> > +     if (page_data->bank && !(bp->phy_flags & BNXT_PHY_FL_BANK_SEL)) {
> > +             NL_SET_ERR_MSG_MOD(extack, "Firmware not capable for bank selection");
> > +             return -EOPNOTSUPP;
>
> What happens if you have an old firmware that does not support this
> functionality and user space tries to dump page 10h from bank 1 of a
> CMIS module that supports multiple banks?
>
> I wanted to say that you would see the wrong information (from bank 0)
> because the legacy operations do not support banks and bank 0 is
> assumed. However, because only pages 10h-ffh are banked, user space will
> get an error from the following check in fallback_set_params():
>
> if (request->page)
>         offset = request->page * ETH_MODULE_EEPROM_PAGE_LEN + offset;
>
> [...]
>
> if (offset >= modinfo->eeprom_len)
>         return -EINVAL;
>
> I believe it makes sense to be more explicit about it and return an
> error in fallback_set_params() in case bank is not 0. Please follow up
> if the above analysis is correct.

So older firmware do not understand bank > 0 and hence it returns to
EOPNOTSUPP, which goes to fallback_set_params() and fails for
if (offset >= modinfo->eeprom_len)
        return -EINVAL
As we are not setting modinfo->eeprom_len for CMIS modules in get_module_eeprom.
With the above said userspace gets EINVAL.
Let me know if my understanding is correct?

Thanks,
Vikas

>
> > +     }
> > +
> > +     rc = bnxt_read_sfp_module_eeprom_info(bp, page_data->i2c_address << 1,
>
> I was wondering why the shift is needed, but I see that in other places
> you are passing 0xA0 and 0xA2 instead of 0x50 and 0x51, so it is OK.
>
> > +                                           page_data->page, page_data->bank,
> > +                                           page_data->offset,
> > +                                           page_data->length,
> > +                                           page_data->data);
> > +     if (rc) {
> > +             NL_SET_ERR_MSG_MOD(extack, "Module`s eeprom read failed");
> > +             return rc;
> > +     }
> > +     return page_data->length;
> > +}
>
> Looks good otherwise.
>
> Thanks

--0000000000003302ca05ea0f9ecf
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
1Z53HzleM75CAMHDl8NYGve9BgWmJRrMksHjn8TcXwOoXQ4QkkBXnMc3Gl+XSbAXXNw1oU96EW5r
k0vJWVnbznBdI0eiFVP+mokagWcF65WhrJr1gzlBAgMBAAGjggHZMIIB1TAOBgNVHQ8BAf8EBAMC
BaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJlLmdsb2JhbHNp
Z24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYIKwYBBQUHMAGG
NWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwME0G
A1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
aWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqGOGh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3JsMCMGA1UdEQQc
MBqBGHZpa2FzLmd1cHRhQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSME
GDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUQUO4R8Bg/yLjD8B1Jr9JLitNMlIw
DQYJKoZIhvcNAQELBQADggEBACj8NkM/SQOdFy4b+Kn9Q/IE8KHCkf/qubyurG45FhIIv8eUflaW
ZkYiC3z+qo7iXxFvNJ4irfvMtG+idVVrOEFa56FKvixdXk2mlzsojV7lNPlVtn8X2mry47rVMq0G
AQPU6HuihzH/SrKdypyxv+4QqSGpLs587FN3ydGrrw8J96rBt0qqzFMt65etOx73KyU/LylBqQ+6
oCSF3t69LpmLmIwRkXxtqIrB7m9OjROeMnXWS9+b5krW8rnUbgqiJVvWldgtno3kiKdEwnOwVjY+
gZdPq7+WE2Otw7O0i1ReJKwnmWksFwr/sT4LYfFlJwA0LlYRHmhR+lhz9jj0iXkxggJtMIICaQIB
ATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhH
bG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwMFhgQqM5emFpsS5wwDQYJ
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDr0ufUirNiAeb8BrhJ0BL83jsN2OaXsaK/+
+0tXGWtIMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTAwMjE2
MjEyM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQAGTUoskw+TVWezCyWY4n8H2X9SdoUImzkRWPrCpQ4APLzgyW+Pd9ig
tIiccY+qWLFH5hBQVOrl5gq23+BRUkUYkCxgc2PCHuYMfv/78BA7fiieDv0kKnnORL6Hi94pzyw2
q7X1cmaMCM+pQWrf7H8Fj8vMoyqQfy9/FUmaWP7sOQg/wxsSGOqZ5+rT8+fG3PrWHOFUYxQWRCzA
3u89a1MveNqmb8xxmOj52xMNim4LH1p5yLc4jjy33JjgLGS1xNjvU4DW7Wo5y1FMKN0DlMABXI3T
vX3N3fuQfJ625995Yn78GX7qZ+7icCW6ZyiJ6NplynIRsaROmSbzSg5W1Cf6
--0000000000003302ca05ea0f9ecf--
