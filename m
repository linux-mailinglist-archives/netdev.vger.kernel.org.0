Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9795BBE6C
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 00:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503267AbfIWW00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 18:26:26 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43891 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390460AbfIWW00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 18:26:26 -0400
Received: by mail-ed1-f65.google.com with SMTP id r9so14454153edl.10;
        Mon, 23 Sep 2019 15:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rs2RJDT5CsHbbEtk6Tq8OPTXVr0+QPsaOdJbfaooK0s=;
        b=aj0n9SYvFIYCRxpn20Jz+FRTJT0KI+N5uVRMrxxEpuhyjLbdEoS1G9UzMTavhqTMWL
         1LCe2i8i2ERqrH2v8e+Br3FQO+eO6jERm2FkKcW6wPK0ChFI2+XTooznTacB4rvoJzbJ
         EwL2dOAquvmqhdDCmqLqSIMqII9gJxgpCwt4zV/JvI+xFOKzoT9d2Gxer0x6aoxYbYFw
         PfcImqKzbV6AYykpbw9rwmP+G5tfi1N5t8tyx5ueI1CdVQ14TsY2lS6yEO5k5j41/Gpy
         JPpOQXcdiOsRx8HloPeT68q5AHuowfy7lgwJaRyrfeF0Jdy0vCjpTW0WM1crdjdZ7sIC
         OJgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rs2RJDT5CsHbbEtk6Tq8OPTXVr0+QPsaOdJbfaooK0s=;
        b=aw6lr4twK+3f6JLmTaTooj4yuHni9sqDLpQG8/gSWRl4HKZOczF+a1bZUii3AzeT/V
         /YCGKZjfwzMl2k95l8F0pHmHBGF+8gieyijkBTzL0T/CQiKwkADxlfW5IXPltSRjEgmY
         CLuKNiqrFwpl7QsCRk5VYz6Ko6hx9558UrBO0zl84BMcKA0X+AXBgrIHk2Iiy5W5BWQL
         3HW3HbyjaNC+ixog7ZOQHgqRd5acnX1w0q9iep5+zfFUnNecRJCD3ZlerCXmDKE1UGdl
         EBO77it8APyuuaOETA9dR8prFmj+HzFZTA5YRtP0w+wdHav8SZo+U913ThVuHldoOO02
         BDtA==
X-Gm-Message-State: APjAAAXvfDBpxrr/zk0PlkhEVDAFwhhGReRvhDXsJst6wnPWU1sIBM6y
        ioVZLiU1icVcXLNWihaTgwVoZai35T2MqATMYk8=
X-Google-Smtp-Source: APXvYqySJ1IkREdlT+UI4UOVQVT+SfLT1tYPl30tjmrGFsNVQKX6YQUTs7Yc92vR0eMvX6JFzK296KU+kWVADdNeZTs=
X-Received: by 2002:a50:918d:: with SMTP id g13mr2529336eda.64.1569277583256;
 Mon, 23 Sep 2019 15:26:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:aa7:c354:0:0:0:0:0 with HTTP; Mon, 23 Sep 2019 15:26:22
 -0700 (PDT)
In-Reply-To: <20190807155738.GA9394@azazel.net>
References: <20190807183606.372ca1a4@canb.auug.org.au> <f54391d9-6259-d08b-8b5f-c844093071d8@infradead.org>
 <20190807155738.GA9394@azazel.net>
From:   Ivan Kalvachev <ikalvachev@gmail.com>
Date:   Tue, 24 Sep 2019 01:26:22 +0300
Message-ID: <CABA=pqeES0C2+7GpAOYuCOqd5DrbZhjS1Tkrxn4kGxXQJkrAfg@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 7 (net/bridge/netfilter/nf_conntrack_bridge.c)
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/19, Jeremy Sowden <jeremy@azazel.net> wrote:
> On 2019-08-07, at 08:29:44 -0700, Randy Dunlap wrote:
>> On 8/7/19 1:36 AM, Stephen Rothwell wrote:
>> > Hi all,
>> >
>> > Changes since 20190806:
>>
>> on i386:
>> when CONFIG_NF_TABLES is not set/enabled:
>>
>>   CC      net/bridge/netfilter/nf_conntrack_bridge.o
>> In file included from
>> ../net/bridge/netfilter/nf_conntrack_bridge.c:21:0:
>> ../include/net/netfilter/nf_tables.h: In function
>> =E2=80=98nft_gencursor_next=E2=80=99:
>> ../include/net/netfilter/nf_tables.h:1224:14: error: =E2=80=98const stru=
ct
>> net=E2=80=99 has no member named =E2=80=98nft=E2=80=99; did you mean =E2=
=80=98nf=E2=80=99?
>>   return net->nft.gencursor + 1 =3D=3D 1 ? 1 : 0;
>>               ^~~
>
> I've just posted a series of fixes for netfilter header compilation
> failures, and I think it includes the fix for that:
>
>
> https://lore.kernel.org/netdev/20190807141705.4864-5-jeremy@azazel.net/T/=
#u

Have these patches been committed?

I just hit the same bug in linux-5.3.1 release.
