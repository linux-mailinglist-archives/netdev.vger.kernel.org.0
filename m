Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C713100847
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 16:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfKRPbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 10:31:18 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:37924 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfKRPbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 10:31:18 -0500
Received: by mail-wm1-f43.google.com with SMTP id z19so19419752wmk.3
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 07:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:from:to:cc:references:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fToX0/ljJ1AoUaltvMxgDNP7VOkLoazOx0gKWZr6pnw=;
        b=MhcX5aelli0cVlyI5vIUHzytqynqCfGwf3Ds/HwF+dEAcwqCcFNjAZ56JLhFDfHOVJ
         xF89VOghLubjfT8KC/0GSzayicdyXHaL8TB4KxPIGy5IRGrnx5j0wS0BLapoIRbQAUAh
         iXU4x/AFwUVnjamNgVQ5h5wm5HeqLAm9KCEntM4SCKXykR3rOv0rxn4s7OYXj7TkbqJg
         ywGIjDQmih8zhUcWBTjB9Vv52NE++m8ESx4vLuqZGqyclVVWKSRtFlrRUpzgytRoLEXQ
         EmWrgemVZVQC4TK6IUiGT66IBXfhn4xUvzUvIgGNv0+px1GDVfFyekfD8I3eYrw/ZAqN
         GADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:from:to:cc:references
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=fToX0/ljJ1AoUaltvMxgDNP7VOkLoazOx0gKWZr6pnw=;
        b=WSGsDYRT+CHMjyoi+lsTVmMxOp+qkOAgzNHnO2s9N0dadptmEKTgtvwVyq5Mp6xO6K
         Iv0SUVBoEDKYZEyKaxBeLyIlK8DZk8vIH9C3I14/hs8nZMqEx16WpHnnxKC25MkC450F
         7TEYxhIg/fq+1NBxWBRIIJ88Yt24giT5Wf42rEWpKopkKVssE1ilCbJQcxqXzuZV+I+b
         0ZgC4aqIRTLFDwbNkInAJTY7UDrUy4c2ccH8Cxs9oa7u0VNAcX/RYjDZwkHdBZ/iMo4+
         K4x64YvYA5/hlXVHeh8GK1Dk7cVvLPBEFrLJdODEBtzJanFWi0I3Neje7bNrmcPcxBbZ
         EdYw==
X-Gm-Message-State: APjAAAUZSNNfuJOEZ4Gqws6Lm+03G+pi3jnDcxrC/s/QE89JOn3kY44V
        2rRgPbXx27yAqgkgE4GqT9Tn6IpvVWo=
X-Google-Smtp-Source: APXvYqwRkeU6D9nl05WqtULunELF0FiqcpaQQX3pCdyKQ//AB6S4zR2lYvytEz9co25iDvlSKRaYYw==
X-Received: by 2002:a1c:7214:: with SMTP id n20mr29303602wmc.126.1574091075731;
        Mon, 18 Nov 2019 07:31:15 -0800 (PST)
Received: from ?IPv6:2a01:e35:8b63:dc30:74ae:d8ad:6e3b:4b0? ([2a01:e35:8b63:dc30:74ae:d8ad:6e3b:4b0])
        by smtp.gmail.com with ESMTPSA id a8sm20638679wme.11.2019.11.18.07.31.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 07:31:15 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: xfrmi: request for stable trees (was: Re: pull request (net): ipsec
 2019-09-05)
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org
References: <20190905102201.1636-1-steffen.klassert@secunet.com>
 <3a94c153-c8f1-45d1-9f0d-68ca5b83b44c@6wind.com>
Organization: 6WIND
Message-ID: <65447cc6-0dd4-1dbd-3616-ca6e88ca5fc0@6wind.com>
Date:   Mon, 18 Nov 2019 16:31:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <3a94c153-c8f1-45d1-9f0d-68ca5b83b44c@6wind.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 14/10/2019 à 11:31, Nicolas Dichtel a écrit :
> Le 05/09/2019 à 12:21, Steffen Klassert a écrit :
>> 1) Several xfrm interface fixes from Nicolas Dichtel:
>>    - Avoid an interface ID corruption on changelink.
>>    - Fix wrong intterface names in the logs.
>>    - Fix a list corruption when changing network namespaces.
>>    - Fix unregistation of the underying phydev.
> Is it possible to queue those patches for the stable trees?

Is there a chance to get them in the 4.19 stable tree?

Here are the sha1:
e9e7e85d75f3 ("xfrm interface: avoid corruption on changelink")
e0aaa332e6a9 ("xfrm interface: ifname may be wrong in logs")
c5d1030f2300 ("xfrm interface: fix list corruption for x-netns")
22d6552f827e ("xfrm interface: fix management of phydev")


Regards,
Nicolas
