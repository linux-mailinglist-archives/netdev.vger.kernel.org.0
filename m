Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A62AB118348
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 10:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfLJJPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 04:15:00 -0500
Received: from a27-11.smtp-out.us-west-2.amazonses.com ([54.240.27.11]:49512
        "EHLO a27-11.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726911AbfLJJO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 04:14:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575969298;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=Ujunv0R/WM+sahEPNbxCRS3Q2pY5WCU98/q3fvcKML8=;
        b=i4EdORzIKrgPNIfR9Bxyo4wxrK/iL4LfFfJG84rdc3ISY6TqTAsHWUrEiwtuFjRe
        SSBsMPeXY58DVH1HWQh2aGc7hXmnhPwMEjUM6Js9yaUHafWmkSHshHnk9lqREvsTZ30
        v20ekgdc7/aotHyNUScJiW1aTFJ/En/J/Metg+1w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575969298;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=Ujunv0R/WM+sahEPNbxCRS3Q2pY5WCU98/q3fvcKML8=;
        b=WVG+KdzY0rjNjihzCNe8vhl7NrlmESxDszVZW6fw9GZX25xMpfEZbEnRFPM5ovOK
        Stpl7gYID/zKO4gkwZQlXB0isq2WSBZ2soHYPMKlF0VhO2y2EMLU+o+ky9AZ0/RzTyi
        PerZozhaAnEgDTR1tgnwQn99iClTLKy1w4SMrkPs=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 279BBC447BC
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>
Cc:     Soeren Moch <smoch@web.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] arm64: dts: rockchip: RockPro64: enable wifi module at sdio0
References: <20191209223822.27236-1-smoch@web.de> <2668270.pdtvSLGib8@diego>
        <2cf70216-8d98-4122-4f4e-b8254089a017@web.de>
        <6162240.GiEx4hqPFh@diego>
Date:   Tue, 10 Dec 2019 09:14:58 +0000
In-Reply-To: <6162240.GiEx4hqPFh@diego> ("Heiko \=\?utf-8\?Q\?St\=C3\=BCbner\=22'\?\=
 \=\?utf-8\?Q\?s\?\= message of "Tue, 10
        Dec 2019 02:18:24 +0100")
Message-ID: <0101016eef17168b-4b99c805-9c89-4ce6-a4fc-02f5e2b80c6d-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SES-Outgoing: 2019.12.10-54.240.27.11
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiko St=C3=BCbner <heiko@sntech.de> writes:

> Hi Soeren,
>
> Am Dienstag, 10. Dezember 2019, 00:29:21 CET schrieb Soeren Moch:
>> On 10.12.19 00:08, Heiko St=C3=BCbner wrote:
>> > Am Montag, 9. Dezember 2019, 23:38:22 CET schrieb Soeren Moch:
>> >> RockPro64 supports an Ampak AP6359SA based wifi/bt combo module.
>> >> The BCM4359/9 wifi controller in this module is connected to sdio0,
>> >> enable this interface.
>> >>
>> >> Signed-off-by: Soeren Moch <smoch@web.de>
>> >> ---
>> >> Not sure where to place exactly the sdio0 node in the dts because
>> >> existing sd nodes are not sorted alphabetically.
>> >>
>> >> This last patch in this brcmfmac patch series probably should be pick=
ed
>> >> up by Heiko independently of the rest of this series. It was sent tog=
ether
>> >> to show how this brcmfmac extension for 4359-sdio support with RSDB is
>> >> used and tested.
>> > node placement looks good so I can apply it, just a general questions
>> > I only got patch 8/8 are patches 1-7 relevant for this one and what ar=
e they?
>> Patches 1-7 are the patches to support the BCM4359 chipset with SDIO
>> interface in the linux brcmfmac net-wireless driver, see [1].
>>=20
>> So this patch series has 2 parts:
>> patches 1-7: add support for the wifi chipset in the wireless driver,
>> this has to go through net-wireless
>> patch 8: enable the wifi module with this chipset on RockPro64, this pat=
ch
>
> Thanks for the clarification :-) .
>
> As patch 8 "only" does the core sdio node, it doesn't really depend on the
> earlier ones and you can submit any uart-hooks for bluetooth once the
> other patches land I guess.
>
>
>> If this was confusing, what would be the ideal way to post such series?
>
> I think every maintainer has some slightly different perspective on this,
> but personally I like getting the whole series to follow the discussion b=
ut
> also to just see when the driver-side changes get merged, as the dts-parts
> need to wait for that in a lot of cases.

FWIW I prefer the same as Heiko. If I don't see all the patches in the
patchset I start worrying if patchwork lost them, or something, and then
it takes more time from me to investigate what happened. So I strongly
recommend sending the whole series to everyone as it saves time.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
