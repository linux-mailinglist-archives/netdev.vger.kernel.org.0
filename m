Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842C127625E
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 22:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgIWUon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 16:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgIWUok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 16:44:40 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917BFC0613CE;
        Wed, 23 Sep 2020 13:44:40 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id q13so1433020ejo.9;
        Wed, 23 Sep 2020 13:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qpn8hjDvutcn1e+jBw6zUBymSgTIjijJ+0ANxSPq2AE=;
        b=rOWaJv7B0Ln3TAEdcdZIZ1pZdSImREhUSCwQflW+ixAsTMSp2sNK/JslQx/MxbTCTy
         OJoQkjGeoXX5809rJ7K8z1RGCei/fimQYg72M8KX9Qc/+xMhZcG10zhHSezxTB1mSV/z
         g95arGTyMAH9oBIZtzanrB1xNpt0W20yvz8k4q14Pixwpd44jUD4iRu7m5LLTfYtwuZ1
         hwnyjw+ulikLqVtJYEWmQkaw29XDpl844B1q8x214h1VKlJ4TABiaNnVdxaOMs+GF0UO
         ZmQbJ5KgG3QnAWARjEekopYMCefXLoo3DmZ6aDmaJP4ijzE6GMRx7Vm0jMgTc+bYO/1t
         Q4oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qpn8hjDvutcn1e+jBw6zUBymSgTIjijJ+0ANxSPq2AE=;
        b=MDv1Crexdx9U5ZTukN1+W1VUgStgjXjpsZwhqN4OMyfes4iSh3+n7NEhG8mOStKsJC
         1FBkN2dCaOBl5P7rqFqA/z8XwLo0Dc7onNC12/u0oupGaFzXPocEf/a0KDxnBJsrWiP1
         T8Bvhxac2fJMFVX514j+S1tdNlEDOZA1kc2EsY+7b6thd8VYJC6N1Api8aqDOdnpB8t/
         ZApFAwSVkWBsnydLUKt/wdWrii5bhXnPJdC/cmTK7sJV9EhKtX2ITUv3fO7x6gRvW6S9
         jMkfrxe5Om/PmwhzbPBSmyytuigNTbYTx56kGydyOTcKehkWL79K5OspJ463nxR4dw6g
         JYSQ==
X-Gm-Message-State: AOAM532mTNmrARQVzDeSKXZOPVZ9Z++y6CeRYxs2sGJwAzcPXW1WvDMN
        zEN5xhat0vxCQdxOv0Nzi9KWmAvOQ34=
X-Google-Smtp-Source: ABdhPJzOeV+5YIBD2oIqxQPECrAqPdT8HrHYmUmBrM51MbNKwQJeXLgTedTfnnxaxI4HY6Mp3KwtTw==
X-Received: by 2002:a17:906:6a54:: with SMTP id n20mr1433973ejs.401.1600893878898;
        Wed, 23 Sep 2020 13:44:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:9dd1:2d79:8cda:7fd2? (p200300ea8f2357009dd12d798cda7fd2.dip0.t-ipconnect.de. [2003:ea:8f23:5700:9dd1:2d79:8cda:7fd2])
        by smtp.googlemail.com with ESMTPSA id z16sm730519edr.56.2020.09.23.13.44.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 13:44:38 -0700 (PDT)
Subject: Re: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
To:     David Miller <davem@davemloft.net>
Cc:     saeed@kernel.org, geert+renesas@glider.be, f.fainelli@gmail.com,
        andrew@lunn.ch, kuba@kernel.org, gaku.inami.xh@renesas.com,
        yoshihiro.shimoda.uh@renesas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <3d9176a6-c93e-481c-5877-786f5e6aaef8@gmail.com>
 <28da797abe486e783547c60a25db44be0c030d86.camel@kernel.org>
 <14f41724-ce45-c2c0-a49c-1e379dba0cb5@gmail.com>
 <20200923.131529.637266321442993059.davem@davemloft.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e6f50a85-aa25-5fb7-7fd2-158668d55378@gmail.com>
Date:   Wed, 23 Sep 2020 22:44:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200923.131529.637266321442993059.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.09.2020 22:15, David Miller wrote:
> From: Heiner Kallweit <hkallweit1@gmail.com>
> Date: Wed, 23 Sep 2020 21:58:59 +0200
> 
>> On 23.09.2020 20:35, Saeed Mahameed wrote:
>>> Why would a driver detach the device on ndo_stop() ?
>>> seems like this is the bug you need to be chasing ..
>>> which driver is doing this ? 
>>>
>> Some drivers set the device to PCI D3hot at the end of ndo_stop()
>> to save power (using e.g. Runtime PM). Marking the device as detached
>> makes clear to to the net core that the device isn't accessible any
>> longer.
> 
> That being the case, the problem is that IFF_UP+!present is not a
> valid netdev state.
> 
If this combination is invalid, then netif_device_detach() should
clear IFF_UP? At a first glance this should be sufficient to avoid
the issue I was dealing with.

> Is it simply the issue that, upon resume, IFF_UP is marked true before
> the device is brought out from D3hot state and thus marked as present
> again?
> 
I can't really comment on that. The issue I was dealing with at the
time I submitted this change was about an async linkwatch event
(caused by powering down the PHY in ndo_stop) trying to access the
device when it was powered down already.
