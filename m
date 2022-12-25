Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80017655ECE
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 00:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiLYXyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 18:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLYXyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 18:54:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CD5E31;
        Sun, 25 Dec 2022 15:54:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1C4DACE0B86;
        Sun, 25 Dec 2022 23:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8B6C433D2;
        Sun, 25 Dec 2022 23:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672012457;
        bh=j+ZdVuR9dCS/DutldZb/9nGAJtPFmVc9foFGRdJ9RQk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VgS4F1LhkbB9QUt6yISgeD5GDc8/NI5FVMSNU3rXdZgdrRZ2Y6CkT092QIhZGgmjC
         p5IuUl6aWeTde0P7yvus2kTxKxMgJO4M76CWauS+Kny/e3nJxzeROaiWaFVJbDvIw0
         wIRsJgppJV6NT29L6AkguGbypMbRz6eb3zMQAArwcdiboefv5R153hWQuOUugNGGyv
         ewnSfAKcuzVgshc+72+kdz0doz3RdqMXMLHkshkIwDhmPaVWRvkKBn4JVtjrY6muOp
         xZDJhVSMLNKRsbIYKGdg1VuJVRkVg6jsATVJbTrdM/H+EKIKbHVqy9rxSKxzosCetl
         JJ9hopkGnMoqA==
Date:   Sun, 25 Dec 2022 18:54:15 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     stable@vger.kernel.org, stable-commits@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: Patch "net: dpaa2: publish MAC stringset to ethtool -S even if
 MAC is missing" has been added to the 5.15-stable tree
Message-ID: <Y6jip3j91Vt9b8rd@sashalap>
References: <20221225151438.695754-1-sashal@kernel.org>
 <20221225221628.kxllljzeh3h4zwyh@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221225221628.kxllljzeh3h4zwyh@skbuf>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 26, 2022 at 12:16:28AM +0200, Vladimir Oltean wrote:
>Hi Sasha,
>
>On Sun, Dec 25, 2022 at 10:14:37AM -0500, Sasha Levin wrote:
>> This is a note to let you know that I've just added the patch titled
>>
>>     net: dpaa2: publish MAC stringset to ethtool -S even if MAC is missing
>>
>> to the 5.15-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>      net-dpaa2-publish-mac-stringset-to-ethtool-s-even-if.patch
>> and it can be found in the queue-5.15 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>
>Didn't we just discuss that this patch should be dropped from the stable
>queues for 5.15, 6.0 and 6.1, and didn't you just say that you'll drop it?
>https://lore.kernel.org/netdev/Y6ZH4YCuBSiPDMNd@sashalap/

Sorry, I messed up there, now dropped!

-- 
Thanks,
Sasha
