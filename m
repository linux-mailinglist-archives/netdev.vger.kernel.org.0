Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262585F2D11
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiJCJZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiJCJZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:25:29 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210291F9CE
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 02:25:26 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id q99-20020a17090a1b6c00b0020ac0368d64so136160pjq.3
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 02:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=iyjGpAK8Ag7nxRPUDBG11jiAQ+26SrjjisuAml0/vcg=;
        b=PR4ZcqWAjXsDEaR4VFBe4IWr6RdSDlNRVOpCQlrPvBJnCeQldspjPqtzDdcN4LE+sy
         l6gqJeBHRV5HkIRWcNNdUQzSJyju84fLQS+HZ8CNgiMtIxcUktNRYuzCBMYpHh61ee1f
         iph5vAll5NFsgELrBoivyY1C8OSv4YGBXNESI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=iyjGpAK8Ag7nxRPUDBG11jiAQ+26SrjjisuAml0/vcg=;
        b=0ZQ3EEXvrhY/KhY67ZgzoKjPfAZmAIgiJuizF53f5DO3eUz4VnvuXjmhYLp9Ozv7IJ
         ixkVvUb7chTt+aDLzyLjcraFnEPryoiynBA5rTXhevzpO26s12xZamlMLQ9UzJcEgWFR
         NhnP7PEP5dMuacDExK0L0wt4tPd8ctLtuzY9n9VwUW4zRn8rGjCOCeEi1wgSvf6NJncy
         NVoINEU25Hjy1gLCgwYOz4ugOufciUd5g3fZTPqogvftwdBVKjPVJ3KbVRdJcpkM/FNF
         HDCljPhHwnMcNeW+Sb1/vJk1TQqBdUEpjJxuv/OLUp5FhihRBjmiawGCHymCUq+PRpom
         aqpQ==
X-Gm-Message-State: ACrzQf364Y4ThXGUkBcnPwEV/onORCkgnfsqCxBnq0Yv1T7nBn8SVlLa
        bkux1mVKAyjFo8yZJ0A6F54c+4Oh7v9jJhiRozaDBg==
X-Google-Smtp-Source: AMsMyM7BuSpkEGFYex1L11h0IKKmw+m9H+ZjELUBcpn7YL6woNXobeDcfkponH4uBe+gNiyERQWM2MD9eg0IZ93G2BY=
X-Received: by 2002:a17:903:124b:b0:179:da2f:2457 with SMTP id
 u11-20020a170903124b00b00179da2f2457mr21081686plh.156.1664789125424; Mon, 03
 Oct 2022 02:25:25 -0700 (PDT)
MIME-Version: 1.0
References: <1664648831-7965-1-git-send-email-michael.chan@broadcom.com>
 <1664648831-7965-3-git-send-email-michael.chan@broadcom.com>
 <YzmvdxQpWviawxuj@shredder> <CAHLZf_sEB=dR2skpVuTD-r=SW4ZF9aOUKuNxibrjAKFe=v5+=Q@mail.gmail.com>
 <YzqNEc6biKKrfugK@shredder>
In-Reply-To: <YzqNEc6biKKrfugK@shredder>
From:   Vikas Gupta <vikas.gupta@broadcom.com>
Date:   Mon, 3 Oct 2022 14:55:13 +0530
Message-ID: <CAHLZf_tE-fUz2wmaA8=GeqfZMev3Br1M6A316ZJL=CB_KdZxew@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] bnxt_en: add .get_module_eeprom_by_page() support
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, gospo@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000079310605ea1dec35"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000079310605ea1dec35
Content-Type: text/plain; charset="UTF-8"

Hi Ido,

On Mon, Oct 3, 2022 at 12:49 PM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Sun, Oct 02, 2022 at 09:51:10PM +0530, Vikas Gupta wrote:
> > On Sun, Oct 2, 2022 at 9:04 PM Ido Schimmel <idosch@idosch.org> wrote:
> > >
> > > On Sat, Oct 01, 2022 at 02:27:10PM -0400, Michael Chan wrote:
> > > > +static int bnxt_get_module_eeprom_by_page(struct net_device *dev,
> > > > +                                       const struct ethtool_module_eeprom *page_data,
> > > > +                                       struct netlink_ext_ack *extack)
> > > > +{
> > > > +     struct bnxt *bp = netdev_priv(dev);
> > > > +     int rc;
> > > > +
> > > > +     if (bp->link_info.module_status >
> > > > +         PORT_PHY_QCFG_RESP_MODULE_STATUS_WARNINGMSG) {
> > > > +             NL_SET_ERR_MSG_MOD(extack, "Phy status unknown");
> > >
> > > Can you make this more helpful to users? The comment above this check in
> > > bnxt_get_module_info() suggests that it is possible:
> >
> > Do you mean that we should elaborate something like
> > NL_SET_ERR_MSG_MOD(extack, "Module may be not inserted or powered down
> > or 10G Base-T");
>
> Yes, but even then the exact error is unknown and you would need
> something like drgn / kprobes to retrieve the specific module_state for
> debug. You can do something like the following (in a separate function):
>
> if (bp->link_info.module_status <=
>     PORT_PHY_QCFG_RESP_MODULE_STATUS_WARNINGMSG)
>         return 0;
>
> switch (bp->link_info.module_status) {
> case PORT_PHY_QCFG_RESP_MODULE_STATUS_PWRDOWN:
>         NL_SET_ERR_MSG_MOD(extack, "Transceiver module is powering down");
>         break;
> case PORT_PHY_QCFG_RESP_MODULE_STATUS_NOTINSERTED:
>         NL_SET_ERR_MSG_MOD(extack, "Transceiver module not inserted");
>         break;
> case PORT_PHY_QCFG_RESP_MODULE_STATUS_CURRENTFAULT:
>         NL_SET_ERR_MSG_MOD(extack, "... something that explains what this means ...");
>         break;
> default:
>         NL_SET_ERR_MSG_MOD(extack, "Unknown error");
>         break;
> }

We`ll try to provide more appropriate information above.

>
> return -EINVAL;
>
> >
> > >
> > > /* No point in going further if phy status indicates
> > >  * module is not inserted or if it is powered down or
> > >  * if it is of type 10GBase-T
> > >  */
> > > if (bp->link_info.module_status >
> > >         PORT_PHY_QCFG_RESP_MODULE_STATUS_WARNINGMSG)
> > >
> > > > +             return -EIO;
> > > > +     }
> > > > +
> > > > +     if (bp->hwrm_spec_code < 0x10202) {
> > > > +             NL_SET_ERR_MSG_MOD(extack, "Unsupported hwrm spec");
> > >
> > > Likewise. As a user I do not know what "hwrm spec" means... Maybe:
> > >
> > > NL_SET_ERR_MSG_MOD(extack, "Firmware version too old");
> > >
> > >
> > > > +             return -EOPNOTSUPP;
> > > > +     }
> > > > +
> > > > +     if (page_data->bank && !(bp->phy_flags & BNXT_PHY_FL_BANK_SEL)) {
> > > > +             NL_SET_ERR_MSG_MOD(extack, "Firmware not capable for bank selection");
> > > > +             return -EOPNOTSUPP;
> > >
> > > What happens if you have an old firmware that does not support this
> > > functionality and user space tries to dump page 10h from bank 1 of a
> > > CMIS module that supports multiple banks?
> > >
> > > I wanted to say that you would see the wrong information (from bank 0)
> > > because the legacy operations do not support banks and bank 0 is
> > > assumed. However, because only pages 10h-ffh are banked, user space will
> > > get an error from the following check in fallback_set_params():
> > >
> > > if (request->page)
> > >         offset = request->page * ETH_MODULE_EEPROM_PAGE_LEN + offset;
> > >
> > > [...]
> > >
> > > if (offset >= modinfo->eeprom_len)
> > >         return -EINVAL;
> > >
> > > I believe it makes sense to be more explicit about it and return an
> > > error in fallback_set_params() in case bank is not 0. Please follow up
> > > if the above analysis is correct.
> >
> > So older firmware do not understand bank > 0 and hence it returns to
> > EOPNOTSUPP, which goes to fallback_set_params() and fails for
> > if (offset >= modinfo->eeprom_len)
> >         return -EINVAL
> > As we are not setting modinfo->eeprom_len for CMIS modules in get_module_eeprom.
> > With the above said userspace gets EINVAL.
> > Let me know if my understanding is correct?
>
> Yes. Basically there is no point for ethtool to even try to invoke the
> legacy operations when bank is not zero:
>
> diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
> index 1c94bb8ea03f..1d6a35c8b6f0 100644
> --- a/net/ethtool/eeprom.c
> +++ b/net/ethtool/eeprom.c
> @@ -60,6 +60,9 @@ static int eeprom_fallback(struct eeprom_req_info *request,
>         u8 *data;
>         int err;
>
> +       if (request->bank)
> +               return -EINVAL;
> +
>         modinfo.cmd = ETHTOOL_GMODULEINFO;
>         err = ethtool_get_module_info_call(dev, &modinfo);
>         if (err < 0)
>
> Not sure how many will actually hit it. I expect drivers supporting
> modules with banked pages to implement the new ethtool operation.

We may return with -EINVAL so it wont fallback but I like your
suggestion for bank check in eeprom_fallback
 if (request->bank)
         return -EINVAL;
seems to be a good idea as the bank parameter is not propagating
further to the drivers.
I believe your new operation means that "drivers need to implement
get_module_eeprom_by_page" if they want to access banked pages. Am I
right?

Thanks,
Vikas

--00000000000079310605ea1dec35
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
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIE+u71H2EUKSkk8mp1OnvPoo2hsSHcmJOvsG
dAWicZ5yMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTAwMzA5
MjUyNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQCxVoWdT/TfOWk0+S/AdYQrUuGL+E9NJnL+pwhmIQLvIvicbIFHpXd5
82SoI5UWLKMQGeBXkqRL6DKpGlmMzcCr3TNKQvMSm8wAp8mcTjdUOQ/lTQ1JUausGoUVgIcWd3OY
Hx20+O/Q1KeG3TemfEeMzJZZJYXQNqtWpe4M75rj0MwpTwK9W7FYhOs9sPxtIJIw7u1Iu7GMhxBM
1B9mRPuIynnds1E4tYGzHudte4jGXyR9QtSXbejWjkYEcXQDIn9jMHSCVV2ayjnv4Odi7pKpqu4D
OoGznHEip77U2mmfaDvMvuPh6vL48GfsOsUcHEDWxqhHe+pC3y+vH8Oy3LdW
--00000000000079310605ea1dec35--
