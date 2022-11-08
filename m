Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9E2620970
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 07:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbiKHGSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 01:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbiKHGSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 01:18:50 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2CA2CDD7;
        Mon,  7 Nov 2022 22:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RhMQqSmSDIk86OkNhYxSYS1rmamG8syzt00HQJmRgKE=; b=qljZ5WgTOmxOhQB/4P1n08yvsa
        lCC6ccbcCXu9EgFDQ0LYfZGGpYHCdd6xle7vX1Y6cybuICC4c72UslzMIyRl6S5cvDkbmca/YlJmi
        AUq7V3NtJ17oM1zjvnAnBWtnlyjZvizOoV1ax/IXq/Iz/b6wyHmJxOqxER7g3kKgqw98=;
Received: from p200300daa72ee1006d973cebf3767a25.dip0.t-ipconnect.de ([2003:da:a72e:e100:6d97:3ceb:f376:7a25] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1osHwR-000S8C-2S; Tue, 08 Nov 2022 07:18:35 +0100
Message-ID: <57e6257f-2ae4-def0-8580-2f00284c9e8f@nbd.name>
Date:   Tue, 8 Nov 2022 07:18:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH 05/14] net: dsa: tag_mtk: assign per-port queues
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20221107185452.90711-1-nbd@nbd.name>
 <20221107185452.90711-5-nbd@nbd.name> <20221107204034.bwbhyhahku4m2xdd@skbuf>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20221107204034.bwbhyhahku4m2xdd@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.11.22 21:40, Vladimir Oltean wrote:
> Hi Felix,
> 
> On Mon, Nov 07, 2022 at 07:54:43PM +0100, Felix Fietkau wrote:
>> Keeps traffic sent to the switch within link speed limits
>> 
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> ---
> 
> Do you have a patch 00/14 that explains what you're up to? I'm only
> copied on 05/14 and 10/14, hard to get an idea.
I will add it in v2
