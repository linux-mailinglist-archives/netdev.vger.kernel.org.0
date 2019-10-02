Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B29AC8E82
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfJBQhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:37:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34196 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfJBQhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:37:39 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7915C60ADE; Wed,  2 Oct 2019 16:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570034258;
        bh=W2ugWw+g4hwqvYP2PhDRDzBcHTHI03rkdLJkiNE2ZS4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ECEaEuCdVLCu0VGh+t83VcJoK2eLJ7R45a7tTf4HuXJV+PQY9u5ffT9cerhhfsRSH
         xeoUe0uammn+/2fCqp1beres+SokK8vmhOfjh1aKCEhpp5qckbCopF5R2h8VPtmvno
         g5W58616BfgNGGorME3ps27xTJ2VU2zz50q6t6BE=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 02B866013C;
        Wed,  2 Oct 2019 16:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570034257;
        bh=W2ugWw+g4hwqvYP2PhDRDzBcHTHI03rkdLJkiNE2ZS4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LCCnEHegaZm4ZAkRYFxwZTKdrfata2y9wMVg6baYREWLFcYar8o3lPxqA7BfWZ9Xz
         D4K1iPLMihgyTD+hgPrvxz38jSFqv0WKdxvWIaIZ9oCuc/1QwQ/LFVcEq1jav1XlWC
         EgQiFPTXtQZKPfW8W+L1gFLLRM0+bPLVpqwUtnrs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 02B866013C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
Subject: Re: [PATCH v2] rtl8xxxu: add bluetooth co-existence support for single antenna
References: <20190911025045.20918-1-chiu@endlessm.com>
        <20191002042911.2E755611BF@smtp.codeaurora.org>
        <CAB4CAwdvJSjamjUgu2BJxKxEW_drCyRFVTbwN_v-suXc2ZjeAg@mail.gmail.com>
Date:   Wed, 02 Oct 2019 19:37:33 +0300
In-Reply-To: <CAB4CAwdvJSjamjUgu2BJxKxEW_drCyRFVTbwN_v-suXc2ZjeAg@mail.gmail.com>
        (Chris Chiu's message of "Wed, 2 Oct 2019 20:38:07 +0800")
Message-ID: <87pnjf2jea.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chiu@endlessm.com> writes:

> On Wed, Oct 2, 2019 at 12:29 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
>> Failed to apply, please rebase on top of wireless-drivers-next.
>>
>> fatal: sha1 information is lacking or useless
>> (drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h).
>> error: could not build fake ancestor
>> Applying: rtl8xxxu: add bluetooth co-existence support for single antenna
>> Patch failed at 0001 rtl8xxxu: add bluetooth co-existence support for single antenna
>> The copy of the patch that failed is found in: .git/rebase-apply/patch
>>
>> Patch set to Changes Requested.
>>
>> --
>> https://patchwork.kernel.org/patch/11140223/
>>
>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>>
>
> The failure is because this patch needs the 'enum wireless_mode' from another
> patch https://patchwork.kernel.org/patch/11148163/ which I already submit the
> new v8 version. I didn't put them in the same series due to it really
> took me a long
> time to come out after tx performance improvement patch upstream. Please apply
> this one after
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2117331.html.

Ok, but please always clearly document if there are any dependencies. I
don't have time to start testing in which order I'm supposed to apply
them. And the best is if you submit the patches in same patchset, that
way I don't need to do anything extra.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
