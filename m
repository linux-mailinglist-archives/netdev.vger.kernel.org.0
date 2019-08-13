Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 552158B98D
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 15:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbfHMNJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 09:09:29 -0400
Received: from mx2.mailbox.org ([80.241.60.215]:46562 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbfHMNJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 09:09:29 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id 3EBCDA335B;
        Tue, 13 Aug 2019 15:09:26 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id 5zLXc_MXTiBD; Tue, 13 Aug 2019 15:09:24 +0200 (CEST)
Subject: Re: [PATCH] net: ethernet: mediatek: Add MT7628/88 SoC support
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Felix Fietkau <nbd@openwrt.org>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-mediatek@lists.infradead.org, John Crispin <john@phrozen.org>
References: <20190717110243.14240-1-sr@denx.de>
 <20190717121506.GD18996@makrotopia.org>
From:   Stefan Roese <sr@denx.de>
Message-ID: <b2258258-af40-3e0d-f771-a70428ec798f@denx.de>
Date:   Tue, 13 Aug 2019 15:09:23 +0200
MIME-Version: 1.0
In-Reply-To: <20190717121506.GD18996@makrotopia.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.07.19 14:15, Daniel Golle wrote:
> On Wed, Jul 17, 2019 at 01:02:43PM +0200, Stefan Roese wrote:
>> This patch adds support for the MediaTek MT7628/88 SoCs to the common
>> MediaTek ethernet driver. Some minor changes are needed for this and
>> a bigger change, as the MT7628 does not support QDMA (only PDMA).
> 
> The Ethernet core found in MT7628/88 is identical to that found in
> Ralink Rt5350F SoC. Wouldn't it hence make sense to indicate that
> in the compatible string of this driver as well? In OpenWrt we are
> using "ralink,rt5350-eth".

Okay. I'll use this ralink compatible instead in the next version.

Thanks,
Stefan
