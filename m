Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9443D10E786
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 10:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfLBJSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 04:18:37 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42741 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfLBJSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 04:18:37 -0500
Received: by mail-lj1-f196.google.com with SMTP id e28so14984618ljo.9
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 01:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6ja9ch4L0w7bAa4bcbmZySUMxjC9CzLUpvj1cQSMwa8=;
        b=uTPBkofEFIQC1nYNeb3vu7LG+NQ2nRnifiuCq4czf9Xq9Sw6sSQloZymgl2qZ1CDFs
         RPDy6rBjA9PIdmwDXFJtzsW4jQKHkCQCw8J8uQP3w3y54R7jgHpgAwV9hviCtrCphXxn
         40MeEzGl4xX05vlCMNrLZ/Jzt6j6ZsX1PSPi2EOppkBQaGROJ8VzTtlWoikjZt8O1mms
         UJ4BilLQ2Q01XGvwaRCLI3qZoEbSuUKzxZQPz/+7rggWsCiOJ+d8c4q2z7TY4GdL3iF1
         pPagjRHFNmYnFeot7JpNyLGTEo280oearTe34ZzyVXuKchY2o7cICtf51vtpzqPqa2rA
         M6cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6ja9ch4L0w7bAa4bcbmZySUMxjC9CzLUpvj1cQSMwa8=;
        b=e3GGV+FjP4VvaODe23/jbuMSexqZfAjRf+LA/c0U4pixK95eONNqRaohztyW1qBNeZ
         8izMu0Xmi1HeTAtjA9nEeIB6jdQp/6iJ+0Z9OOyIVlXsjuDNRRPozidS/pX9tl79KrW/
         uAjrNAdrwmULg6KBwkUPWh6PEgnAOwT6ZpUznFGIeewAtgpXEBbja+X0w2IRv2hzIhui
         EP2V12Ywzj2DvTuFRsk44YFtJAujvnYpwgIv78iLZHYUWMX7EG3HdIO6izFaSr1Z/3KJ
         78RIHS7P0JUQFBH+UMRADriROJ477tzi4BZqgd6cSEnVjYPTNzoIDOtBQ6005ccwGJIn
         cmgw==
X-Gm-Message-State: APjAAAUhWAX3kOx0sl3aCqKtrjuucMboXVe60FLyr5i4nvIe15A5Z2vk
        5LpsORyRTKtfeKi9i1IZ8qrSpQ==
X-Google-Smtp-Source: APXvYqxwpAVRrTt+ohqj3sU9ZfRrVqX02o1vwts4WBMtf4EDXl5MbSuF6EQGuhRhWwZFug6WCJYv4Q==
X-Received: by 2002:a2e:b5ae:: with SMTP id f14mr13855009ljn.31.1575278314710;
        Mon, 02 Dec 2019 01:18:34 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:61d:753e:cc38:6b74:7e0d:a1da? ([2a00:1fa0:61d:753e:cc38:6b74:7e0d:a1da])
        by smtp.gmail.com with ESMTPSA id l8sm14769303ljj.96.2019.12.02.01.18.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Dec 2019 01:18:34 -0800 (PST)
Subject: Re: [PATCH v1] mt76: mt7615: Fix build with older compilers
To:     Pablo Greco <pgreco@centosproject.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Roy Luo <royluo@google.com>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20191201181716.61892-1-pgreco@centosproject.org>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <e18d798d-cdf3-da05-c139-403dfc80e8a3@cogentembedded.com>
Date:   Mon, 2 Dec 2019 12:18:28 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191201181716.61892-1-pgreco@centosproject.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 01.12.2019 21:17, Pablo Greco wrote:

> Some compilers (tested with 4.8.5 from CentOS 7) fail properly process

    Fail to?

> FIELD_GET inside an inline function, which ends up in a BUILD_BUG_ON.
> Convert inline function to a macro.
> 
> Fixes commit bf92e7685100 ("mt76: mt7615: add support for per-chain
> signal strength reporting")

    Should be:

Fixes: bf92e7685100 ("mt76: mt7615: add support for per-chain signal strength 
reporting")

    Do not ever break up the Fixes: line and don't insert empty lines between 
it and other tags.

> Reported in https://lkml.org/lkml/2019/9/21/146
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Pablo Greco <pgreco@centosproject.org>
[...]

MBR, Sergei
