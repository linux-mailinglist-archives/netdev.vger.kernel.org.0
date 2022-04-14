Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66637500453
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 04:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239398AbiDNCfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 22:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237596AbiDNCfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 22:35:16 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3A63193E;
        Wed, 13 Apr 2022 19:32:53 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id bx5so3824213pjb.3;
        Wed, 13 Apr 2022 19:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bFfSB3MkbGVw5DPFfNPtFnOptnDtnp9o+JkbXFL438w=;
        b=Yuc/S0pMVH53tN0I2MZslBHNRWj4Os9tz+iwhNhUCoBOrwa1pW2aHB32oUxQaIVo4X
         MRGBCjrSi7tITBPOALgh1MIe8jJHCnNHcXRsPkRE5FkPL+tnvAB9RnvxiXlIUkMU2usM
         jPf/PoGZma49gXPaAOdVRv2D9sOAIAo173pjQo7STuopwTA3X7nMaJg9+pA6fJPBVFzH
         7l/X1ztku2MFOfXIUIyeKEDvVly06sYNGWDjfcpae9qg5GyHMFu9Fu1Tabxf37Zo67jz
         UY3CmJ8iNh62ePlFUjyUR19F3VLDLzFF80UDBqRtcTJwnN88Y+3cOJtyCiSQJ+6hjwfD
         1TLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bFfSB3MkbGVw5DPFfNPtFnOptnDtnp9o+JkbXFL438w=;
        b=guldfmQQ29Y7JUaR3EB5R2ntjUsxAvMdaLDbTBrj6+sPn/uGqY1EJnZ5Bci7E2KiPC
         DVbp4EEU73n4Oj4/XmM/73Krf81TD5bYR3yu+3P6PgvO0sYnEmuhcZ0R+v4fBrP89Qiy
         ZEimcj91IU2Np2x9XOusLH7Zb79eZUscrBuHVhENIu4M/FvLavYV4SaZ20kUPy0kXfVI
         EyDITA3uDt21xVbD0b/qzl/MamHIUZwqVKPppY2vUcdeI5sqHIF6xikmc7trvtlXY71y
         NzBa1LW8xtxkspgMDi/kg8o+1Ym9rhkcHn6r2XS5z66WZ5FFtu+PWjb+7y2kwwSGhbOW
         P9nQ==
X-Gm-Message-State: AOAM5334BG5noF7lrFQoOKIUxKKv850PTiTyVg/Ov8MSMtv2PkuqMPr0
        DkVNM3xmpOMGk058SQWwrGoz3Dqz2cS4H3/p5WwTCqd8zmsjcw==
X-Google-Smtp-Source: ABdhPJyEVSy2MHFHPch2nShx/erUxiBk9K5yS9Iy83Xwj3n0GWyJ3VRFjFXQYn/3f96vLw7PpPYpBH65k5bqFbEUmfI=
X-Received: by 2002:a17:90a:db16:b0:1cb:9ba8:5707 with SMTP id
 g22-20020a17090adb1600b001cb9ba85707mr1957166pjv.32.1649903573133; Wed, 13
 Apr 2022 19:32:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220411210406.21404-1-luizluca@gmail.com> <20220412105018.gjrswtwrgjyndev4@bang-olufsen.dk>
 <CAJq09z53MZ6g=+tfwRU-N5BV5GcPSB5n0=+zj-cXOegMrq6g=A@mail.gmail.com> <20220414014527.gex5tlufyj4hm5di@bang-olufsen.dk>
In-Reply-To: <20220414014527.gex5tlufyj4hm5di@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Wed, 13 Apr 2022 23:32:42 -0300
Message-ID: <CAJq09z6KSQS+oGFw5ZXRcSH5nQ3zongn4Owu0hCjO=RZZmHf+w@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for RTL8367RB-VB
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tobias@waldekranz.com" <tobias@waldekranz.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> While the code is OK, on second thought I think based on Andrew's points in the
> other subthread that we are better off without this patch.

I agree, although the rtl8365mb name will make it harder for a
newcomer to find the driver.

Is it too late to get rid of all those compatible strings from
dt-bindings? And rtl8367s from the driver?
We must add all supported devices to the doc as well, similar to mv88e6085.

Regards,

Luiz
