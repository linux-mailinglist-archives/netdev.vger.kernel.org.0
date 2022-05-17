Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9114752A050
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 13:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245548AbiEQLV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 07:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345215AbiEQLV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 07:21:27 -0400
X-Greylist: delayed 101540 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 17 May 2022 04:21:25 PDT
Received: from mout-u-107.mailbox.org (mout-u-107.mailbox.org [91.198.250.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D79D17AA4
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 04:21:25 -0700 (PDT)
Received: from smtp2.mailbox.org (unknown [91.198.250.124])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-u-107.mailbox.org (Postfix) with ESMTPS id 4L2YbP3jc2z9sRX;
        Tue, 17 May 2022 13:21:21 +0200 (CEST)
Message-ID: <c8e782cb-49cc-e792-9573-8fd2e5515c50@denx.de>
Date:   Tue, 17 May 2022 13:21:19 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v2] net: phy: marvell: Add errata section 5.1 for Alaska
 PHY
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Leszek Polak <lpolak@arri.de>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
References: <20220516070859.549170-1-sr@denx.de>
 <163e90e736803c670ce88f2b2b1174eddc1060a2.camel@redhat.com>
From:   Stefan Roese <sr@denx.de>
In-Reply-To: <163e90e736803c670ce88f2b2b1174eddc1060a2.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4L2YbP3jc2z9sRX
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

On 17.05.22 13:01, Paolo Abeni wrote:
> Hello,
> 
> On Mon, 2022-05-16 at 09:08 +0200, Stefan Roese wrote:
>> From: Leszek Polak <lpolak@arri.de>
>>
>> As per Errata Section 5.1, if EEE is intended to be used, some register
>> writes must be done once after every hardware reset. This patch now adds
>> the necessary register writes as listed in the Marvell errata.
>>
>> Without this fix we experience ethernet problems on some of our boards
>> equipped with a new version of this ethernet PHY (different supplier).
>>
>> The fix applies to Marvell Alaska 88E1510/88E1518/88E1512/88E1514
>> Rev. A0.
>>
>> Signed-off-by: Leszek Polak <lpolak@arri.de>
>> Signed-off-by: Stefan Roese <sr@denx.de>
>> Cc: Marek Behún <kabel@kernel.org>
>> Cc: Andrew Lunn <andrew@lunn.ch>
>> Cc: Heiner Kallweit <hkallweit1@gmail.com>
>> Cc: Russell King <linux@armlinux.org.uk>
>> Cc: David S. Miller <davem@davemloft.net>
> 
> It's not clear to me if you are targeting -net or net-next, could you
> please clarify? In case this is for -net, please add a suitable fixes
> tag, thanks!

Sorry for not being clear on this. net-next is good AFAICT.

Should I re-submit to net-next?

Thanks,
Stefan
