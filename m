Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2775FC3ED
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 12:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiJLKsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 06:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJLKsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 06:48:10 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51372D8;
        Wed, 12 Oct 2022 03:48:08 -0700 (PDT)
Received: from [IPV6:2003:e9:d70e:f1c1:fef2:18a8:26e3:47fd] (p200300e9d70ef1c1fef218a826e347fd.dip0.t-ipconnect.de [IPv6:2003:e9:d70e:f1c1:fef2:18a8:26e3:47fd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 9928DC0212;
        Wed, 12 Oct 2022 12:48:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1665571686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3UR1UGTq1ZiE7tBfuclzdYHdn9LGPnJhAZB1ozJHDUY=;
        b=LagYCHuZQUM4kfUs0h2ZJ0MrgrV5cGsnKj/W6bsoQx4i/fILUYWuI62mn5IstT/9ZjhKr4
        1EfKW/twSozH+Bx0/FQKgDcxjDsNDhylN3V+STekyABDbflJ13HKbINf+CdB1DCyFigFqr
        hvKguQ+6+nohtUsJGrgCyd3g8pF870N8MRFimjE0TeFRW1OZLlVNxC8Ei/Jgm1yfSmgR0E
        nQT0baqXDWt0aH4U7FNaDmlPf0tB9E3GF1BggSmXSof2qmik+vZ0YJgkJAg8rGsAz+siFd
        qKdRzZLZoVpEwJebAB7Dfw1y7DeQ9nD2M3I9Jp4flwzEScnn3MjKXw9bsEB4Rg==
Message-ID: <8be89e06-5b26-6391-0427-b4e5b6ab66ab@datenfreihafen.org>
Date:   Wed, 12 Oct 2022 12:48:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH wpan/next v4 5/8] ieee802154: hwsim: Implement address
 filtering
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20221007085310.503366-1-miquel.raynal@bootlin.com>
 <20221007085310.503366-6-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20221007085310.503366-6-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Miquel.

This patch has given me some checkpatch wawrnings and errors.

Commit d9abecc4a0fc ("ieee802154: hwsim: Implement address filtering")
----------------------------------------------------------------------
CHECK: Blank lines aren't necessary after an open brace '{'
#53: FILE: drivers/net/ieee802154/mac802154_hwsim.c:162:
+	if (hw->phy->filtering == IEEE802154_FILTERING_4_FRAME_FIELDS) {
+

ERROR: code indent should use tabs where possible
#128: FILE: drivers/net/ieee802154/mac802154_hwsim.c:237:
+        }$

WARNING: please, no spaces at the start of a line
#128: FILE: drivers/net/ieee802154/mac802154_hwsim.c:237:
+        }$

total: 1 errors, 1 warnings, 1 checks, 143 lines checked

I fixed this up in palce for you tp proceed with applying this patches. 
Just so you are aware.

regards
Stefan Schmidt
