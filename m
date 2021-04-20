Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C3C365818
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 13:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhDTLwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 07:52:00 -0400
Received: from mout.gmx.net ([212.227.15.18]:37797 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231196AbhDTLv7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 07:51:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1618919473;
        bh=p2HUhAGVSp8I0C+yLEVDEoUoosBgJ0yPTgkTGBzScMo=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:Reply-to:To:
         CC:From;
        b=k+ZVbc26344lWiepXTHBMUspj7/UP28zKJ3udcMJt6YVTf+hqZZTzUsWbZedKSfrg
         GuOvFJytepQbOuol9SV/yliH10wp8MuZ303elCnvOXZ4Xt+VTCfaS3PeWj8Tcn/VJ4
         IkeRVDLRTO6lkFfGU0HhOYr/bX/mkoII1cQq28YY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from frank-s9 ([80.245.77.151]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M42jK-1lYouP19n6-00024H; Tue, 20
 Apr 2021 13:51:13 +0200
Date:   Tue, 20 Apr 2021 13:51:07 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <20210418211145.21914-3-pablo@netfilter.org>
References: <20210418211145.21914-1-pablo@netfilter.org> <20210418211145.21914-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH net-next 2/3] net: ethernet: mtk_eth_soc: missing mutex
Reply-to: frank-w@public-files.de
To:     Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org
CC:     davem@davemloft.net, kuba@kernel.org, john@phrozen.org,
        nbd@nbd.name, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        dqfext@gmail.com
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <C076C591-F541-48B3-9750-8F35B4127638@public-files.de>
X-Provags-ID: V03:K1:swgitFmc0mPP0LB6ndeGB2R62LSI549bZOivNTgx4e8uVxKkq7O
 234ZVo4ptkHqoivgdlYmyzey9XEhl3VzTdLGb50DudNvZH7VpvwzT/20+lZcCsKjqnW9pqJ
 QvsmCCAcuiNQ+MAb0wrelsyV8uY1Sd6YCXT89Al81xsnfxGm3HDq9j1hHpVGQH5ACC0djVJ
 lrammhBnvwrtsMBfNjJmw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Qip3ps5++hY=:CQPhJF0qGfSPNNkj+Aab0h
 VwcsZdIBZ3j1iLbFVFUYBR9xHU/GS57xIX7D/lxvVoTcfziwSg5i2QmMsqSW46uaktG6072/P
 VvG8hf0+dKc9aFfWa1ENi327H10EaY62ymHxeDui2GGrl7OHe5KALefKeSVVsbVZXnohljHOm
 DubEeFKUvGY3LhYrpLAZOZCrDp/LD0Z+YXlkAYWWh1KG9VX1A3S1lEhwhbUtWHfH3KDlmkzeL
 3qh5jPXCy4Ju382dIDGTXe9jwjGaDllvK3vCoXVvY7jge7fhZIUfkEbNWBDvqWZ1HurZxpukR
 Z78LxG0l47AeQl6YUlYUCtU8Zn7UTVxg2GjVwP7zMT7Uzz4gx7IUcj13qddgx+kZ/67R9vX16
 oUchlsyD4WlxcylnWPOYdqJ8pxqAMwDzcAgw7HrmCNAicoxiW1FYsOJCVKnkx9iLXawYPt9xS
 1/ejUaRjJqXtAvEjlBCkPWU32c7VkUgEH85awauSUHFTJK1hmmxakbD7xvvWJ8HZULgao7Lc2
 kFsGtAktQ+Ybrux0gV9LMZLADwgAPB51CreA+P2RlCfS/x4TVusyzhAx5HI0OJSOhnDcoPCO5
 hUsz78XUt3W8WFM3abRGw8Bz/rUUCDcbqwgwwUxdVTg6dEMiXrzXVXlxE+e9kj8XlYFT0NavQ
 4laaBLMaZxL8GfBNgt0e4NDMyn0e1QIUzfnyDUP9s9pKHwasW/AvWIcYPgGABrHg6sspor1At
 HosMX3sspTw1E/EEkmjSnXrwFiqWqxOOjJfoLYbu7LlFuwzQi5D7JvtGGUwA7kTRd9epesvoH
 UscJVXnL9JVXbMfFiUx1oL/AxLxW9cuxpTQkKZmldQ85qBOPIMsTwxyO4umfq4Mr8NOOQg1KS
 ROM/gtdFOqtRa8CNJaNQaWgMGw1pkRPKfCwLN3KplAsZ0fdCJ2xTDmAqkqyEOlF6Sh/P0wYQ8
 NVb8/R4nai+ybaQP6ttBzV7ZO2OPeoQBYIVVpykq37TfIN0eWV5aPDwXyoA97K9TeEk/3ogPW
 3AO+kD5ijptpRi9JsDe9YDlpdOt04EIqwocTAL16W3qMxa3Wmdqp9aY2ipuz8q+A1r4K8tzuh
 jQp0/cD2jgD8keXjmqdXA7Q4jGkmzLStXWgJKJY+ecldnmREya1YZPyisD8n52VG2cD6/V6dL
 gN+13hIqb7pL8cxs+yI6/sTFEaIh0qVCi/uwOJnhM7F5ESPY83WWIkDkXPzifb+EV66DwIaHh
 /9VXlkUivRIE26Vk7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 18=2E April 2021 23:11:44 MESZ schrieb Pablo Neira Ayuso <pablo@netfilte=
r=2Eorg>:
>Patch 2ed37183abb7 ("netfilter: flowtable: separate replace, destroy
>and
>stats to different workqueues") splits the workqueue per event type=2E
>Add
>a mutex to serialize updates=2E
>
>Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading
>support")
>Reported-by: Frank Wunderlich <frank-w@public-files=2Ede>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter=2Eorg>

Hi Pablo,

As far we tested it, the mutex does not avoid the hang=2E It looks a bit b=
etter,but at the end it was fixed by this Patch

https://patchwork=2Ekernel=2Eorg/project/linux-mediatek/patch/202104170729=
05=2E207032-1-dqfext@gmail=2Ecom/

Alex did some tests without the lock here and it still looks stable=2E So =
it looks like it is not needed
regards Frank
