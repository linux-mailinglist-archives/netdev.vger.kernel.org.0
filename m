Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4B83BEA13
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 16:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbhGGOxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 10:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbhGGOwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 10:52:22 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DAFC06175F;
        Wed,  7 Jul 2021 07:48:56 -0700 (PDT)
Received: from [IPv6:2003:e9:d72a:e927:359b:e3fc:a5d5:7a7a] (p200300e9d72ae927359be3fca5d57a7a.dip0.t-ipconnect.de [IPv6:2003:e9:d72a:e927:359b:e3fc:a5d5:7a7a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 51686C03B9;
        Wed,  7 Jul 2021 16:48:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1625669334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PrWjspjGSf78DOHcyaZo3I5nvBgwDD7uu1bHzO/WReI=;
        b=c17Ms0AfLq3GTWECPGNJJ1C2EZBIwiuHjHO/FNfx8xZ6emMr2JwbzYdd9451DZBsXlN+hI
        BWMTfyilNlsDTkYdmzHif8xc3ExwPNfv7zL472lthci1QIbreJPQpAUX9NGm9id4gA8g6q
        kBZKLJOokUB0u7CMdJ0f1N7mrixl7aVXnoesQ62XUq7kifyzfgX/pccTY7uX8ds5G/dkl2
        0D3d81lCAq+XQ2e8BBAMG9opsSzmgSJBPAaXftXGHn/tCv6RaRYrbyH7rdRfWPwz/oouCc
        1Hb2Hpj1jbZyw4pvL1LHMDVQqspVSsji3jDxDxyWN9MRtSgr4I189OljRlAHyA==
Subject: Re: [PATCH] ieee802154: hwsim: fix GPF in hwsim_set_edge_lqi
To:     Alexander Aring <alex.aring@gmail.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Aring <aring@mojatatu.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
References: <20210705131321.217111-1-mudongliangabcd@gmail.com>
 <CAB_54W5ceXFPaYGs0T4pVq8AzRqUSvaBDWdBjvRurBYyihqfVg@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <68815e29-88f0-b37d-5e71-687d738f0db5@datenfreihafen.org>
Date:   Wed, 7 Jul 2021 16:48:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAB_54W5ceXFPaYGs0T4pVq8AzRqUSvaBDWdBjvRurBYyihqfVg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 07.07.21 15:44, Alexander Aring wrote:
> Hi,
> 
> On Mon, 5 Jul 2021 at 09:13, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>>
>> Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE,
>> MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID and MAC802154_HWSIM_EDGE_ATTR_LQI
>> must be present to fix GPF.
>>
>> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
>> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> 
> Acked-by: Alexander Aring <aahringo@redhat.com>


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
