Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6911C431EFF
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhJROJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:09:56 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:37595 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234091AbhJROIJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:08:09 -0400
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 64AF661E5FE33;
        Mon, 18 Oct 2021 16:05:57 +0200 (CEST)
Subject: Re: [Intel-wired-lan] [PATCH 1/1] ice: compact the file ice_nvm.c
To:     Yanjun Zhu <yanjun.zhu@linux.dev>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
References: <20211018131713.3478-1-yanjun.zhu@linux.dev>
 <c1903730-9508-1fef-4232-3a5b62f28d7c@molgen.mpg.de>
 <087710e9-2aeb-c070-cebb-82ae9cb5c20e@linux.dev>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <10c80bab-db74-b567-505c-95d74763248f@molgen.mpg.de>
Date:   Mon, 18 Oct 2021 16:05:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <087710e9-2aeb-c070-cebb-82ae9cb5c20e@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Yanjun,


Am 18.10.21 um 16:00 schrieb Yanjun Zhu:

> 在 2021/10/18 21:44, Paul Menzel 写道:

>> Am 18.10.21 um 15:17 schrieb yanjun.zhu@linux.dev:
>>> From: Zhu Yanjun <yanjun.zhu@linux.dev>
>>>
>>> The function ice_aq_nvm_update_empr is not used, so remove it.
>>
>> Thank you for the patch. Could you please make the commit message 
>> summary more descriptive? Maybe:
>>
>>> ice: Remove unused `ice_aq_nvm_update_empr()`
>>
>> If you find out, what commit removed the usage, that would be also 
>> good to document, but it’s not that important.
> 
> Thanks for your suggestion.
> 
> IMO, removing the unused function is one method of compact file.
> 
> I agree with you that the commit message summary is not important.

Sorry, you misunderstood me. The commit message summary is my opinion 
very important, as it’s what shown in `git log --oneline`, and in this 
case everybody has to read the full commit message to know what the 
commit actually as *compact* is not conveying this meaning and is ambiguous.

Not as important is finding the commit removing the last user, and 
adding a Fixes tag with it.

> If someone finds more important problem in this commit, I will resend the
> 
> patch and change the commit message summary based on your suggestion.

It’d be great, if you sent an improved version.


Kind regards,

Paul
