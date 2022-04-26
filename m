Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6AD1510AC7
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 22:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355167AbiDZU43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 16:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344812AbiDZU4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 16:56:22 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CC848887;
        Tue, 26 Apr 2022 13:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1651006381;
        bh=OJUDzpc6mAIOLTsHkxVTark5mkSrpVi6U11Y6K4ImT0=;
        h=X-UI-Sender-Class:Date:To:Cc:References:From:Subject:In-Reply-To;
        b=hJU5kmyZJFKvYpNRNn/aAYWrckDrAdyS3SksJYChvc/eVdxtwpWzkRoZegCHSqhF7
         WoWbMLV30F264Kmdj2Cc2CR6fMfsyC2WjL9SpSdYxgsBPMwXZoNkr4XsausxQXkk1d
         uvNakWyJfgBecGvswfa6gn5b3URlzhsz4EIzs11g=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.164.205]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mk0NU-1o7oYv2wJs-00kPCA; Tue, 26
 Apr 2022 22:53:01 +0200
Message-ID: <87650cea-d190-9642-edf7-7dea42802dab@gmx.de>
Date:   Tue, 26 Apr 2022 22:53:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>
References: <20220315184342.1064038-1-kuba@kernel.org>
 <29f1daf3-e9f2-bbc5-f5e5-6334c040e3fa@gmx.de>
 <20220315120432.2a72810d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a66551f3-192a-70dc-4eb9-62090dbfe5fb@gmx.de>
 <20220426055311.53dd8c31@kernel.org>
From:   Helge Deller <deller@gmx.de>
Subject: Re: [PATCH net-next] net: mark tulip obsolete
In-Reply-To: <20220426055311.53dd8c31@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:X0IV/WfrtR368XxtRccpFCnzGxPtA2MY3lOjvPW7m85JTtNpXF+
 3LVzmyqbvtZUFL0scwTOZ4zaBy6lb9r8H4EtBIc1APbHQIMAec6/6OuNoCbpRgyUMghGWjU
 FKBvt/zpkmerpkP1FmeD8H3MhsyXOPqKgNYcQtHicencKSQyJgdigpRGokH/pkZUc0PWFUX
 myyMvrU3E4ccNi/0H3lLw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:+wwru0dGgfQ=:CnZYp12QAiS5o0eoFgZk1t
 4PZNGRHjQ9ss+8Jns/5LXu43TvSSToKRH8HTAjKS1dKn+zijWFx1TO0EC0r1WmtbuL1SRTcbG
 GoQZKDb332gAyFGKJtceDbvI2PH8mKmvSkbQrt636jz4YE8tlzFDMzL6HLDZwu5LF7g3lpuP6
 eBoJzx5YRb3emJn38KO0bJhESivPO7Gio0Q24xslxD7uQXbLRYVI0GByJxsKgzQcF82Av5F24
 Dc6E3ddbaEFIKwmJSgmFK2k9pbWJ7+jpN6MnYFTTuvbHMLyoes3EXvvo0koOpw1e4WQchmSHq
 XL3bUQtDCkYf6wOT+EFic+5oU3dR3iGUlcX7Bg3OoWGgWqAPZOR9CNsPuomNQsBL2rPLzd1mA
 t7e6ZcT5S5R8JUwrPdsN4O3qALkIm6tgOBoyjD43NcWEj2jYGiRTzoVg3U4X/mY5DvmtzTTSJ
 5yHfbBz+0Rb5PcX/PHPs5rSgxfqM/O0n/3tzJj/gbw/Dn7ofKtwtetj6YJKyBFPJNAAnJp1OF
 Q1AKfmjKzKHjVMMlpzJblzkvXL2WDSpf+MI97RZulw2eYC9zxjGyONib5OzergO+Qbq3PVTFS
 jKZvvuW1Eji67vpDY3GxBLqVg68zen77Q1tZruB30z5p3BbisbzFaUBkKPIBJmu9zdfAKtgoF
 8AyTP9HaaMK2bz1Lvoec7rTCoWOi3ViMELDdeieVTkBer/CMQYJo922QG8vwQayhPAxu7GNYB
 xU1hsTWtTd2FMUc34vZ0GN46VqL3SCKLjDTz8qBN4zYHHMwoGLD4PxOgkvyuZzxvv/PZzTSZf
 p6g79VtR3LbgVrEoaBEN2aAtLTZg4uAFqc3RvkuZGzfYYda6aydrAGoyz1hMkEA26B7kRIVSf
 xntAp+eV3ajDmkcz9yCdjNGKBKgrguyxfr8Q5qZR0KZOfvuYIelDDFBuBO6QD9xuo36Q0HzPG
 EBZP+1XhQToZJcMKn9DeNi0qjW/HNvLoTkxBYkjwVYfSAJwyYFGKfI4cxThSTaCJ83ioBLHsG
 25OTdft46ZTlIOo99Y7FYvbodwOaJF67tSYiwJECFi9EnANkQ4rf/qxtPeZ4Wu0yvek7Hu6wy
 gCDmFvInT6R0RU=
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 4/26/22 14:53, Jakub Kicinski wrote:
> On Tue, 15 Mar 2022 23:18:38 +0100 Helge Deller wrote:
>> On 3/15/22 20:04, Jakub Kicinski wrote:
>>> On Tue, 15 Mar 2022 19:44:24 +0100 Helge Deller wrote:
>>>> On 3/15/22 19:43, Jakub Kicinski wrote:
>>>>> It's ancient, an likely completely unused at this point.
>>>>> Let's mark it obsolete to prevent refactoring.
>>>>
>>>> NAK.
>>>>
>>>> This driver is needed by nearly all PA-RISC machines.
>>>
>>> I was just trying to steer newcomers to code that's more relevant toda=
y.
>>
>> That intention is ok, but "obsolete" means it's not used any more,
>> and that's not true.
>
> Hi Helge! Which incarnation of tulip do you need for PA-RISC, exactly?

For parisc I have:

CONFIG_NET_TULIP=3Dy
# CONFIG_DE2104X is not set
CONFIG_TULIP=3Dy
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
# CONFIG_TULIP_NAPI is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
# CONFIG_PCMCIA_XIRCOM is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set

So not the DE4X5.

> I'd like to try to remove DE4X5, if that's not the one you need
> (getting rid of virt_to_bus()-using drivers).

I've CC'ed the linux-alpha mailing list, as the DE4X5 driver might be
needed there, so removing it completely might not be the best idea.

But since you want to remove virt_to_bus()....
It seems this virt_to_bus() call is used for really old x86 machines/cards=
,
which probably aren't supported any longer.

See drivers/net/ethernet/dec/tulip/de4x5.c:
...
#if !defined(__alpha__) && !defined(__powerpc__) && !defined(CONFIG_SPARC)=
 && !defined(DE4X5_DO_MEMCPY)
...
    tmp =3D virt_to_bus(p->data);
...

Maybe you could simply remove the part inside #if...#else
and insert a pr_err() instead (and return NULL)?

Helge
