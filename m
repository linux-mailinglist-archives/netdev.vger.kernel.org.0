Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083AC69D5EC
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 22:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbjBTVo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 16:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbjBTVou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 16:44:50 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1C3212BA;
        Mon, 20 Feb 2023 13:44:48 -0800 (PST)
Received: from [IPV6:2003:e9:d746:344d:8e4a:ccf0:3715:218] (p200300e9d746344d8e4accf037150218.dip0.t-ipconnect.de [IPv6:2003:e9:d746:344d:8e4a:ccf0:3715:218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 9A132C02EE;
        Mon, 20 Feb 2023 22:44:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1676929485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VwEDbzZkKFU6YesWTOG/gWUwKBtOzeBHko+LlxGLZwQ=;
        b=MAcvBQf3FIX3LOnWaPRvtDv/UHYgqEik2lJzCoyxVRCaq3VPMn0g0S9Uu37KC0Stn+NH6a
        tk/XWD1LXrHvtcCD1furXMT93sfjs82yuFH92fWCPA5v5SRtNiXnpKiwufverDaQV4Q920
        L5B2JbhYoXpAgsVmD25yTeZp0+iDEXOc1a3ZnJGfkEx80qAtTBeyUrmvwQoydhBwIzLl+L
        9pb2crA2xeR+Y68JKzsIMYDFZ4i85mjUMs9dFQY2yEmPLJXuS6dJKUZ1qeqPksocRZ0IR1
        uSMHKZETy0UdU6fJe4zVAg6NZYM/nZ99Qwgnh+NvA83Dj75EFKBpRVYfjSpe8A==
Message-ID: <f8daefff-fe19-18f7-df57-f8e00ea1c7ad@datenfreihafen.org>
Date:   Mon, 20 Feb 2023 22:44:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: pull-request: ieee802154-next 2023-02-02
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     davem@davemloft.net, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
References: <20230202153723.1554935-1-stefan@datenfreihafen.org>
 <20230203202147.56106b5b@kernel.org> <20230204124656.470db6b7@xps-13>
 <20230204111800.24d6e856@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230204111800.24d6e856@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub.

On 04.02.23 20:18, Jakub Kicinski wrote:
> On Sat, 4 Feb 2023 12:46:56 +0100 Miquel Raynal wrote:
>>> I left some comments on the netlink part, sorry for not looking
>>> at it earlier.
>>
>> As I'm not extremely comfortable with all the netlink conventions I
>> might have squeezed "important" checks, I will try to make the code
>> more robust as you suggested.
>>
>> I will do my best to address these, probably next week, do you prefer
>> to wait for these additional changes to apply on top of wpan-next and
>> Stefan to rush with another PR before -rc8? Or do you accept to pull the
>> changes now and to receive a couple of patches in a following fixes
>> PR? (the latter would be the best IMHO, but it's of course up to you).
> 
> I have a slight preference to wait with the pulling until the fixes/
> refactoring arrives.

The new pull request as v2 has just been posted.

regards
Stefan Schmidt
