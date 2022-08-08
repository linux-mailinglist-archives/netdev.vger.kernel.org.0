Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF7058C4C7
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 10:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242107AbiHHIPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 04:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235829AbiHHIPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 04:15:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C007112766;
        Mon,  8 Aug 2022 01:14:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 671EEB80DD4;
        Mon,  8 Aug 2022 08:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8C5C433C1;
        Mon,  8 Aug 2022 08:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659946494;
        bh=0OXUkXX376kyAHVXmoOG156albxqwH2Te1I39j40MbY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ez+poJ/XnFkEToDwAtcVXoXUfxRHnyfkNaPTnN2ApHlazHs+4kmaZRK7hgzZ2bfG+
         FUj+Z4XC6WRouxQw5/vOoFEgiT4fRRKP8j3rORJFj56uOZi73ysVkSEnaA5Mfxblv5
         o3c8B/THXqf0YUzoHbbgXSxyYl2kf/uUf1V8LF6zxjyFIiizokgRpTHqGBM+KyDqeU
         roW38rOnweACTiuUDtZ2gyYzHnpplMg1OLNIZKi8Cz76I0skxfOhsPvPZORKtkJ1ID
         N0Q/bxYjdBYMejOyuk1x2yTRVvM7ykLGPGY0c0e48kJ5VHqQrDywy4Ed7ADIj8qMQI
         QgF9J3UIyZrQw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Veerendranath Jakkam <quic_vjakkam@quicinc.com>,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <aspriel@gmail.com>
Subject: Re: [GIT PULL] Networking for 6.0
References: <20220803101438.24327-1-pabeni@redhat.com>
        <CAHk-=wjhSSHM+ESVnchxazGx4Vi0fEfmHpwYxE45JZDSC8SUAQ@mail.gmail.com>
        <87les4id7b.fsf@kernel.org> <877d3mixdh.fsf@kernel.org>
        <CAHk-=wiW62CSONUNdpPcohmnTOtF_Fa4tSrz-H+pqE3VmpuARA@mail.gmail.com>
Date:   Mon, 08 Aug 2022 11:14:48 +0300
In-Reply-To: <CAHk-=wiW62CSONUNdpPcohmnTOtF_Fa4tSrz-H+pqE3VmpuARA@mail.gmail.com>
        (Linus Torvalds's message of "Fri, 5 Aug 2022 09:34:54 -0700")
Message-ID: <8735e7i22v.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, Aug 5, 2022 at 7:22 AM Kalle Valo <kvalo@kernel.org> wrote:
>>
>> Linus, do you want to take that directly or should I take it to wireless
>> tree? I assume with the latter you would then get it by the end of next
>> week.
>
> This isn't holding anything up on my side for the merge window - it's
> just a warning, and the machine works fine.
>
> So there's little reason to bypass the normal channels, and getting it
> to me by next week is fine.

Ok, let's do that. I now applied the fix:

https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git/commit/?id=baa56dfe2cdad12edb2625b2d454e205943c3402

Network folks, I'm planning to submit a pull request on Tuesday or
Wednesday. Do you still submit your pull requests to Linus on Thursdays?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
