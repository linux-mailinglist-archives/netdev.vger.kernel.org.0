Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 736CC57FBA7
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbiGYIsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbiGYIsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:48:54 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F9912744
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:48:53 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id t1so16979100lft.8
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EZr9c83p4rktQPg3DlFRczzjGeld7tG7OAcrwgeRPis=;
        b=Rm8HN70hRX+NM4Nd5oz2T0kS2kOMNSOvDy+hztjntGU/Rke5rudOEvnvOftFFFsUNg
         d5IIonXsxEzmEESkgq1brghHUYKToujzaoaUbZGb2r6d+gp5vsEL1GNvMR0iTHCVyhoV
         w17bkL87fklbDa+pSsvqCKwfZWwDBuewgaF5A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EZr9c83p4rktQPg3DlFRczzjGeld7tG7OAcrwgeRPis=;
        b=J+4BBspaWMJjXGp0LgBaxkUVwYG/wumHKwVX/7cc1s2XThO7BUP/cIrxiD3mfi31e9
         3u0dOhJKY6+W2AIouihZP1suXY2QlmhCs0dUNA6gaUqytRp4a5upSwAh22thWw08upIw
         OwD4brvB7uvfYOKIEzKNnFbiGEkiHyMKphZ0FSGcbnWmVzovmLhza1hQ1Ua3iAA3JW25
         aC9q0WYmeTp3NkVux/9ctTKTMB/MKoPd8NywdXK6+5VinVV9hdzcUkmT3eIu60Qy6qKG
         hVIJnZrb5OoSYyOE64x2uqPR3qQ9Iealw6X6kcUQ2wVVTi8LoBlYCtxCIkmnx+sQVDMs
         1WtA==
X-Gm-Message-State: AJIora8fEFuRs4jB/CQGR18gl8ARXEkkWQwT2iHxYbWtiMLk9nZx0S2r
        uIr+UoERs1xEravHJuvIOSN82BIPGad4PVwGEbmelg==
X-Google-Smtp-Source: AGRyM1voXjxeDP2zWasG/Lf+fjsU3sa+t6jhMdKgzv9dRNb6MxviXOsqY2x7Urj7zWBtz8hQjkUGlbWiFGQaLw/aCsE=
X-Received: by 2002:a05:6512:1594:b0:48a:874f:535 with SMTP id
 bp20-20020a056512159400b0048a874f0535mr2228851lfb.320.1658738931148; Mon, 25
 Jul 2022 01:48:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220723042206.8104-1-vikas.gupta@broadcom.com>
 <20220723042206.8104-2-vikas.gupta@broadcom.com> <20220723091600.1277e903@kernel.org>
 <Yt5L8TbzTwthnrl7@nanopsycho>
In-Reply-To: <Yt5L8TbzTwthnrl7@nanopsycho>
From:   Vikas Gupta <vikas.gupta@broadcom.com>
Date:   Mon, 25 Jul 2022 14:18:39 +0530
Message-ID: <CAHLZf_uWxnS5Voc6h7pnS=dRq96JV1wq9zVXKhVbyrRva9=b0g@mail.gmail.com>
Subject: Re: [PATCH net-next v6 1/2] devlink: introduce framework for selftests
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, dsahern@kernel.org,
        stephen@networkplumber.org, Eric Dumazet <edumazet@google.com>,
        pabeni@redhat.com, ast@kernel.org, leon@kernel.org,
        linux-doc@vger.kernel.org, corbet@lwn.net,
        Michael Chan <michael.chan@broadcom.com>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ca75d305e49d4000"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000ca75d305e49d4000
Content-Type: text/plain; charset="UTF-8"

Hi Jiri,

On Mon, Jul 25, 2022 at 1:23 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Sat, Jul 23, 2022 at 06:16:00PM CEST, kuba@kernel.org wrote:
> >On Sat, 23 Jul 2022 09:52:05 +0530 Vikas Gupta wrote:
> >> +enum devlink_attr_selftest_test_id {
> >> +    DEVLINK_ATTR_SELFTEST_TEST_ID_UNSPEC,
> >> +    DEVLINK_ATTR_SELFTEST_TEST_ID_FLASH,    /* flag */
> >> +
> >> +    __DEVLINK_ATTR_SELFTEST_TEST_ID_MAX,
> >> +    DEVLINK_ATTR_SELFTEST_TEST_ID_MAX = __DEVLINK_ATTR_SELFTEST_TEST_ID_MAX - 1
> >> +};
> >> +
> >> +enum devlink_selftest_test_status {
> >> +    DEVLINK_SELFTEST_TEST_STATUS_SKIP,
> >> +    DEVLINK_SELFTEST_TEST_STATUS_PASS,
> >> +    DEVLINK_SELFTEST_TEST_STATUS_FAIL
> >> +};
> >> +
> >> +enum devlink_attr_selftest_result {
> >> +    DEVLINK_ATTR_SELFTEST_RESULT_UNSPEC,
> >> +    DEVLINK_ATTR_SELFTEST_RESULT,                   /* nested */
> >> +    DEVLINK_ATTR_SELFTEST_RESULT_TEST_ID,           /* u32,
> >> +                                                     * enum devlink_attr_selftest_test_id
> >> +                                                     */
> >> +    DEVLINK_ATTR_SELFTEST_RESULT_TEST_STATUS,       /* u8,
> >> +                                                     * enum devlink_selftest_test_status
> >> +                                                     */
> >> +
> >> +    __DEVLINK_ATTR_SELFTEST_RESULT_MAX,
> >> +    DEVLINK_ATTR_SELFTEST_RESULT_MAX = __DEVLINK_ATTR_SELFTEST_RESULT_MAX - 1
> >
> >Any thoughts on running:
> >
> >       sed -i '/_SELFTEST/ {s/_TEST_/_/g}' $patch
>
> Sure, why not. But please make sure you keep all other related things
> (variables, cmdline opts) consistent.
>
> Thanks!
Does the 'test_id' in command line
 'devlink dev selftests run DEV test_id flash'
will still hold good if DEVLINK_ATTR_SELFTEST_RESULT_TEST_ID changes
to DEVLINK_ATTR_SELFTEST_RESULT_ID ?
or it should be
'devlink dev selftests run DEV selftest_id flash' ?

Thanks,
Vikas


>
>
> >
> >on this patch? For example DEVLINK_ATTR_SELFTEST_RESULT_TEST_STATUS
> >is 40 characters long, ain't nobody typing that, and _TEST is repeated..
> >
> >Otherwise LGTM!

--000000000000ca75d305e49d4000
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
I7qKxvF8Yo7eGTnHRTa99J+6yTd88AKVuhM5TEhpC8cS7qvrQXJje+Uing2xWC4FH76LEWIFH0Pt
x8C1WoCU0ClXHU/XfzH2mYrFANBSCeP1Co6QdEfRAgMBAAGjggHZMIIB1TAOBgNVHQ8BAf8EBAMC
BaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJlLmdsb2JhbHNp
Z24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYIKwYBBQUHMAGG
NWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwME0G
A1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
aWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqGOGh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3JsMCMGA1UdEQQc
MBqBGHZpa2FzLmd1cHRhQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSME
GDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUUc6J11rH3s6PyZQ0zIVZHIuP20Yw
DQYJKoZIhvcNAQELBQADggEBALvCjXn9gy9a2nU/Ey0nphGZefIP33ggiyuKnmqwBt7Wk/uDHIIc
kkIlqtTbo0x0PqphS9A23CxCDjKqZq2WN34fL5MMW83nrK0vqnPloCaxy9/6yuLbottBY4STNuvA
mQ//Whh+PE+DZadqiDbxXbos3IH8AeFXH4A1zIqIrc0Um2/CSD/T6pvu9QrchtvemfP0z/f1Bk+8
QbQ4ARVP93WV1I13US69evWXw+mOv9VnejShU9PMcDK203xjXbBOi9Hm+fthrWfwIyGoC5aEf7vd
PKkEDt4VZ9RbudZU/c3N8+kURaHNtrvu2K+mQs5w/AF7HYZThqmOzQJnvMRjuL8xggJtMIICaQIB
ATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhH
bG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwYjepatB64S625eswwDQYJ
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFb7W2PfZkbdDA1OIDb0jwzpNjNZS8HVzBUQ
C5+aDCT6MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDcyNTA4
NDg1MVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQA5x2oe0Q3zif482GkqX0iu025ez751xSNMhArZhh4m6hLjWe5oG0hr
uIpIUzTndJ4tqRd64fAQCzSTIddh8X3R+rBZ9kFZ/ZbSWNIS3S8Xzp2xA8I/e/OTN73Rh8aFZAU4
XMPPSXmvvP0qCeisgHoduk/6prTUUy+/Oc4z0NrjMUK+J6skTRhVFVq+atsx+rtnp7VKOdyb5qlt
2WJVDAAvpGuQp4ILjZvIPFPLOXFzwE0vKIqJHV1REDBS9t8jtsKRupSjIgL0uv6xgIQyXOeuAdCu
dinKmVvxmtfudXqgzgACyIZlgHhXnlvyrnvHfDqdIvEUXPgOyTMBNqFbMkIZ
--000000000000ca75d305e49d4000--
