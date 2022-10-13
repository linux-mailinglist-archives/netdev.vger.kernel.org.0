Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D525FE14F
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 20:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiJMSdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 14:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbiJMSdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 14:33:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00333ECE4;
        Thu, 13 Oct 2022 11:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F8A26188A;
        Thu, 13 Oct 2022 18:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C935EC433C1;
        Thu, 13 Oct 2022 18:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665684998;
        bh=oCQNci6QkcHEdVyUUCpGDjibQhR/MN8r4Pz+yko1DuI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XKMw1vKkr3wH0bIEr5EHUCdy9UYdw5WjLPuN7oT/EK+NNlLaJ7gUmrOHKldj4c84j
         9ZWUkK0HGF5OTERHq1TMG6sQjJUfV9CLBFJSTCpcDHaTZkBDyPX2Bi/7bOLqjMO1pE
         VxY5dZCdKCR2rGzbaqSuUb9DfLdFUk8a9TZXhnF4qIGZQq+KUCempCIFrewAzVIhtx
         hdUILzmDtHhs3udsclTSR9cgY9oCkd++SY1ajOUbIcGYSKJs9b9zu8X/hV97T0/gHt
         cEzRbmeWPVA4cb5RFBIVNTV6qtHC9jBDuknaWecWRAd8WCFOOeMOLmMjAIakaQ2NIR
         kj89yIpH18OsA==
Date:   Thu, 13 Oct 2022 14:16:36 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 16/77] wifi: mac80211: fix control port frame
 addressing
Message-ID: <Y0hWBJs1y9DyHpCu@sashalap>
References: <20221009220754.1214186-1-sashal@kernel.org>
 <20221009220754.1214186-16-sashal@kernel.org>
 <8acb94e9bd6d580f739e81e5f203cb93028adf4e.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8acb94e9bd6d580f739e81e5f203cb93028adf4e.camel@sipsolutions.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 09:03:52AM +0200, Johannes Berg wrote:
>On Sun, 2022-10-09 at 18:06 -0400, Sasha Levin wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> [ Upstream commit a6ba64d0b187109dc252969c1fc9e2525868bd49 ]
>>
>> For an AP interface, when userspace specifieds the link ID to
>> transmit the control port frame on (in particular for the
>> initial 4-way-HS), due to the logic in ieee80211_build_hdr()
>> for a frame transmitted from/to an MLD
>
>FWIW, I don't mind this being backported, but it doesn't make all that
>much sense since the only driver "supporting" all this MLO/MLD/link_id
>stuff upstream is hwsim, and it's not really finished anyway.

Happy to drop it, thanks.

-- 
Thanks,
Sasha
