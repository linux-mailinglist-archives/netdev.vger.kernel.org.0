Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF275EED42
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 07:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbiI2Ffd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 01:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbiI2Ffb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 01:35:31 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6389912AEF4
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 22:35:29 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c24so355532plo.3
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 22:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Ow33bGwsTuCxlvSyBZjcLYbuGUmXycrebwfdcAPo4PI=;
        b=ICRYH3llnqMWVX6UJILSw4FDAWsgx7ZeuJtXTe/bcHccsk5XgBdcn3ntgCF10w3RO5
         E4PK4OTIElewfI2EImKnrX7w632FSUq7nz4MpE20MFjDii8fII2xZZr/yTEMEUt1he2j
         KqX2RlnUmrQEB/KtP3Q7ILL1D6Jhgey0UL+Ig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Ow33bGwsTuCxlvSyBZjcLYbuGUmXycrebwfdcAPo4PI=;
        b=Oqema3m1xPzlkVHCxtUarJ9fcSsUY51jJaM0BBLN1mBWeewhlwuoVrLbcqCTHKu/qS
         0ZDmZMmpLswYMpD7ixQlrZN4A7WrVDoM4uDCSJaO5rXGSCgxyBIhtAxebrsPmqKV99xb
         xgeNZGzHNXex72AbccGzXWboXUwLoF03kaB8ZZxrsqv0m+0TBDHDA47vwty0tvEopXYm
         zwMCuCGS/Gl1CYYSovcQCG+WaUqusk4Ym+wk4oHj+MwvN12sJFd+pmB00+Zzao9cQr9T
         pG0wUzuB94+m13O3yE6rNQT0O+PQ8udI4HTD5W98HSEDJhTOz7s9TKg6mFezFzDyY6aV
         ln7Q==
X-Gm-Message-State: ACrzQf1Ag8CT5RVBZbdV1p7QR+gkMuhmh3yowADLlpLiHJ9siyDdI/av
        /zSdOoLt2m3RA8q6nw4m3yBNOWehsuSdwjLE6Fl7kg==
X-Google-Smtp-Source: AMsMyM7EDl1/2ho9tnBvdUkjqyyQKtSzxNP3Nvw0NwU9MkPb67vORjVoxh+52qLcjZK+5MeJ/E+8lgMWvMVQHp2zncg=
X-Received: by 2002:a17:902:f54f:b0:178:a0eb:d7a6 with SMTP id
 h15-20020a170902f54f00b00178a0ebd7a6mr1807888plf.36.1664429728689; Wed, 28
 Sep 2022 22:35:28 -0700 (PDT)
MIME-Version: 1.0
References: <1664326724-1415-1-git-send-email-michael.chan@broadcom.com>
 <1664326724-1415-6-git-send-email-michael.chan@broadcom.com> <YzQVDXDTRnM/Oz4z@shredder>
In-Reply-To: <YzQVDXDTRnM/Oz4z@shredder>
From:   Vikas Gupta <vikas.gupta@broadcom.com>
Date:   Thu, 29 Sep 2022 11:05:15 +0530
Message-ID: <CAHLZf_s3en3Lgjxu6u1ii254vow-0CkHWk0j3jhBzY2MHCcLUw@mail.gmail.com>
Subject: Re: [PATCH net-next 5/6] bnxt_en: add .get_module_eeprom_by_page() support
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, gospo@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c2baf605e9ca3eb3"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000c2baf605e9ca3eb3
Content-Type: text/plain; charset="UTF-8"

Hi Ido,

On Wed, Sep 28, 2022 at 3:04 PM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Tue, Sep 27, 2022 at 08:58:43PM -0400, Michael Chan wrote:
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> > index 0209f7caf490..03b1a0301a46 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> > @@ -2207,6 +2207,15 @@ struct bnxt {
> >  #define SFF_MODULE_ID_QSFP                   0xc
> >  #define SFF_MODULE_ID_QSFP_PLUS                      0xd
> >  #define SFF_MODULE_ID_QSFP28                 0x11
> > +#define SFF_MODULE_ID_QSFP_DD                        0x18
> > +#define SFF_MODULE_ID_DSFP                   0x1b
> > +#define SFF_MODULE_ID_QSFP_PLUS_CMIS         0x1e
> > +
> > +#define BNXT_SFF_MODULE_BANK_SUPPORTED(module_id)    \
> > +     ((module_id) == SFF_MODULE_ID_QSFP_DD ||        \
> > +      (module_id) == SFF_MODULE_ID_QSFP28 ||         \
> > +      (module_id) == SFF_MODULE_ID_QSFP_PLUS_CMIS)
>
> I suggest dropping this check unless you have a good reason to keep it.
> There are other modules out there that implement CMIS (e.g., OSFP) and
> given bnxt implements ethtool_ops::get_module_eeprom_by_page, it should
> be able to support them without kernel changes.
>
> See:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=970adfb76095fa719778d70a6b86030d2feb88dd
>
> The problem there was more severe because the driver returned '-EINVAL'
> instead of '-EOPNOTSUPP'.
>
We want to fallback on get_module_eeprom callback in case modules do
not implement CMIS and we pass the bank parameter accordingly to the
firmware.

> > +
> >  #define SFF8636_FLATMEM_OFFSET                       0x2
> >  #define SFF8636_FLATMEM_MASK                 0x4
> >  #define SFF8636_OPT_PAGES_OFFSET             0xc3
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > index 379afa670494..2b18af95aacb 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > @@ -3363,6 +3363,60 @@ static int bnxt_get_module_eeprom(struct net_device *dev,
> >       return 0;
> >  }
> >
> > +static int bnxt_get_module_eeprom_by_page(struct net_device *dev,
> > +                                       const struct ethtool_module_eeprom *page_data,
> > +                                       struct netlink_ext_ack *extack)
> > +{
> > +     struct bnxt *bp = netdev_priv(dev);
> > +     u16 length = page_data->length;
> > +     u8 *data = page_data->data;
> > +     u8 page = page_data->page;
> > +     u8 bank = page_data->bank;
> > +     u16 bytes_copied = 0;
> > +     u8 module_id;
> > +     int rc;
> > +
> > +     /* Return -EOPNOTSUPP to fallback on .get_module_eeprom */
> > +     if (!(bp->phy_flags & BNXT_PHY_FL_BANK_SEL))
> > +             return -EOPNOTSUPP;
>
> Maybe:
>
> if (bank && !(bp->phy_flags & BNXT_PHY_FL_BANK_SEL)) {
>         // extack
>         return -EINVAL;
> }

BNXT_PHY_FL_BANK_SEL is a firmware capability to handle CMIS/bank
parameters. It does not tell whether the hooked module is CMIS
compliant.
I think EOPNOTSUPP is an appropriate choice here.


>
> This should allow you to get rid of patch #2.

I am not sure how we can get rid of patch #2. Patch #2 handles non CMIS modules.
Can you please elaborate more.

>
> > +
> > +     rc = bnxt_module_status_check(bp);
> > +     if (rc)
> > +             return rc;
>
> You can add extack here. I see that this function always returns
> '-EOPNOTSUPP' in case of errors, even when it does not make sense to
> fallback to ethtool_ops::get_module_eeprom.
Maybe -EIO can be used in one of these cases. I`ll check.

>
> > +
> > +     rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A0, 0, 0, false,
> > +                                           0, 1, &module_id);
> > +     if (rc)
> > +             return rc;
> > +
> > +     if (!BNXT_SFF_MODULE_BANK_SUPPORTED(module_id))
> > +             return -EOPNOTSUPP;
>
> I believe this hunk can be removed given the first comment.
  As I mentioned above we need this here to fallback.

Thanks,
Vikas
>
> > +
> > +     while (length > 0) {
> > +             u16 chunk = ETH_MODULE_EEPROM_PAGE_LEN;
> > +             int rc;
> > +
> > +             /* Do not access more than required */
> > +             if (length < ETH_MODULE_EEPROM_PAGE_LEN)
> > +                     chunk = length;
> > +
> > +             rc = bnxt_read_sfp_module_eeprom_info(bp,
> > +                                                   I2C_DEV_ADDR_A0,
>
> page_data->i2c_address
>
> > +                                                   page, bank,
> > +                                                   true, page_data->offset,
> > +                                                   chunk, data);
> > +             if (rc)
>
> You can add a meaningful extack here according to the return code.
>
> > +                     return rc;
> > +
> > +             data += chunk;
> > +             length -= chunk;
> > +             bytes_copied += chunk;
> > +             page++;
> > +     }
>
> I'm not sure why the loop is required? It seems
> bnxt_read_sfp_module_eeprom_info() is able to read
> 'ETH_MODULE_EEPROM_PAGE_LEN' bytes at once, which is the maximum:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ethtool/eeprom.c#n234
>
> > +
> > +     return bytes_copied;
> > +}
> > +
> >  static int bnxt_nway_reset(struct net_device *dev)
> >  {
> >       int rc = 0;
> > @@ -4172,6 +4226,7 @@ const struct ethtool_ops bnxt_ethtool_ops = {
> >       .set_eee                = bnxt_set_eee,
> >       .get_module_info        = bnxt_get_module_info,
> >       .get_module_eeprom      = bnxt_get_module_eeprom,
> > +     .get_module_eeprom_by_page = bnxt_get_module_eeprom_by_page,
> >       .nway_reset             = bnxt_nway_reset,
> >       .set_phys_id            = bnxt_set_phys_id,
> >       .self_test              = bnxt_self_test,
> > --
> > 2.18.1
> >

--000000000000c2baf605e9ca3eb3
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
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILdTij+nChg3nHoHJCtT9sS1jebws2wKEUX+
cZVq1WRRMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDkyOTA1
MzUyOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQBXEHWLaWWfE7E1NqrKYv40zhhxO5V2/EVMpZLPedDcdWaXjKiSWxWw
kKPD4Oes6A8SHpzdLxrQvabeE+7YhHTfCsTDgAF7SbRSg3K167lFCSo/macPV7haCgElaFy9GMdg
OsNn0LuqFMxJGDi9d+eEM5XbzMccD5yhu3i4Q1ljzEkkYbLd3No5jBv5Px0SKGJtm7CJmNr1RhWr
v+U9sK60XPqmsSsd9DQJq8ffzer/jxYuf+cSsyDYpE/aOVr8w7YrdvsOgVpcM3oq4L0GrptzuTTN
LqHwkYZJkVCbLqMG6TmxMsBQBHkuwd8mipkCZDsyF3iySU7xnlzjT3FHoUth
--000000000000c2baf605e9ca3eb3--
