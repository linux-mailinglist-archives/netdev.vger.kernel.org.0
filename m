Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E56B5AFFE6
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 11:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiIGJIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 05:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiIGJIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 05:08:05 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5FB80B59;
        Wed,  7 Sep 2022 02:08:05 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id BB5E211C;
        Wed,  7 Sep 2022 11:08:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1662541683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wW0b62MlfAbb/f+HVMrwfT83j7W18iBp15xrkVEopNs=;
        b=QB8yJlBxzji3Ww53mhp2ZK1VCZV5AQK0/J8sm48nW4r7wWW0MXMBlMcBG03zH85bPRYXQt
        UM/xsgiFBBGKqaExLy1OnuS61KWRvIWSzf16V5ypM27vfooNY984kRe0m+ESjsmq5XbzL8
        G7Uvhq2clcqvhLimq/mjF9+oqsPT2oMWlYYHGHfhm2xKjZwGW2pCtIExsMRrsAu7BGxW91
        QySNtLK4kb7WMuVupGysfD8JErifBPLBygIUcS3XCDvppHsIqzjI0U9NKjNPYK0RIVgxVt
        XtZOpUwbb8gpwb5/IAiltKUJw1DwrmV/i1jc4vNjKkmgpsOEVUqvVIQHk6pZKQ==
From:   Michael Walle <michael@walle.cc>
To:     Divya.Koppera@microchip.com
Cc:     andrew@lunn.ch, UNGLinuxDriver@microchip.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, pabeni@redhat.com,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH v2 net-next] net: phy: micrel: Adding SQI support for lan8814 phy
Date:   Wed,  7 Sep 2022 11:07:50 +0200
Message-Id: <20220907090750.2937889-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <YxX1I6wBFjzID2Ls@lunn.ch>
References: <YxX1I6wBFjzID2Ls@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Sep 05, 2022 at 03:47:30PM +0530, Divya Koppera wrote:
>> Supports SQI(Signal Quality Index) for lan8814 phy, where
>> it has SQI index of 0-7 values and this indicator can be used
>> for cable integrity diagnostic and investigating other noise
>> sources. It is not supported for 10Mbps speed
>> 
>> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
>> ---
>> v1 -> v2
>> - Given SQI support for all pairs of wires in 1000/100 base-T phy's
>>   uAPI may run through all instances in future. At present returning
>>   only first instance as uAPI supports for only 1 pair.
>> - SQI is not supported for 10Mbps speed, handled accordingly.
>
> I would prefer you solve the problem of returning all pairs.
> 
> I'm not sure how useful the current implementation is, especially at
> 100Mbps, where pair 0 could actually be the transmit pair. Does it
> give a sensible value in that case?

It is good practice to CC the patches to the ones who gave feedback
on the previous versions. Not everyone is subscribed to all the
high traffic mailinglist.

Thanks,
-michael
