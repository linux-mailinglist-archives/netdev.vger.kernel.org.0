Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363554FA8E2
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 16:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237605AbiDIOGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 10:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbiDIOGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 10:06:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B831B0872;
        Sat,  9 Apr 2022 07:04:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84951B8077C;
        Sat,  9 Apr 2022 14:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C98C385A5;
        Sat,  9 Apr 2022 14:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649513080;
        bh=zievYVdLv+9vKUkxHVkX8JwkyASvlTW3XyBUrGiDIjY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iZCbhqh2W2bhfEpwg/m8+xYMGEojJG1mFQkQz3ahCZkDy5vtUijXWbYu3GDht7Ciz
         svbUpsdL6Ryat9F9PXEobawy+KYOu5XC4dKHp72wg96CyyeeR3bFqKJfe+WtudOb2w
         M8tYKtRHqPomEMk+nnhdNyEGLQSzuZWzRAUxDxJfsrBZydzbsJ9ZoZRZDUNDNf5VNX
         QkcarkJwgXwZEPb6UtGe345aWY7ShdEs1WnGwnV3Qphan7IWxvIndeMEkmmgwL5haU
         C2iXrQQgJ4N2Gp0DayF9eTuTlAXhcACeSH2XEbORmDlZR4KAoChPtUd6ymv352T6uo
         hyzT4Ykxm9v/A==
Date:   Sat, 9 Apr 2022 10:04:33 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ben Greear <greearb@candelatech.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        johannes.berg@intel.com, avraham.stern@intel.com,
        ayala.beker@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.17 079/149] iwlwifi: mvm: Passively scan non
 PSC channels only when requested so
Message-ID: <YlGScTmtwt+1TsIS@sashalap>
References: <20220401142536.1948161-1-sashal@kernel.org>
 <20220401142536.1948161-79-sashal@kernel.org>
 <acabc18a-79ff-9080-232e-532c321bdbae@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <acabc18a-79ff-9080-232e-532c321bdbae@candelatech.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 01, 2022 at 07:52:39AM -0700, Ben Greear wrote:
>I had to revert this patch in my 5.17+ kernel (with 5.18-ish iwlwifi patches backported)
>to get the station to properly scan and connect to a vendor's AP.
>
>I got zero response to my earlier email about that regression.
>
>I think this is not something that should be added to stable builds at this time.

Agreed and dropped, thanks.

-- 
Thanks,
Sasha
