Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6308825AD65
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 16:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgIBOjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 10:39:01 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45387 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgIBOix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 10:38:53 -0400
Received: by mail-pg1-f195.google.com with SMTP id 67so2626465pgd.12;
        Wed, 02 Sep 2020 07:38:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bs3LF1/Vyf9WI30AtBlfqknkJoCzM8qq7PCIQJ+CgVs=;
        b=cb9Xp08FN6g5tz43i6fibNZOJoVFmRMUZYsq6Bq0G2cB+3LzGg0f0ppiUiWVUZInsf
         jygQddpQK1Ye4sCRfEVDyfGnbIESZ8RAkodfLFgGlB9gTvhZ+lzwa15i2medsgOMWEoZ
         SHVWkivxSdmzYzFrbif+nVN9AuSQ3+qOGrYGu0pSFBzRlSfU6fVNkoLAIojNFbmhTW3w
         O2RqcB1F+NfcXZQ58nismeKQPQb/mNgMTyOh8KsBkATeGVpBWceQGEqs+Edk2eg45RuE
         o852wsCkEwlPA8jkA4sT3TDNs5LlJ550uUcmR0HYDsqHFccTL50KkBdGpoQe4bKmcHyZ
         CtZw==
X-Gm-Message-State: AOAM530yM1Bh7qLy54oVZ8b9jsX47WlnTEHKS2Oj3jobuBAghDVhy6qV
        +kSFFsGW7FNW4/SZUueXVlSf4XoatOIPGgar
X-Google-Smtp-Source: ABdhPJytGBzxAibw0qrw/DNDrQK59bOx4dnLIDE6Mj95XGfqtSKrEqj4yRD1HKZNBGtPC+ARzpZnxQ==
X-Received: by 2002:a63:c551:: with SMTP id g17mr2089799pgd.399.1599057532406;
        Wed, 02 Sep 2020 07:38:52 -0700 (PDT)
Received: from localhost.localdomain ([49.236.93.204])
        by smtp.gmail.com with ESMTPSA id e7sm6091537pfm.43.2020.09.02.07.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 07:38:51 -0700 (PDT)
Subject: Re: [PATCH] rt2x00: Use fallthrough pseudo-keyword macro
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200902130507.227611-1-dev@ooseel.net>
 <88a62415-5859-efb6-f608-db7dcb84ad9b@embeddedor.com>
From:   Leesoo Ahn <dev@ooseel.net>
Message-ID: <9484244a-f5a0-4a34-8d32-4280aebda9a2@ooseel.net>
Date:   Wed, 2 Sep 2020 23:38:47 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <88a62415-5859-efb6-f608-db7dcb84ad9b@embeddedor.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

20. 9. 2. 오후 11:20에 Gustavo A. R. Silva 이(가) 쓴 글:
> 
> 
> On 9/2/20 08:05, Leesoo Ahn wrote:
>> Replace all '/* fall through */' comments with the macro[1].
>>
>> [1]: https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through
>>
> 
> This looks familiar...
> 
> https://lore.kernel.org/lkml/20200821062052.GA8618@embeddedor/
> 
> Thanks
> --
> Gustavo
> 

I didn't notice the patch. Please, ignore this.

Thanks

Leesoo
