Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EECDF10E8D8
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 11:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfLBKa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 05:30:26 -0500
Received: from mail2.sp2max.com.br ([138.185.4.9]:37412 "EHLO
        mail2.sp2max.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbfLBKa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 05:30:26 -0500
Received: from [172.17.0.170] (unknown [190.246.35.95])
        (Authenticated sender: pablo@fliagreco.com.ar)
        by mail2.sp2max.com.br (Postfix) with ESMTPSA id E837F7B0877;
        Mon,  2 Dec 2019 07:30:17 -0300 (-03)
Subject: Re: [PATCH v1] mt76: mt7615: Fix build with older compilers
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Roy Luo <royluo@google.com>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20191201181716.61892-1-pgreco@centosproject.org>
 <e18d798d-cdf3-da05-c139-403dfc80e8a3@cogentembedded.com>
From:   =?UTF-8?Q?Pablo_Sebasti=c3=a1n_Greco?= <pgreco@centosproject.org>
Message-ID: <5e12af27-be82-894a-1abd-25d1f33a5144@centosproject.org>
Date:   Mon, 2 Dec 2019 07:30:15 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <e18d798d-cdf3-da05-c139-403dfc80e8a3@cogentembedded.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-SP2Max-MailScanner-Information: Please contact the ISP for more information
X-SP2Max-MailScanner-ID: E837F7B0877.A307D
X-SP2Max-MailScanner: Sem Virus encontrado
X-SP2Max-MailScanner-SpamCheck: nao spam, SpamAssassin (not cached,
        escore=-2.9, requerido 6, autolearn=not spam, ALL_TRUSTED -1.00,
        BAYES_00 -1.90)
X-SP2Max-MailScanner-From: pgreco@centosproject.org
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/12/19 06:18, Sergei Shtylyov wrote:
> Hello!
>
> On 01.12.2019 21:17, Pablo Greco wrote:
>
>> Some compilers (tested with 4.8.5 from CentOS 7) fail properly process
>
>    Fail to?
Right
>
>> FIELD_GET inside an inline function, which ends up in a BUILD_BUG_ON.
>> Convert inline function to a macro.
>>
>> Fixes commit bf92e7685100 ("mt76: mt7615: add support for per-chain
>> signal strength reporting")
>
>    Should be:
>
> Fixes: bf92e7685100 ("mt76: mt7615: add support for per-chain signal 
> strength reporting")
>
>    Do not ever break up the Fixes: line and don't insert empty lines 
> between it and other tags.
Ack, I'll fix those for v2
>
>> Reported in https://lkml.org/lkml/2019/9/21/146
>>
>> Reported-by: kbuild test robot <lkp@intel.com>
>> Signed-off-by: Pablo Greco <pgreco@centosproject.org>
> [...]
>
> MBR, Sergei


Thanks, Pablo

