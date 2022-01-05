Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063C548566C
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 17:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241823AbiAEQFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 11:05:41 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:48676
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241809AbiAEQFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 11:05:39 -0500
Received: from [192.168.1.13] (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 4250D3F360;
        Wed,  5 Jan 2022 16:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641398737;
        bh=YziyOsgf7ZDsM9VRsrK2Nhw2vPk0wpVYr+7Cq3B2PkY=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=WXUnH4iurx2Xm1g5bfiE/9TyomCoz7j0ee50MXE2bxK1fsH7j8fN+zKHBVlRkrnHa
         cVUVcAPuMuK68D8mVzY5I1wJUEgwr62BF3AbFWggFTjHJLT1Dof8VMAKanYlYgqexm
         HIg6pyJNUfxpz2i3J9+1+MOorHC41ypZZXIHX9rGJZKo0Yn1WEdTblHO8+pRxLI1TN
         3hxik+HRo7Zo1wjd/Z/k6FVTWFy9LF0oyPJOo9hNS8niwsLK9IfrkMQH5mITjUPWmN
         IjngSxZ5f8GKr0/2CNVirv2HDltm2nWZ0BBVt8Ah/jtknBwR6M2oAQPS7zENgLOonZ
         1phtod7sS6W+A==
Message-ID: <fa192218-4fc8-678f-8b40-95b85e36097e@canonical.com>
Date:   Thu, 6 Jan 2022 00:05:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] Revert "net: usb: r8152: Add MAC passthrough support for
 more Lenovo Docks"
Content-Language: en-US
To:     Oliver Neukum <oneukum@suse.com>, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
References: <20220105155102.8557-1-aaron.ma@canonical.com>
 <394d86b6-bb22-9b44-fa1e-8fdc6366d55e@suse.com>
From:   Aaron Ma <aaron.ma@canonical.com>
In-Reply-To: <394d86b6-bb22-9b44-fa1e-8fdc6366d55e@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/6/22 00:01, Oliver Neukum wrote:
> 
> On 05.01.22 16:51, Aaron Ma wrote:
>> This reverts commit f77b83b5bbab53d2be339184838b19ed2c62c0a5.
>>
>> This change breaks multiple usb to ethernet dongles attached on Lenovo
>> USB hub.
> 
> Hi,
> 
> now we should maybe discuss a sensible way to identify device
> that should use passthrough. Are your reasons to not have a list
> of devices maintainability or is it impossible?
> 

The USB to ethernet ID is 0bda:8153. It's is original Realtek 8153 ID.
It's impossible.

And ocp data are 0.
No way to identify it's from dock.

Aaron

>      Regards
>          Oliver
> 
