Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5E31DF765
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 15:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387795AbgEWNO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 09:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731291AbgEWNO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 09:14:27 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D9CC061A0E;
        Sat, 23 May 2020 06:14:27 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u1so11254596wmn.3;
        Sat, 23 May 2020 06:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8LGo7kypX/UuiVS5X2JtFQ0JunA+QZt3vaFNvgvumNU=;
        b=gLm0wTbvAO45hZ2XesfzpTYLf2INXCegMtldROnBej+YMsA5hq5Qva0/c5u9XRoNfD
         2KP/Pu3p+OAXOdee9bB9unMBWRVIheR8b9dYAg5ncfqwXiJrkWGOEhPuapE4gmRIDeNn
         RNMV6rh9yvyTu7CCrYZzFJ/iVXM2VBsHVAiqPoHJNUQzdq11GxG7hyvjbCxHQz85s7xd
         NVX4QsVYkYcrX7MBIlJRZeDwX6MFL4FnJJxhmA2zaaQZHxdVCcvqwG7aTTh6fajXvJVB
         uUt1ErAwinoImb+4eA2YEKk4Nj7PfNayxWo1G9TSFyLJmH/QJgdTNjP7QpuVXk8aly+p
         rA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8LGo7kypX/UuiVS5X2JtFQ0JunA+QZt3vaFNvgvumNU=;
        b=J2dhQ8C800Fnfmlm+BClvMFbGvIRjJdYeZFA0oKcxJmIll53MD/qjxYblYBGZcZnOH
         WN3Nq8jJ+KKG7gvYiVp0yDZi9iVTEkyPs4t/rhz6kdW2CQ9A3LeWzNDjwDhwwpSE/bSr
         q7OAmm/gGumBK/ChG+ICi+643VmbQuaOvQ9bE2Qksz2YkeBL62NUt/KCSHbj+oFmeIro
         rYc7/qFRBiLHv3jVUU++sALUmKXnL7H9wfzkBzzFvQI4Jk+i2V+/lhMslyJP3Pap1mry
         SwKfWrwaQ5ONY3/2kqE95BYNTNm9j8oiU/gt8mEx1I6EhemJI0SCXEdh8qtWG+Z991Qe
         6QMg==
X-Gm-Message-State: AOAM531Bna4tC1yhpOKFoGWCVnHF99uX6NcPV2df8AwxdEnxkzIgahIK
        DR2rNqZUby4wzBct3os22Q0=
X-Google-Smtp-Source: ABdhPJxn+IxcTwwADZNrv5cvugkYcBEcPWXDlnjrtAyFx9W55umV1V9VFywTsf2mzefrH5OFGaF3Ug==
X-Received: by 2002:a05:600c:2043:: with SMTP id p3mr16862280wmg.187.1590239665539;
        Sat, 23 May 2020 06:14:25 -0700 (PDT)
Received: from linux-gy6r.site ([213.195.113.243])
        by smtp.gmail.com with ESMTPSA id y207sm13594800wmd.7.2020.05.23.06.14.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2020 06:14:24 -0700 (PDT)
Subject: Re: [PATCH v5 00/11] mediatek: add support for MediaTek Ethernet MAC
To:     David Miller <davem@davemloft.net>
Cc:     brgl@bgdev.pl, robh+dt@kernel.org, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com, kuba@kernel.org,
        arnd@arndb.de, fparent@baylibre.com, hkallweit1@gmail.com,
        edwin.peer@broadcom.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        stephane.leprovost@mediatek.com, pedro.tsai@mediatek.com,
        andrew.perepech@mediatek.com, bgolaszewski@baylibre.com
References: <20200522120700.838-1-brgl@bgdev.pl>
 <20200522.142031.1631406151370247419.davem@davemloft.net>
 <1f941213-7ca2-c138-3530-85c34ebf0d53@gmail.com>
 <20200522.143656.1986528672037093503.davem@davemloft.net>
From:   Matthias Brugger <matthias.bgg@gmail.com>
X-Pep-Version: 2.0
Message-ID: <4a95de78-05fe-eec6-e09b-1b907287a8af@gmail.com>
Date:   Sat, 23 May 2020 15:14:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200522.143656.1986528672037093503.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/20 11:36 PM, David Miller wrote:
> From: Matthias Brugger <matthias.bgg@gmail.com>
> Date: Fri, 22 May 2020 23:31:50 +0200
>=20
>>
>>
>> On 22/05/2020 23:20, David Miller wrote:
>>> From: Bartosz Golaszewski <brgl@bgdev.pl>
>>> Date: Fri, 22 May 2020 14:06:49 +0200
>>>
>>>> This series adds support for the STAR Ethernet Controller present on=
 MediaTeK
>>>> SoCs from the MT8* family.
>>>
>>> Series applied to net-next, thank you.
>>>
>>
>> If you say "series applied" do you mean you also applied the device tr=
ee parts?
>> These should go through my branch, because there could be conflicts if=
 there are
>> other device tree patches from other series, not related with network,=
 touching
>> the same files.
>=20
> It's starting to get rediculous and tedious to manage the DT changes
> when they are tied to new networking drivers and such.
>=20
> And in any event, it is the patch series submitter's responsibility to
> sort these issues out, separate the patches based upon target tree, and=

> clearly indicate this in the introductory posting and Subject lines.
>=20

My experience in with other subsystems is that the DTS changes which
enables de device are part of the series.
They are normally prefixed with "arm64: dts:" or "ARM: dts:" for 32 bit
SoCs. That also normally the way I detect patches which should through
my tree.

Anyway I'll try to remember submitters in the future to send DTS patches
for network devices as separate series. That makes my life a bit more
complicated as I afterwards have to find the related DTS series to the
driver you accepted, but I'll try.

Regards,
Matthias

