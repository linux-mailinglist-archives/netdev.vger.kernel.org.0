Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDBB6D3F46
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 10:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbjDCInn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 04:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjDCInj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 04:43:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821257EE6;
        Mon,  3 Apr 2023 01:43:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2067261150;
        Mon,  3 Apr 2023 08:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23EE8C4339B;
        Mon,  3 Apr 2023 08:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680511417;
        bh=za2PYURTwJ1KDJ92WhwP6ERqBjgmVTFChbJRUTKlZwc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OeZRvvLJX5dQ487Wh97mIMEJ9FzYb0XADQFQCn47zIj14QWEAjCRvyhr4W8p+nWuL
         sZMQcTh6yf9+EJx4IzgR0ExjhAA3rM4EV9BwUM7aqoKDzWpFdyKP1Om4NQLyYiAhib
         pH87Hj6q2UGCqFoOwFCsiP6c++1vYgP2D2F+PEspihyXKPtspOhNUjBTTrOXXG1zZ7
         eCLxIjUGoJhS1m6kadkh6Gkid823BxsGRe1jb+2Xr7F7guZVNPsVmkevEO0fulwM4l
         VglD13lRvYfi6ZEnK/xPYT+Sm5sWQX6lXSfMiu+E0satOB+BzGRojohhN77fTk0kWq
         dIMhtI5VvEmlQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: linux-next: manual merge of the wireless-next tree with the wireless tree
References: <20230331104959.0b30604d@canb.auug.org.au>
        <20230403122313.6006576b@canb.auug.org.au>
Date:   Mon, 03 Apr 2023 11:43:31 +0300
In-Reply-To: <20230403122313.6006576b@canb.auug.org.au> (Stephen Rothwell's
        message of "Mon, 3 Apr 2023 12:23:13 +1000")
Message-ID: <87iledbbkc.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi all,
>
> On Fri, 31 Mar 2023 10:49:59 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> Today's linux-next merge of the wireless-next tree got a conflict in:
>> 
>>   net/mac80211/rx.c
>> 
>> between commit:
>> 
>>   a16fc38315f2 ("wifi: mac80211: fix potential null pointer dereference")
>> 
>> from the wireless tree and commit:
>> 
>>   fe4a6d2db3ba ("wifi: mac80211: implement support for yet another mesh A-MSDU format")
>> 
>> from the wireless-next tree.
>> 
>> I fixed it up (see below) and can carry the fix as necessary. This
>> is now fixed as far as linux-next is concerned, but any non trivial
>> conflicts should be mentioned to your upstream maintainer when your tree
>> is submitted for merging.  You may also want to consider cooperating
>> with the maintainer of the conflicting tree to minimise any particularly
>> complex conflicts.

[...]

> This is now a conflict between the net-next and net trees.

My plan is to submit wireless-next pull request to net-next by
Wednesday, that should fix the conflict.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
