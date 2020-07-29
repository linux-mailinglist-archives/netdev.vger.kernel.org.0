Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17489231F8E
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 15:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgG2NsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 09:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgG2NsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 09:48:20 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D14BC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 06:48:20 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id b14so20490147qkn.4
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 06:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tg/Exj8jO7z5z+0AmUdAH027TWx6She5r29BVG8nKUs=;
        b=n1+Q10dDcXtKPd4kBCsKJ54Dicn0as3/Y2UUJYSJJURFF81DTi9iWXy3iV/42G3gli
         HuKuQ0Rn1azIm+dCq03CltYQt0Rh0UbEC9CTOqI0k7N3bPpTOc6d+q9ZI5txSQchqEnA
         zcpL+x5xQSWsCncCZuZDMMlVaZxEzBeM+vSaI6rP+MCJfUpQOoyHIs7CkQzazbKbnwzm
         bwkDEoyZqDi+SdXzIlbtTd4FDE2r8LywsVStdA34suRVEUw/IgQz71OIZQUYUIYgpOjc
         t4mNhUlC+J2bmNF+ZEY7osUaVZl/tQ1aWArnoKU7hnOBBK0bC/zztUC6bukRDWx1V6pz
         uuSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tg/Exj8jO7z5z+0AmUdAH027TWx6She5r29BVG8nKUs=;
        b=NdUwty0fvOqRszsKjGtiVvBWwEFDpjCXVB+UtqrkI3DZ+R3sQ5/kguF5aWgejciguH
         D9Hvxdy2W2Y30OdUhy0IIOdFiGSGHk8g33VrNvMmaKtmorZ8tb821QmUJ6CoSltAwITX
         5N8cWDCK7+dq92lpyCXTVjYYn5xB9P+W/gUFw3dGfgNFE0nDntg/T966ucws+ibOFgEE
         FkvYWQu+CtCz4w2Cf7ajFitcIAnOApEz+UBKXNL0f9+xtbsXpgxUGxsBi0U9ewf/TQbl
         KAt3yJuUj/gwYInCSnFH6Nc7E2cU6fPnt6acK/2wN57NZIXufFbEiY6+OF/sOyAb719e
         r7TQ==
X-Gm-Message-State: AOAM530zfcjFnfxj1wSIazHtPVrcZtlBTWqBoVonCfba98lD4Zou0sDx
        //UBn+MYnMWqIxJn9LKoCuKMAFXu
X-Google-Smtp-Source: ABdhPJxvvJKv05Lj6QKc0zcCULEenN6p7VmbS2Bb/LfoUv3qKIcrcIpiBtYOqb7s/uBQ6IEXZaT8NQ==
X-Received: by 2002:a37:8b07:: with SMTP id n7mr30846934qkd.98.1596030498853;
        Wed, 29 Jul 2020 06:48:18 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id w8sm1612557qka.52.2020.07.29.06.48.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2020 06:48:18 -0700 (PDT)
Subject: Re: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
To:     "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ad09e947263c44c48a1d2c01bcb4d90a@BK99MAIL02.bk.local>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c531bf92-dd7e-0e69-8307-4c4f37cb2d02@gmail.com>
Date:   Wed, 29 Jul 2020 06:48:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ad09e947263c44c48a1d2c01bcb4d90a@BK99MAIL02.bk.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/2020 11:05 PM, Gaube, Marvin (THSE-TL1) wrote:
> Summary: 802.1Q-Header lost on KSZ9477-DSA ingress without bridge
> Keywords: networking, dsa, microchip, 802.1q, vlan
> Full description:
> 
> Hello,
> we're trying to get 802.1Q-Tagged Ethernet Frames through an KSZ9477 DSA-enabled switch without creating a bridge on the kernel side.

Does it work if you have a bridge that is VLAN aware though? If it does,
this would suggest that the default VLAN behavior without a bridge is
too restrictive and needs changing.

> Following setup:
> Switchport 1 <-- KSZ9477 --> eth1 (CPU-Port) <---> lan1

This representation is confusing, is switchport 1 a network device or is
this meant to be physical switch port number of 1 of the KSZ9477?

> 
> No bridge is configured, only the interface directly. Untagged packets are working without problems. The Switch uses the ksz9477-DSA-Driver with Tail-Tagging ("DSA_TAG_PROTO_KSZ9477").
> When sending packets with 802.1Q-Header (tagged VLAN) into the Switchport, I see them including the 802.1Q-Header on eth1.
> They also appear on lan1, but with the 802.1Q-Header missing.
> When I create an VLAN-Interface over lan1 (e.g. lan1.21), nothing arrives there.
> The other way around, everything works fine: Packets transmitted into lan1.21 are appearing in 802.1Q-VLAN 21 on the Switchport 1.
> 
> I assume that is not the intended behavior.
> I haven't found an obvious reason for this behavior yet, but I suspect the VLAN-Header gets stripped of anywhere around "dsa_switch_rcv" in net/dsa/dsa.c or "ksz9477_rcv" in net/dsa/tag_ksz.c.

Not sure how though, ksz9477_rcv() only removes the trail tag, this
should leave any header intact. It seems to me that the switch is
incorrectly configured and is not VLAN aware at all, nor passing VLAN
tagged frames through on ingress to CPU when it should.
-- 
Florian
