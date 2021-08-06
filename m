Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1FC3E29BF
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 13:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245565AbhHFLdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 07:33:33 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.166.231]:41038 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245540AbhHFLdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 07:33:32 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Aug 2021 07:33:32 EDT
Received: from bld-lvn-bcawlan-34.lvn.broadcom.net (bld-lvn-bcawlan-34.lvn.broadcom.net [10.75.138.137])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id F0C167FFA;
        Fri,  6 Aug 2021 04:23:17 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com F0C167FFA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1628248998;
        bh=Jr1JdI9/CVhnPEppjM4hGw5lZqvxFIHWJWTGtlGgjvw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=FeFEiAVkrPA13FeM5iTdS5lcG1xWHt+sLhfpLXqlgpjL4ZAfnE+vWXrXoXK3sH6C7
         u4ilFNKmqTAiSoh9RJfvgEB2DIZRjlcoOpp8iMO6lHOf9AjDiiUeiWkMyFZbFfVsz2
         lRd2H1k1I/ifAY+8HwhbUAnV6Rs2tmziYhS2SFL0=
Received: from [10.230.42.155] (unknown [10.230.42.155])
        by bld-lvn-bcawlan-34.lvn.broadcom.net (Postfix) with ESMTPSA id 068E31874BD;
        Fri,  6 Aug 2021 04:23:11 -0700 (PDT)
Subject: Re: [PATCH][next] brcmfmac: firmware: Fix uninitialized variable ret
To:     Kalle Valo <kvalo@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Colin King <colin.king@canonical.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210803150904.80119-1-colin.king@canonical.com>
 <CACRpkdZ5u-C8uH2pCr1689v_ndyzqevDDksXvtPYv=FfD=x_xg@mail.gmail.com>
 <875ywkc80d.fsf@codeaurora.org>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <96709926-30c6-457e-3e80-eb7ad6e9d778@broadcom.com>
Date:   Fri, 6 Aug 2021 13:23:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <875ywkc80d.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05-08-2021 15:53, Kalle Valo wrote:
> Linus Walleij <linus.walleij@linaro.org> writes:
> 
>> On Tue, Aug 3, 2021 at 5:09 PM Colin King <colin.king@canonical.com> wrote:
>>
>>> From: Colin Ian King <colin.king@canonical.com>
>>>
>>> Currently the variable ret is uninitialized and is only set if
>>> the pointer alt_path is non-null. Fix this by ininitializing ret
>>> to zero.
>>>
>>> Addresses-Coverity: ("Uninitialized scalar variable")
>>> Fixes: 5ff013914c62 ("brcmfmac: firmware: Allow per-board firmware binaries")
>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>
>> Nice catch!
>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> I assume this will be fixed by Linus' patch "brcmfmac: firmware: Fix
> firmware loading" and I should drop Colin's patch, correct?

That would be my assumption as well, but not sure when he will submit 
another revision of it. You probably know what to do ;-)

Regards,
Arend
