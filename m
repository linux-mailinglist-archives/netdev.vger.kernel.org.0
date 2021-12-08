Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69A446D7FE
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 17:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236773AbhLHQYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 11:24:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236771AbhLHQYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 11:24:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6004EC061746;
        Wed,  8 Dec 2021 08:21:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2929CB82153;
        Wed,  8 Dec 2021 16:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92062C00446;
        Wed,  8 Dec 2021 16:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638980472;
        bh=dfh/isS6FteIY4Nj5z9+E+uCSpH23ToHoVeBIB0Zvwk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QhUz1oe536YSYlnMHxj5kzSRB63xQ/nkllgH9tCKK957q1zMROrlzCaEnCTVz/4ES
         eJbUNsmwXve2Pm/7fVSx2LTuz6/GZon9iaHbYL/SWREOFns0okovw72FkNCY7s4IA/
         /ZxMKZBH0NtXnZQ8mBbdev4C3E3SEVMaadwPSiUkUmQaRadN58ROnCCtjB2u3W/HEx
         c19O592oQX65OB2xqcnm+bokt4uDWCMdHMh+D/bUeUv2NnzPINnIS37hK6xPCNLOeF
         tMljbzZzaXIHhDNkweJITeD2AUp6EM5nyrA0N4nPrJjmKg6PBNERVE/mPhmm9knUzy
         Ab581l/Y3udJA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Luciano Coelho <luca@coelho.fi>,
        Loic Poulain <loic.poulain@linaro.org>
Subject: Re: pull-request: wireless-drivers-next-2021-12-07
References: <20211207144211.A9949C341C1@smtp.kernel.org>
        <20211207211412.13c78ace@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87tufjfrw0.fsf@codeaurora.org>
        <20211208065025.7060225d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Wed, 08 Dec 2021 18:21:08 +0200
In-Reply-To: <20211208065025.7060225d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Wed, 8 Dec 2021 06:50:25 -0800")
Message-ID: <87zgpb83uz.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 08 Dec 2021 10:00:15 +0200 Kalle Valo wrote:
>> Jakub Kicinski <kuba@kernel.org> writes:
>> 
>> > On Tue,  7 Dec 2021 14:42:11 +0000 (UTC) Kalle Valo wrote:  
>> >> here's a pull request to net-next tree, more info below. Please let me know if
>> >> there are any problems.  
>> >
>> > Pulled, thanks! Could you chase the appropriate people so that the new
>> > W=1 C=1 warnings get resolved before the merge window's here?
>> >
>> > https://patchwork.kernel.org/project/netdevbpf/patch/20211207144211.A9949C341C1@smtp.kernel.org/
>> 
>> Just so that I understand right, you are referring to this patchwork
>> test:
>> 
>>   Errors and warnings before: 111 this patch: 115
>> 
>>   https://patchwork.hopto.org/static/nipa/591659/12662005/build_32bit/
>> 
>> And you want the four new warnings to be fixed? That can be quite time
>> consuming, to be honest I would rather revert the commits than using a
>> lot of my time trying to get people fix the warnings. Is there an easy
>> way to find what are the new warnings?
>
> Yeah, scroll down, there is a diff of the old warnings vs new ones, and
> a summary of which files have changed their warning count:
>
> +      2 ../drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +      3 ../drivers/net/wireless/intel/iwlwifi/mei/main.c
> -      1 ../drivers/net/wireless/intel/iwlwifi/mvm/ops.c
> +      2 ../drivers/net/wireless/intel/iwlwifi/mvm/ops.c
> -      2 ../drivers/net/wireless/microchip/wilc1000/wlan.c

Ah, that makes it easier.

> So presumably these are the warnings that were added:
>
> drivers/net/wireless/intel/iwlwifi/mei/main.c:193: warning: cannot
> understand function prototype: 'struct '
> drivers/net/wireless/intel/iwlwifi/mei/main.c:1784: warning: Function
> parameter or member 'cldev' not described in 'iwl_mei_probe'
> drivers/net/wireless/intel/iwlwifi/mei/main.c:1784: warning: Function
> parameter or member 'id' not described in 'iwl_mei_probe'

Luca, please take a look and send a patch. I'll then apply it directly
to wireless-drivers-next.

> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:3911:28:
> warning: incorrect type in assignment (different base types)
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:3911:28:
> expected restricted __le32 [assigned] [usertype] period_msec
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:3911:28:
> got restricted __le16 [usertype]
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:3913:30:
> warning: incorrect type in assignment (different base types)
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:3913:30:
> expected unsigned char [assigned] [usertype] keep_alive_id
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:3913:30:
> got restricted __le16 [usertype]

Loic, your patch should fix these, right?

https://patchwork.kernel.org/project/linux-wireless/patch/1638953708-29192-1-git-send-email-loic.poulain@linaro.org/

> drivers/net/wireless/intel/iwlwifi/mvm/ops.c:684:12: warning: context
> imbalance in 'iwl_mvm_start_get_nvm' - wrong count at exit

Luca, please also take a look at this.

>> But in the big picture are you saying the net trees now have a rule that
>> no new W=1 and C=1 warnings are allowed? I do test ath10k and ath11k
>> drivers for W=1 and C=1 warnings, but all other drivers are on their own
>> in this regard. At the moment I have no tooling in place to check all
>> wireless drivers.
>
> For the code we merge directly we try to make sure there are no new
> warnings. I realize it's quite a bit of work for larger trees unless 
> you have the infra so not a hard requirement (for you).

Yeah, at the moment I really would not be able to catch W=1 or sparse
warnings :/ And fixing them afterwards is just too slow. But if we would
be able to fix all the warnings in drivers/net/wireless then it would be
easy for me to enable W=1 and C=1 in my own build tests.

> FWIW the build bot we wrote is available on GH:
>
> https://github.com/kuba-moo/nipa
>
> But it currently hard codes tree matching logic for bpf and netdev,
> so would probably take a few hours to adopt it.

Thanks, it would good to have a similar system for wireless trees.
Anyone want to help? :)

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
