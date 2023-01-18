Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8436729D0
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjARVA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbjARVAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:00:04 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3296589A4
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:00:00 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id az20so453003ejc.1
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iLmjAz1Bv1kErvDdZZkAZOg0NWUDZopwZ8NsXfgWx6A=;
        b=ER0wTgJNKRB7ERYM7JhDqb6lgDTYaXbFWh5FunUGOa4wv9brQUNBXJYGJgH/Iio066
         8yBBW4C31LI9ZqT6H1anzlCfQH2qFAKGkECGgng0qhUE8jC2JBkGm6x/cMMWc+froTm+
         xjZuL1v8OQV7xxpPH56/f8nSTXA/h1g25OG2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iLmjAz1Bv1kErvDdZZkAZOg0NWUDZopwZ8NsXfgWx6A=;
        b=B+rD7HofacS4mP4KnbJwUIH4hrAweKuf4gEl6PFcNVZPAMUeunHazRw9luvQ99EfvQ
         XmpN3zgkkCl+eevI7lTNmY7mOUQWk4/ctsjsVsP9pM50oEBxz2y3Hd6YnJN6Hdv3/3mv
         fCe7Elw3vBkzFtuVmJsllG3SttTJClCGF68VIMfXSny0cCEta/NDcEx9DDZqPxGZ6RBS
         5fv7xkwo0vWrceMz4wosPjlBaNTDjZRpTnNU3RguEejxFmJF/IhuGryoMGylQ5mBC5nV
         8oXOJYmjlqqlZSeE/3ZNBe7ZS9G2BraRi9AjfVwngEbHi35CbG3xg8Q13CzQL6v+pQN+
         WYlg==
X-Gm-Message-State: AFqh2kpydvRAKRylDKL086y5UxaplMoSHaHifPjNm/fwQCAHBehcRK4d
        MPZqrSC5zVzeavvDh2YcAuVhitBhp4GV9STmnI+kbw==
X-Google-Smtp-Source: AMrXdXsE1DbRex0OlQJomrOsg36FznkMet18w+RvYUajjYeDJTxgnINu/ijbycB5WrA3C8WtOuewInWrbWMbnM/qaYY=
X-Received: by 2002:a17:906:9394:b0:7c4:efcf:3bc8 with SMTP id
 l20-20020a170906939400b007c4efcf3bc8mr1084302ejx.702.1674075598966; Wed, 18
 Jan 2023 12:59:58 -0800 (PST)
MIME-Version: 1.0
References: <20230118203457.never.612-kees@kernel.org>
In-Reply-To: <20230118203457.never.612-kees@kernel.org>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Wed, 18 Jan 2023 12:59:47 -0800
Message-ID: <CACKFLinj6Kn=hsbEWfcPtYjLOZjyMbj1vZG_68r7LrMa7Jf6Rg@mail.gmail.com>
Subject: Re: [PATCH] bnxt: Do not read past the end of test names
To:     Kees Cook <keescook@chromium.org>
Cc:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000006e3e0005f29019f0"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000006e3e0005f29019f0
Content-Type: text/plain; charset="UTF-8"

On Wed, Jan 18, 2023 at 12:35 PM Kees Cook <keescook@chromium.org> wrote:
>
> Test names were being concatenated based on a offset beyond the end of
> the first name, which tripped the buffer overflow detection logic:
>
>  detected buffer overflow in strnlen
>  [...]
>  Call Trace:
>  bnxt_ethtool_init.cold+0x18/0x18
>
> Refactor struct hwrm_selftest_qlist_output to use an actual array,
> and adjust the concatenation to use snprintf() rather than a series of
> strncat() calls.
>
> Reported-by: Niklas Cassel <Niklas.Cassel@wdc.com>
> Link: https://lore.kernel.org/lkml/Y8F%2F1w1AZTvLglFX@x1-carbon/
> Tested-by: Niklas Cassel <Niklas.Cassel@wdc.com>
> Fixes: eb51365846bc ("bnxt_en: Add basic ethtool -t selftest support.")
> Cc: Michael Chan <michael.chan@broadcom.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Michael Chan <michael.chan@broadcom.com>

> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
> index 2686a714a59f..a5408879e077 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
> @@ -10249,14 +10249,7 @@ struct hwrm_selftest_qlist_output {
>         u8      unused_0;
>         __le16  test_timeout;
>         u8      unused_1[2];
> -       char    test0_name[32];
> -       char    test1_name[32];
> -       char    test2_name[32];
> -       char    test3_name[32];
> -       char    test4_name[32];
> -       char    test5_name[32];
> -       char    test6_name[32];
> -       char    test7_name[32];
> +       char    test_name[8][32];

bnxt_hsi.h is a generated file.  I will need to make a request so that
future versions will be generated like this.

Thanks.

>         u8      eyescope_target_BER_support;
>         #define SELFTEST_QLIST_RESP_EYESCOPE_TARGET_BER_SUPPORT_BER_1E8_SUPPORTED  0x0UL
>         #define SELFTEST_QLIST_RESP_EYESCOPE_TARGET_BER_SUPPORT_BER_1E9_SUPPORTED  0x1UL
> --
> 2.34.1
>

--0000000000006e3e0005f29019f0
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDziaZeXSzDnk/cYFUBn3KxHU71tJsyz
6cYzc4CfnvbRMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDEx
ODIwNTk1OVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAB0NlWJXMG4jf7I05ig8lAQavdqgjsyC6jU4ZVBdwpFWMaYw46
n3Nr/JreqW9WsyIumpisMT3/r4JieBFpbkqoB++QOiN5N9LpDUEhWnxCKx6dNm1EKmtnq/CKXbte
7maX+p+b1fMZvq1yX7qDgdVz3ozCqMjPYd45ZryJl/Rhh7ey+z8GNhaIrwCUBrgZ87SPwC0gi1wK
cElz9AzxQIVbTHILjtqOL6XFA0z+LNr77KO19fl4NyqHAr3KsdInAmMWMAGQqzMLRR27unMzHpsR
ZRLBvNUfueZheAL1qsUeFDWL78rI1b6fn3XJOMjKcTJS62h1SkQRl3Ui/xvDtCuk
--0000000000006e3e0005f29019f0--
