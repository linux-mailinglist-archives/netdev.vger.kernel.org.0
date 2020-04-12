Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E781A6119
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 01:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgDLXST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 19:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgDLXST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 19:18:19 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46E8C0A88B5
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 16:18:17 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id v5so8565357wrp.12
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 16:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UMdNc9FyutMf0qaN1hVhzlO0XfQb+nixgVop7sWLPgw=;
        b=mLHWpuoMIAnKsT6BYxIX/EhafSeo+SsjoKLbHW60yeUXwkKMcS6ErGOCfOasnIhV3f
         Wbd2t3RJ4nlaZ3dzfaUJ+qh8Yo+aHya7/Qod7seV8OTWomHR6H/ogGQIF/cYKBQALyfP
         BPJt113ZV2kFj2ffl+qhR81U9cyK1mBrbHgU8qR95MeAqr8UQn3n0CaSFL/QjSYfrC7x
         gNymsbpkw87TcwwQC3HEQHuPEmG2k+oR/jpUBY5o/yfKx9rNzn4mF1J3Wz0EXjINRW9f
         i4SwzN+oBFimjnnTLNv8a04j5Hx20EwJtd+RhW82QTwQ35CMjd/8EFfblsvOw/16/cZr
         uhvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UMdNc9FyutMf0qaN1hVhzlO0XfQb+nixgVop7sWLPgw=;
        b=Oqj6vRmNWBTZky1mKNhzpDRMe8xxEA6cTvlwAsrDtTRwqDSA6dEMJORroXGf2k+RSP
         gEaYaRKNwUgzOGzVHBoW8NdmICLgSclekV4Tgf2JsBlOsGauZdtfe01nuIMsKq0MZ3gy
         LbLORBlOn4hnVFm9w+DU8TZtH162rNSIWlC6JXSsztLQQKG6zYqTuAVVY9e0j949mUIi
         27YT3fIZyvNCL/1fL1acf+c1q67s44I3PUcMKAIlzb9Uc0EUA8PG430cvhltHFkj8xdd
         pbNKMHzdTWlrDicVLU7ECNMHXEUO1KooMkwaneV6y1dFomE+9AISkN9fJRVtAgTL/6r0
         5pfQ==
X-Gm-Message-State: AGi0PubKLcmRKumSQxUlRwjxT3SddvtKoLysFQVcT87/YZZMPCx1JbVd
        tmCXC/tcEcqx9R/q+gt5Gb2+Ebvq
X-Google-Smtp-Source: APiQypJ3pb+zarrAyMeZqOlF6H8ePkcsD0yiTeIarNJf+ppwM9iGI6OzNo4ExiSI/zh0hQ7aBrcduQ==
X-Received: by 2002:a5d:6504:: with SMTP id x4mr10018060wru.164.1586733495723;
        Sun, 12 Apr 2020 16:18:15 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:15c2:71ee:1b35:8df1? (p200300EA8F29600015C271EE1B358DF1.dip0.t-ipconnect.de. [2003:ea:8f29:6000:15c2:71ee:1b35:8df1])
        by smtp.googlemail.com with ESMTPSA id a9sm7421809wmm.38.2020.04.12.16.18.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Apr 2020 16:18:15 -0700 (PDT)
Subject: Re: NET: r8169 driver fix/enchansments
To:     Lauri Jakku <lauri.jakku@pp.inet.fi>
References: <43733c62-7d0b-258a-93c0-93788c05e475@pp.inet.fi>
Cc:     netdev@vger.kernel.org
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7e637dd4-73af-5106-90f7-1d261df06fd2@gmail.com>
Date:   Mon, 13 Apr 2020 01:18:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <43733c62-7d0b-258a-93c0-93788c05e475@pp.inet.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.04.2020 14:55, Lauri Jakku wrote:
> Hi,
> 
> 
> I've made r8169 driver improvements & fixes, please see attachments.
> 
> 
> --Lauri J.
> 
> 
This mail doesn't meet a single formal criteria for a patch. I suggest
you start here:
https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt

At first it would be helpful to know what you're trying to fix:
Which issue on which kernel version?

"Added soft depency from realtec phy to libphy"
That's completely redundant as the Realtek PHY driver has a hard
dependency on phylib.

"u32 phydev_match = !0;"
That's weird. Do you mean ~0 here?

Then you mix completely different things in one patch.

Best first learn about how to submit a formally correct patch series,
and to whom it should be submitted. Once you submit such a RFC series,
we have a basis for a discussion.
