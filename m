Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DC75227B1
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 01:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238279AbiEJXfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 19:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbiEJXfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 19:35:06 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79232802F5;
        Tue, 10 May 2022 16:35:04 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id x18so229806plg.6;
        Tue, 10 May 2022 16:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=R13jHsl0NRq2P7uupdPrQEK0knUWVCVlecfA2FHAsIY=;
        b=i6LMAZCFD+2w5H807GfcaKA0KFBunhQMkZ4oNhifqGqedLQWS0l4oYs5yiLhDNtB9E
         kzC8SpUjZBK3RsBeGeRG/ZfUTYH2GXeTBP8S7gqRFHFzqGvgymqfELVeW7qoPIFW4VGh
         GceRYpMBG1+oFZRy3IFPBPuecFyUGBQvv4sHVak/ehU4VhkBIM89rJIWPUb3+TNeq55j
         XB50sdW1SncopJC0TPQz6UVUHprqYUCSzdwZn2ahW9oaxJb6msfEQhQJt9V0wtvsAbWI
         GhSFn8GLq4d3d5Wcy8EmmGa/z32Mhn/mstI1BryUQjsIJWyf+sIz7HU1OqpwPLtHYu5H
         z45w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R13jHsl0NRq2P7uupdPrQEK0knUWVCVlecfA2FHAsIY=;
        b=x6r/SqwdMyu8QYk4nwwIUcwXLLmCEydGPE5gcpB4q+Pm+l3/9VfRlikOQePTBeicdz
         TDkBolaYV8lNOFR8Is24MdTyon5Qid+V/oAI2XSib29YWOhb1vm7Ttfz2Ah/KThMU8Ig
         jobk4GqW5+jI9LuMmHMypmunvkaIN88YM8bc3fCMX7UvH+6CHVg3NIiPRFJ+eRg78nAp
         /NjIXHpKONJ7mrvSw2LPchsciVJp/tqm+jyZ2yzuDP78xzJgpVyQe3g1ZRmufkCAouf3
         Hg1mVLJkayY6ohIspWB7GtZ7VoFxTFB5Js62JFVylz4De/EUT4vi3pMEdqCoKp8CxKql
         imjw==
X-Gm-Message-State: AOAM5334kZJFhqX6SgNF0w6JIiD+q3yL8Ve0Ka1VvdOqnDMEn3QLLRiK
        YeWjB0pP1Mu+QsGj9nRlL8k=
X-Google-Smtp-Source: ABdhPJxus5TmFdysSKYsoNhz5hOfAwQQ0cxSm5zp6mx6kXcl62wvePrQ8fNn1TW4Mea2M4xbAF0dKg==
X-Received: by 2002:a17:90b:38c3:b0:1dc:b8c1:d428 with SMTP id nn3-20020a17090b38c300b001dcb8c1d428mr2216367pjb.55.1652225704431;
        Tue, 10 May 2022 16:35:04 -0700 (PDT)
Received: from [192.168.11.5] (KD106167171201.ppp-bb.dion.ne.jp. [106.167.171.201])
        by smtp.gmail.com with ESMTPSA id u11-20020a17090341cb00b0015ee60ef65bsm160273ple.260.2022.05.10.16.35.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 16:35:03 -0700 (PDT)
Message-ID: <268372a9-2f6a-74f3-29ea-c51536a73dba@gmail.com>
Date:   Wed, 11 May 2022 08:34:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next] docs: ctucanfd: Use 'kernel-figure' directive
 instead of 'figure'
Content-Language: en-US
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Martin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <05d491d4-c498-9bab-7085-9c892b636d68@gmail.com>
 <202205101825.15126.pisa@cmp.felk.cvut.cz>
From:   Akira Yokosawa <akiyks@gmail.com>
In-Reply-To: <202205101825.15126.pisa@cmp.felk.cvut.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 May 2022 18:25:15 +0200,
Pavel Pisa wrote:
> Hello Akira,
>=20
> On Tuesday 10 of May 2022 11:34:37 Akira Yokosawa wrote:
>> Two issues were observed in the ReST doc added by commit c3a0addefbde
>> ("docs: ctucanfd: CTU CAN FD open-source IP core documentation.").
>=20
> Thanks for the fix
>=20
>> The plain "figure" directive broke "make pdfdocs" due to a missing=20
>> PDF figure.  For conversion of SVG -> PDF to work, the "kernel-figure"=

>> directive, which is an extension for kernel documentations, should
>> be used instead.
>=20
> I have not noticed that there is kernel-figure
> option. We have setup own Sphinx 1.4.9 based build for driver
> documentation out of the tree compilation, I am not sure if that
> would work with this option but if not we keep this version
> modified. There are required modification for sources location anyway..=
=2E
>=20
> https://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/doc/linux_driver/buil=
d/ctucanfd-driver.html

You might want to see kernel's doc-guide at

    https://www.kernel.org/doc/html/latest/doc-guide/sphinx.html

, or its source

    Documentation/doc-guide/sphinx.rst

>=20
>> The directive of "code:: raw" causes a warning from both
>> "make htmldocs" and "make pdfdocs", which reads:
>>
>>     [...]/can/ctu/ctucanfd-driver.rst:75: WARNING: Pygments lexer name=

>>     'raw' is not known
>=20
> Strange I have not seen any warning when building htmldocs
> in my actual linux kernel tree. I have cleaned docs to be warnings
> free, but it is possible that I have another tools versions.
Well, I don't think "make htmldocs" runs with Sphinx 1.4.9.

You mean 1.7.9?

Then the above mentioned warning is not shown.
I see the warning with Sphinx versions 2.4.4. and 4.5.0.

I'll amend the changelog to mention the Sphinx versions and
post as v2.

        Thanks, Akira

>=20
> Anyway thanks for cleanup.
>=20
>> A plain literal-block marker should suffice where no syntax
>> highlighting is intended.
>>
>> Fix the issues by using suitable directive and marker.
>>
>> Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
>> Fixes: c3a0addefbde ("docs: ctucanfd: CTU CAN FD open-source IP core
>> documentation.") Cc: Pavel Pisa <pisa@cmp.felk.cvut.cz>
>> Cc: Martin Jerabek <martin.jerabek01@gmail.com>
>> Cc: Ondrej Ille <ondrej.ille@gmail.com>
>> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
>=20
> Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
>=20
>> ---
>>  .../networking/device_drivers/can/ctu/ctucanfd-driver.rst     | 4 ++-=
-
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git
>> a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
>> b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst =
index
>> 2fde5551e756..40c92ea272af 100644
>> --- a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.=
rst
>> +++ b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.=
rst
>> @@ -72,7 +72,7 @@ it is reachable (on which bus it resides) and its
>> configuration =E2=80=93 registers address, interrupts and so on. An ex=
ample of such
>> a device tree is given in .
>>
>> -.. code:: raw
>> +::
>>
>>             / {
>>                 /* ... */
>> @@ -451,7 +451,7 @@ the FIFO is maintained, together with priority
>> rotation, is depicted in
>>
>>
>>
>> -.. figure:: fsm_txt_buffer_user.svg
>> +.. kernel-figure:: fsm_txt_buffer_user.svg
>>
>>     TX Buffer states with possible transitions
>=20
>=20
