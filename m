Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8F747B88
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 09:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfFQHoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 03:44:24 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34880 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfFQHoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 03:44:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E3E6460A44; Mon, 17 Jun 2019 07:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1560757462;
        bh=Aenf+RXfbj5RyVkcFJ9IyGNg4Qewwd+uSbm54mHar40=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=aPPH25yIRrzE1LFahKN8Lh5dxfRHYl+Y7UyF9Qm6o92zBPiSrNw6zj1DBg32PDrfa
         +bpio/2cwWakTG2A/aQpsZwRGKI8ZTVJb5lH7KUJvtNiskh4UTpOxNdJlP/g1KbtSB
         BToLNB+1clr0ByeaN2sdcGys3VY92ZSpMA0QkU+4=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2A50A602DD;
        Mon, 17 Jun 2019 07:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1560757462;
        bh=Aenf+RXfbj5RyVkcFJ9IyGNg4Qewwd+uSbm54mHar40=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=aPPH25yIRrzE1LFahKN8Lh5dxfRHYl+Y7UyF9Qm6o92zBPiSrNw6zj1DBg32PDrfa
         +bpio/2cwWakTG2A/aQpsZwRGKI8ZTVJb5lH7KUJvtNiskh4UTpOxNdJlP/g1KbtSB
         BToLNB+1clr0ByeaN2sdcGys3VY92ZSpMA0QkU+4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2A50A602DD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Nathan Huckleberry <nhuck@google.com>, eliad@wizery.com,
        arik@wizery.com, "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] wl18xx: Fix Wunused-const-variable
References: <20190614171713.89262-1-nhuck@google.com>
        <CAKwvOd=jFYn=7NGPD8UDx3_g30qD+40bCjzmWJJSzmb6pNUusQ@mail.gmail.com>
Date:   Mon, 17 Jun 2019 10:44:18 +0300
In-Reply-To: <CAKwvOd=jFYn=7NGPD8UDx3_g30qD+40bCjzmWJJSzmb6pNUusQ@mail.gmail.com>
        (Nick Desaulniers's message of "Fri, 14 Jun 2019 13:54:16 -0700")
Message-ID: <87h88ofygd.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nick Desaulniers <ndesaulniers@google.com> writes:

> On Fri, Jun 14, 2019 at 10:17 AM 'Nathan Huckleberry' via Clang Built
> Linux <clang-built-linux@googlegroups.com> wrote:
>>
>> Clang produces the following warning
>>
>> drivers/net/wireless/ti/wl18xx/main.c:1850:43: warning: unused variable
>> 'wl18xx_iface_ap_cl_limits' [-Wunused-const-variable] static const struct
>> ieee80211_iface_limit wl18xx_iface_ap_cl_limits[] = { ^
>> drivers/net/wireless/ti/wl18xx/main.c:1869:43: warning: unused variable
>> 'wl18xx_iface_ap_go_limits' [-Wunused-const-variable] static const struct
>> ieee80211_iface_limit wl18xx_iface_ap_go_limits[] = { ^
>>
>> The commit that added these variables never used them. Removing them.
>
> Previous thread, for context:
> https://groups.google.com/forum/#!topic/clang-built-linux/1Lu1GT9ic94
>
> Looking at drivers/net/wireless/ti/wl18xx/main.c, there 4 globally
> declared `struct ieee80211_iface_limit` but as your patch notes, only
> 2 are used.  The thing is, their uses are in a `struct
> ieee80211_iface_limit []`.
>
> Looking at
> $ git blame drivers/net/wireless/ti/wl18xx/main.c -L 1850
> points to
> commit 7845af35e0de ("wlcore: add p2p device support")
> Adding Eliad and Arik to the thread; it's not clear to me what the
> these variables were supposed to do, but seeing as the code in
> question was already dead, this is no functional change from a user's
> perspective.  With that in mind:
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
>
> So I'd at least add the tag.
> Fixes: 7845af35e0de ("wlcore: add p2p device support")

I can't see any functional changes when applying this patch so I don't
think a fixes line is needed, it's just cleanup.

-- 
Kalle Valo
