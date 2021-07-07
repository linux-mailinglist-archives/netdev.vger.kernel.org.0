Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E9C3BE701
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 13:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhGGLZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 07:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbhGGLZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 07:25:51 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE88C061574;
        Wed,  7 Jul 2021 04:23:11 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id d12so2018482wre.13;
        Wed, 07 Jul 2021 04:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gL5cUtdK5EGXi3fNGr0vY1hkj2DgJe4bNJxdsRkWjQI=;
        b=pu005n7D9Hzp0ESMBU4UbTTUrbwJdrFNObu8W61tGdzJ8i+mhD9n9yhtQ8v6Zy2jce
         AtFLI7Q0FGIB7auttSYxyvyYxwhK3nMBRiLXJ9CGdL4LKiPhJgdhqiIwf/nsC82Uz4Om
         T81QcOgWUG7aVGq9nH+Nth1sXqtpYRlApanG2XsrxGrikO31V6SQsjMmoPT4SK7rUfCX
         NhfzVX2GryNT8+LdqB3cc5PNjbBvz3QRYvCFF89LDEzA+WEau7MK1pVenLI03j/VY79g
         jaqzmHJveX7tFsL2pnP0/fNecw+x6+lBtY9xsCxkgsCSuPdu4FflL3cyX7QrcmhmPXe/
         UmNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gL5cUtdK5EGXi3fNGr0vY1hkj2DgJe4bNJxdsRkWjQI=;
        b=kdRbRTVWcqVSGuqp+IcYN4ckuCuHuJuO+UqauUhbrZK9Z+Mm9smFWTvqR8YZ9CQSKM
         PAKoYbL249ho+Z60c4VDcF8qKLRpyKudjIx1I6/yG5DvkTCKYB4aGPliarNg8BxCpttY
         /gG+uuVwlkxBgl/ZZMGxjv0E5HsPqez/zlMtSFgkfrMHqXLWyIRu60GkpbYzIShJ2bUI
         vPnYKteTuGfbzs80m4+fEN79o8ZZUlyanyny0o74tuzAjlFb3QhMmhcFNMY7WIgU0upT
         4c8QZTee+OdJbHFNhrCVayyAVfqecaYAtaUWceIgaeIqUXXSoeF7LOmbtpWTsRdsR7Sl
         Fexg==
X-Gm-Message-State: AOAM530R4irClYqJOBuQsb43fPADxbxG295r03tMWjjyCT4TSeHeVNaM
        VCv+QxbXyD+Nz60gFA5o6j1uFCOaWHsTbQ==
X-Google-Smtp-Source: ABdhPJyI5fd9lLZ2Wv5DFMZCxe3Cw4BYc40SBq+RDenkiFtVt/eZPSf+7VxhuoNqOk39HOKV9BzYQg==
X-Received: by 2002:a5d:6a0b:: with SMTP id m11mr27381626wru.240.1625656989856;
        Wed, 07 Jul 2021 04:23:09 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id z7sm5947120wmi.1.2021.07.07.04.23.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 04:23:09 -0700 (PDT)
Subject: Re: [PATCH 1/3] sfc: revert "reduce the number of requested xdp ev
 queues"
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        ivan@cloudflare.com
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210707081642.95365-1-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <0e6a7c74-96f6-686f-5cf5-cd30e6ca25f8@gmail.com>
Date:   Wed, 7 Jul 2021 12:23:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210707081642.95365-1-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/07/2021 09:16, Íñigo Huguet wrote:
> The problem is that the TX queues are also contained inside the channel
> structs, and there are only 4 queues per channel. Reducing the number of
> channels means also reducing the number of queues, resulting in not
> having the desired number of 1 queue per CPU.
> 
> This leads to getting errors on XDP_TX and XDP_REDIRECT if they're
> executed from a high numbered CPU, because there only exist queues for
> the low half of CPUs, actually.

Should we then be using min(tx_per_ev, EFX_MAX_TXQ_PER_CHANNEL) in the
 DIV_ROUND_UP?
And on line 184 probably we need to set efx->xdp_tx_per_channel to the
 same thing, rather than blindly to EFX_MAX_TXQ_PER_CHANNEL as at
 present — I suspect the issue you mention in patch #2 stemmed from
 that.
Note that if we are in fact hitting this limitation (i.e. if
 tx_per_ev > EFX_MAX_TXQ_PER_CHANNEL), we could readily increase
 EFX_MAX_TXQ_PER_CHANNEL at the cost of a little host memory, enabling
 us to make more efficient use of our EVQs and thus retain XDP TX
 support up to a higher number of CPUs.

-ed
