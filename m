Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B786E3FE8FF
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 07:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238548AbhIBF4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 01:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236858AbhIBF4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 01:56:45 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687CFC061575;
        Wed,  1 Sep 2021 22:55:47 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id l7-20020a0568302b0700b0051c0181deebso1145564otv.12;
        Wed, 01 Sep 2021 22:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZqDFUww5Sd5Bkqsvfw9cDIWu5UIF3ohb1b1raBg52Z8=;
        b=ElnC0VZnQzg7oHz4JKXST89go8Ql3sqORcCHLbEt+xQj2+vg+Xu8v46C4fbqfDoDBT
         33TipFjzhRt5ppdOL1gIac0L+STuVsDvFFatUlgjtxTVJtOULTxNprdqH8vh1Y3s5+Kf
         1eP3qsl7ux2A+xVxlbqWBFE+d7X5wfj3OjaPvIb5IfbT7PndNsnTj9xSZ+87E5KOVdtK
         RY9DmZMCZDXUuMr9uTU9mzd4wIxgoLP2kxfbU2l3Deeu50GVmqF3qq8MLhQSmbSZ5U0o
         yn6Ec+GTHHbSiFRlAijC8b2uSnmUiIN0LG9QRxrDzGZ7KuR+XySWkI9ZR9rM+Xut+tC6
         xlcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZqDFUww5Sd5Bkqsvfw9cDIWu5UIF3ohb1b1raBg52Z8=;
        b=NGpHoxab1P+uSuVpeThEgSaKmaK8C6ThUuCdaPRuHqmWI7hoLBog4lQDuuFcNKA3ll
         IdBgcjmU8qrmH9qEkuvoffkaOuy5KvUZZhF+ntMG8lJO966udPt15WFB65045Bc6Ekon
         f5zxKzlOtRA6AXWrWu9jkWiEWStpgY8kXUmMlrm6i7sNRvOZQwYiIf64HOXxb7mAWanH
         PeLcBOBhVvSvpK0D3NQqjgjLSfKcgKQ6Yre4n94SrHeNLax6mg6Le8u/3jdHDpOV3EbX
         vakgHzm95Qft51+W5etjwk30rhNBZ6cVNPDU+Li5ytaQ/ypI4dhRmqcS5/8OZ7SmicMY
         uDYA==
X-Gm-Message-State: AOAM532myWY7Cyx8zjzMUUoYyMNvbWZ9IZizhfVRC/F1e/UERDcN72n0
        gxxTmskB1NMkKh2lEqNrlZyvpPXKqrw=
X-Google-Smtp-Source: ABdhPJz3SffN5dp3m/PuLhP2c3p9BU6SmEIO3spzk1HIqdBUjpKg71KPCdXzez/VEQBHktEJEpy+ig==
X-Received: by 2002:a05:6830:4003:: with SMTP id h3mr1196031ots.56.1630562146783;
        Wed, 01 Sep 2021 22:55:46 -0700 (PDT)
Received: from ?IPV6:2603:8090:2005:39b3::1027? (2603-8090-2005-39b3-0000-0000-0000-1027.res6.spectrum.com. [2603:8090:2005:39b3::1027])
        by smtp.gmail.com with UTF8SMTPSA id v11sm171244oto.22.2021.09.01.22.55.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 22:55:46 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <bb2a4294-b0b3-e36f-8828-25fde646be2c@lwfinger.net>
Date:   Thu, 2 Sep 2021 00:55:44 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [GIT PULL] Networking for v5.15
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>
References: <20210831203727.3852294-1-kuba@kernel.org>
 <CAHk-=wjB_zBwZ+WR9LOpvgjvaQn=cqryoKigod8QnZs=iYGEhA@mail.gmail.com>
 <20210901124131.0bc62578@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20210901124131.0bc62578@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/21 14:41, Jakub Kicinski wrote:
> On Wed, 1 Sep 2021 12:00:57 -0700 Linus Torvalds wrote:
>> On Tue, Aug 31, 2021 at 1:37 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>>
>>> No conflicts at the time of writing. There were conflicts with
>>> char-misc but I believe Greg dropped the commits in question.
>>
>> Hmm. I already merged this earlier, but didn't notice a new warning on
>> my desktop:
> 
>>    RTNL: assertion failed at net/wireless/core.c (61)
>>    WARNING: CPU: 60 PID: 1720 at net/wireless/core.c:61
>> wiphy_idx_to_wiphy+0xbf/0xd0 [cfg80211]
>>    Call Trace:
>>     nl80211_common_reg_change_event+0xf9/0x1e0 [cfg80211]
>>     reg_process_self_managed_hint+0x23d/0x280 [cfg80211]
>>     regulatory_set_wiphy_regd_sync+0x3a/0x90 [cfg80211]
>>     iwl_mvm_init_mcc+0x170/0x190 [iwlmvm]
>>     iwl_op_mode_mvm_start+0x824/0xa60 [iwlmvm]
>>     iwl_opmode_register+0xd0/0x130 [iwlwifi]
>>     init_module+0x23/0x1000 [iwlmvm]
>>
>> They all seem to have that same issue, and it looks like the fix would
>> be to get the RTN lock in iwl_mvm_init_mcc(), but I didn't really look
>> into it very much.
>>
>> This is on my desktop, and I actually don't _use_ the wireless on this
>> machine. I assume it still works despite the warnings, but they should
>> get fixed.
>>
>> I *don't* see these warnings on my laptop where I actually use
>> wireless, but that one uses ath10k_pci, so it seems this is purely a
>> iwlwifi issue.
>>
>> I can't be the only one that sees this. Hmm?
> 
> Mm. Looking thru the recent commits there is a suspicious rtnl_unlock()
> in commit eb09ae93dabf ("iwlwifi: mvm: load regdomain at INIT stage").
> 
> CC Miri, Johannes
> 

I did not get the bisection finished tonight, but commit eb09ae93dabf is not the 
problem.

My bisection has identified commit 7a3f5b0de36 ("netfilter: add netfilter hooks 
to SRv6 data plane") as bad, and commit 9055a2f59162 ("ixp4xx_eth: make ptp 
support a platform driver") as good.

Larry
