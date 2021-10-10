Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDF1428057
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 11:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhJJJ53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 05:57:29 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:57110 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbhJJJ52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 05:57:28 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 9925A22F1308
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 00/14] Add functional support for Gigabit Ethernet driver
To:     David Miller <davem@davemloft.net>
CC:     <biju.das.jz@bp.renesas.com>, <kuba@kernel.org>,
        <prabhakar.mahadev-lad.rj@bp.renesas.com>, <andrew@lunn.ch>,
        <geert+renesas@glider.be>, <aford173@gmail.com>,
        <yoshihiro.shimoda.uh@renesas.com>, <netdev@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, <Chris.Paterson2@renesas.com>,
        <biju.das@bp.renesas.com>
References: <20211009190802.18585-1-biju.das.jz@bp.renesas.com>
 <ccdd66e0-5d67-905d-a2ff-65ca95d2680a@omp.ru>
 <20211010.103812.371946148270616666.davem@davemloft.net>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <5b3893d9-a233-5d22-0873-f9da87b3180e@omp.ru>
Date:   Sun, 10 Oct 2021 12:55:25 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211010.103812.371946148270616666.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.10.2021 12:38, David Miller wrote:

[...]
>>     DaveM, I'm going to review this patch series (starting on Monday). Is that acceptable forewarning? :-)
> 
> Yes, thank you.

    And I have started reviewing the next version already.

MBR, Sergey
