Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1740C5BF622
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 08:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiIUGOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 02:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiIUGOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 02:14:00 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27067FE6D
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 23:13:56 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b35so7169567edf.0
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 23:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date;
        bh=nH/YGM07XCtX0P4GAQJgVJG7VswJP8sxAc/DBubpv10=;
        b=V0H4fgZ3WFb/cPQWoBK03ae0hXtxCSV+UJdhrZ81P1BzazLa6I3+YqL54RRIqHWOh7
         UGllBzkaQI/lVE3o4Ovwt59oruBmNR5eZzCtQyWaEwGRWPCoCHQJBFUY36bgBx7jRTyG
         WqEMqPbBRy8cDjm5Padkk02u/ThvT72FsLUGm46HB/gyeTeZMwSjsW6pu7Ai5gjvv2it
         McTwe+vDoqAkwH+nUi7JtsbpJwmmqT6z1fhRRIcurEqxFGq3WuMzlOPxGGtD7qMHrR0y
         tzRB6r/gkCUD5KqIFzhl1N9TMoQQ/MXnqk7kZrmp41og7y/FKaagvZjpM/uarivCY9za
         OnNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=nH/YGM07XCtX0P4GAQJgVJG7VswJP8sxAc/DBubpv10=;
        b=FH44rV66QNUtNKKzkV+5frPbdKBlsG58KFjyGCeKDM2v3xvq+gmWucctv2FgaATE4u
         l28Qp53LzzXWNduwxx83SmbzfNgJZLigmHQTTHEUBNPtGsIAQeItv5AwnBmKmuWyMrrm
         yJ3McxZHg0QfUMDCdwC5TLRabXHcQCC6jMx/SYErDyov7H73mojnAcSZ2tmopob+Mnh6
         HrV/Kfiyq3ULe2K7OO+nRY9/Qz2oOGA4l25ytBnhfRfvkrZKgXeLZHBy0HAOfLTCTNQ+
         o42hV8hNHbS0DHvi7A8XF9K1l2gZ7CtRcw+EBPA3pTvWFXtzYrajYUIyUIiTVhIPrtAp
         Y+Mw==
X-Gm-Message-State: ACrzQf3LatMdLnb6NUL847xr7o7PsPN5J5Zwzo98UY5OyIVSJo6ZyuI3
        yoDpC7kQ1mmlKJvzvUH5H64=
X-Google-Smtp-Source: AMsMyM5svk1ClesKlZtaBr1Ru6lzOSeoZyIzoyKq62neK3V/YflUJCA5OQaGzMQXHj9eCb9EC3Tyww==
X-Received: by 2002:a05:6402:26cf:b0:451:70af:ecc5 with SMTP id x15-20020a05640226cf00b0045170afecc5mr23178221edd.287.1663740834692;
        Tue, 20 Sep 2022 23:13:54 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id o10-20020a170906774a00b0073ce4abf093sm764151ejn.214.2022.09.20.23.13.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Sep 2022 23:13:54 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Bug Report kernel 5.19.9 Networking NAT
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20220920190449.39910094@hermes.local>
Date:   Wed, 21 Sep 2022 09:13:52 +0300
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, pablo@netfilter.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F30B657A-5359-4B53-A5CA-D924ED7C8F9D@gmail.com>
References: <7D92694E-62A2-4030-8420-31271F865844@gmail.com>
 <20220920161918.6c40f2a6@kernel.org> <20220920190449.39910094@hermes.local>
To:     Stephen Hemminger <stephen@networkplumber.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All=20

=D0=A1orry in the first place!

yes load old module xt_NAT i see now .

after reload firewall with netfilter original modul all work fine =
without any error.

Thanks for responding!


Best regards,
Martin

> On 21 Sep 2022, at 5:04, Stephen Hemminger =
<stephen@networkplumber.org> wrote:
>=20
> On Tue, 20 Sep 2022 16:19:18 -0700
> Jakub Kicinski <kuba@kernel.org> wrote:
>=20
>> On Sat, 17 Sep 2022 11:03:55 +0300 Martin Zaharinov wrote:
>>> xt_NAT(O) =20
>>=20
>> What's this? Can you repro on a vanilla kernel?
>=20
>=20
> Google says it is out of tree full cone NAT
> https://github.com/andrsharaev/xt_NAT

