Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E08224E46D
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 03:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgHVBTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 21:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgHVBTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 21:19:00 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3453C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 18:18:59 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id a65so3021380otc.8
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 18:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AoLHRFfK3SPqgScnZ1zuEEcyxERALKcEC9S8bV0txpI=;
        b=acSURj7xMMVQcwqR11bfahYQtyKClAohAlH/aNGD22vSufNdOxKkxAgfxEZHmC1y5x
         nIJMCmreRpGWs+HsrF4ahUYymYvoaUnlHLX7lccHskoGdnz4Ca338AXMM/ctePSPwt/R
         sn9EuEPAaMnCqPZyHJb51rNGioGSKzPiuNhsJ9LAs0xdADEVzh1HEL2zdvIYsIIT18jj
         6F0lL8ziQBAGAWZCOrLaEhYESSt4EQiok8Ors1pe0TSEMyL6faM2zbplVlXHUnFtytVv
         jB4nMBoI0E2LwmSm2ozakYtkMENG9q4cRyV9SYFlN/ZCw+NviOqny0m4Zh/Qp6ErxkQU
         fnrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AoLHRFfK3SPqgScnZ1zuEEcyxERALKcEC9S8bV0txpI=;
        b=eJIJxfbUxxdOg1GbfSg4+IDEfIQQ0pxKaAsS1U9AeeDguOi88+ktfdni/YHCiXjrLP
         hdnKyVfSNiGkPS4t0QiGw5x4UIxdt2T/AqYI+uZojRUHaqQehIE3E9IWzt8GS2ZoDcl/
         BK4Rfhl8ibiBneYKv/nFaacv007Hu85rIElVSltRI5sPJyOjs6O8k5s1mdYK4M8Rfn1T
         tToGHSbAWUyxcBpZq9WIO8BzYlLVKwej+ETneGLY+0mFWhBKqccklNPoD5V3wQpqbQUU
         4RNGMxd/cctuPvK6IkeTVBY01Ahxe4rbUPUgfSWk+MBWSAcYuxULXmCSm0uylpoT7npt
         Ukng==
X-Gm-Message-State: AOAM530ZtfT76Q1Uqzrkt5Dkzt5h521X2HtVhCRvOyqVc54OKmFfhKUQ
        OFIhuoHhC8NkZQrTWiZMwk4=
X-Google-Smtp-Source: ABdhPJy2CQkQlIWQFSDc20DHoPiQ0F3mNnP1Qhds5XtkqBPU3KjltZOug0+H/TAUO0V+gNf0skdfrQ==
X-Received: by 2002:a05:6830:1096:: with SMTP id y22mr3976906oto.180.1598059139067;
        Fri, 21 Aug 2020 18:18:59 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:284:8202:10b0:a888:bc35:d7d6:9aca])
        by smtp.googlemail.com with ESMTPSA id v3sm649041oiv.45.2020.08.21.18.18.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 18:18:58 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 0/6] devlink: Add device metric support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        tariqt@nvidia.com, ayal@nvidia.com, mkubecek@suse.cz,
        Ido Schimmel <idosch@nvidia.com>
References: <20200817125059.193242-1-idosch@idosch.org>
 <20200818172419.5b86801b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <58a0356d-3e15-f805-ae52-dc44f265661d@gmail.com>
 <20200818203501.5c51e61a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <55e40430-a52f-f77b-0d1e-ef79386a0a53@gmail.com>
 <20200819091843.33ddd113@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <e4fd9b1c-5f7c-d560-9da0-362ddf93165c@gmail.com>
 <20200819110725.6e8744ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d0c24aad-b7f3-7fd9-0b34-c695686e3a86@gmail.com>
 <20200820090942.55dc3182@kicinski-fedora-PC1C0HJN>
 <20200821103021.GA331448@shredder>
 <20200821095303.75e6327b@kicinski-fedora-PC1C0HJN>
 <6030824c-02f9-8103-dae4-d336624fe425@gmail.com>
 <20200821165052.6790a7ba@kicinski-fedora-PC1C0HJN>
 <1e5cdd45-d66f-e8e0-ceb7-bf0f6f653a1c@gmail.com>
 <20200821173715.2953b164@kicinski-fedora-PC1C0HJN>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <90b68936-88cf-4d87-55b0-acf9955ef758@gmail.com>
Date:   Fri, 21 Aug 2020 19:18:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200821173715.2953b164@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/20 6:37 PM, Jakub Kicinski wrote:
>>> # cat /proc/net/tls_stat   
>>
>> I do not agree with adding files under /proc/net for this.
> 
> Yeah it's not the best, with higher LoC a better solution should be
> within reach.

The duplicity here is mind-boggling. Tls stats from hardware is on par
with Ido's *example* of vxlan stats from an ASIC. You agree that
/proc/net files are wrong, but you did it anyway and now you want the
next person to solve the problem you did not want to tackle but have
strong opinions on.

Ido has a history of thinking through problems and solutions in a proper
Linux Way. netlink is the right API, and devlink was created for
'device' stuff versus 'netdev' stuff. Hence, I agree with this
*framework* for extracting asic stats.
