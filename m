Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE2B4FE307
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355293AbiDLNvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242810AbiDLNvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:51:00 -0400
Received: from smtp-42ac.mail.infomaniak.ch (smtp-42ac.mail.infomaniak.ch [IPv6:2001:1600:4:17::42ac])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB1955760
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:48:41 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Kd6WX1hwtzMpylj;
        Tue, 12 Apr 2022 15:48:40 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Kd6WW57D5zlhMCJ;
        Tue, 12 Apr 2022 15:48:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1649771320;
        bh=TrA2DvyRvfndWMb9xYUPO0MrsUmcO/bFj1ED6seMXF0=;
        h=Date:From:To:Cc:References:Subject:In-Reply-To:From;
        b=iEm5zSK7txjoHyn4XM7N0oBHwUx71LhWTBOrZlemhexaIXc4o+1awU3TWtN2ElzuM
         p3QHoTxkHtsz8oAlHo/mSFDtwET/J38hWtgJtI50LlDKKQDnma6VYJ1UT2F978fqKs
         qS3MjxqJM/BQwD0i9iIZ4aEYPb4kgcZTKDV26gPM=
Message-ID: <1b1c5aaa-9d9a-e38e-42b4-bb0509eba4b5@digikod.net>
Date:   Tue, 12 Apr 2022 15:48:57 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, anton.sirazetdinov@huawei.com
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-8-konstantin.meskhidze@huawei.com>
 <d4724117-167d-00b0-1f10-749b35bffc2f@digikod.net>
Subject: Re: [RFC PATCH v4 07/15] landlock: user space API network support
In-Reply-To: <d4724117-167d-00b0-1f10-749b35bffc2f@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/04/2022 13:21, Mickaël Salaün wrote:
> 
> On 09/03/2022 14:44, Konstantin Meskhidze wrote:

[...]

>> @@ -184,7 +185,7 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
>>
>>       /* Checks content (and 32-bits cast). */
>>       if ((ruleset_attr.handled_access_fs | LANDLOCK_MASK_ACCESS_FS) !=
>> -            LANDLOCK_MASK_ACCESS_FS)
>> +             LANDLOCK_MASK_ACCESS_FS)
> 
> Don't add cosmetic changes. FYI, I'm relying on the way Vim does line 
> cuts, which is mostly tabs. Please try to do the same.

Well, let's make it simple and avoid tacit rules. I'll update most of 
the existing Landlock code and tests to be formatted with clang-format 
(-i *.[ch]), and I'll update the landlock-wip branch so that you can 
base your next patch series on it. There should be some exceptions that 
need customization but we'll see that in the next series. Anyway, don't 
worry too much, just make sure you don't have style-only changes in your 
patches.
