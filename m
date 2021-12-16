Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A64B476D3B
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 10:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235179AbhLPJSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 04:18:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40216 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235163AbhLPJSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 04:18:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DA1BB82273;
        Thu, 16 Dec 2021 09:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95CEC36AE2;
        Thu, 16 Dec 2021 09:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639646313;
        bh=GemqB+hSqdhqV2+LmupsOCkmp2mc3s7bLwHxny7XjLo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SroI5Q8kNDDHIUnAZINLH9/KeaReyNJGfJ+oLwtW4MCVZ6qEKk6mQzC/atwU0PlkE
         6dCbFyYX6v9qcbpsVVu7LEpQv9G9KGkDK8dFmthOJe7thWvkAn7V+fff7ql/YqR3em
         W7bXgKXQ+avNH1kU9Y7zcMFcVBPwqZ26DjASnYo75aqhGSpfVSHZifw0nAZ8VUYX1a
         ARPUbyiyNotkwoEPIWK0c4zKfnS8u1vAVzI37HBvKdaVd1wUYGB76pHSIuoChQrv2B
         Y+hxK19Hf1MTuLLez2JkmBMjQOAN3N2YSkrWktfudBVQhovXp/rqUhrgSk+oVn+FWx
         29bzH3kOnHV8Q==
From:   Kalle Valo <kvalo@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Luciano Coelho <luca@coelho.fi>
Subject: Re: pull-request: wireless-drivers-next-2021-12-07
References: <20211207144211.A9949C341C1@smtp.kernel.org>
        <20211207211412.13c78ace@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87tufjfrw0.fsf@codeaurora.org>
        <20211208065025.7060225d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87zgpb83uz.fsf@codeaurora.org>
        <CAMZdPi9eeVCakwQPnzvc-3BHo8ABv6=kb3VJj+FAXDZbz4R6bw@mail.gmail.com>
Date:   Thu, 16 Dec 2021 11:18:30 +0200
In-Reply-To: <CAMZdPi9eeVCakwQPnzvc-3BHo8ABv6=kb3VJj+FAXDZbz4R6bw@mail.gmail.com>
        (Loic Poulain's message of "Wed, 8 Dec 2021 17:58:58 +0100")
Message-ID: <87mtl0di1l.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Loic Poulain <loic.poulain@linaro.org> writes:

>> > drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:3911:28:
>> > warning: incorrect type in assignment (different base types)
>> > drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:3911:28:
>> > expected restricted __le32 [assigned] [usertype] period_msec
>> > drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:3911:28:
>> > got restricted __le16 [usertype]
>> > drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:3913:30:
>> > warning: incorrect type in assignment (different base types)
>> > drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:3913:30:
>> > expected unsigned char [assigned] [usertype] keep_alive_id
>> > drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:3913:30:
>> > got restricted __le16 [usertype]
>>
>> Loic, your patch should fix these, right?
>>
>> https://patchwork.kernel.org/project/linux-wireless/patch/1638953708-29192-1-git-send-email-loic.poulain@linaro.org/
>
> Yes.

Thanks, this is now applied and will be part of next pull request,
hopefully sent on Friday. iwlwifi fixes we are planning to submit next
week.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
