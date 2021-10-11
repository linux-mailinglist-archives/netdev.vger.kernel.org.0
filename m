Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2224293D6
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 17:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238768AbhJKPzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 11:55:50 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:37402 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbhJKPzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 11:55:48 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru BE77C236642E
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 00/14] Add functional support for Gigabit Ethernet driver
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
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
 <5b3893d9-a233-5d22-0873-f9da87b3180e@omp.ru>
Organization: Open Mobile Platform
Message-ID: <c9bc0d3d-dc38-3e98-7d18-57d3f366a8b3@omp.ru>
Date:   Mon, 11 Oct 2021 18:53:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5b3893d9-a233-5d22-0873-f9da87b3180e@omp.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/10/21 12:55 PM, Sergey Shtylyov wrote:

> [...]
>>>     DaveM, I'm going to review this patch series (starting on Monday). Is that acceptable forewarning? :-)
>>
>> Yes, thank you.
> 
>    And I have started reviewing the next version already.

   I think I've finished reviewing the series now. The only issue was in the patch #13. :-)

MBR, Sergey
