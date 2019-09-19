Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFB2B789C
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 13:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388492AbfISLjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 07:39:35 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51318 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388162AbfISLjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 07:39:35 -0400
Received: by mail-wm1-f65.google.com with SMTP id 7so4105704wme.1
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 04:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DKzAQahCYPhZ2ssPBGIJt75n2wk0bxvGCrcodj0E+8o=;
        b=df2ht/hYt42oGahvKnuFkzhFM20BjG6q6b2qOTyHeZ5qndKJKUFk/S8p9AtiHgm21z
         lLbbmV9F/x0vLg/s2ehHstlIlV8sPpwE1vP2BHwIpiPdcgqKajPq3ENzi/oCValibmbG
         Sgz6zWgIP5QJmAUogGBCFWNuYvNKKEp5OhQA4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DKzAQahCYPhZ2ssPBGIJt75n2wk0bxvGCrcodj0E+8o=;
        b=il24MwbqRZ+JS7LD9lZXlqCqVDa7Fs/FjvzVwZZQ48m6jE9sCHtFLdGXkORVjuNYdv
         TqOcNiZWJe7n+bbrzomh8f4qzjA6bG/soTfsJnM5bApLhmoTKH6hrQUn89q7cIwQtJp4
         /6/87aEE09Eb6BM2EKsdaIM2tw49oMYw0FeokcXfMXL/g5s3g/5E0y3gJ8KJffw3KNK6
         hsa9eQzgU7HwiiLAHpoZqGMMVk3D/tr/cWEmNv1YnCiMxXf33ECVkL5CwmONf+fqUa0J
         T51UMDwJQyHItkS747W+w98OlaTW4aIKb1t0KqZDe2YJ4dmTSjzlFc19obvZuk8FGBtY
         EY/Q==
X-Gm-Message-State: APjAAAUp3mZU4r3+AS4UtNCA67I7ns7FiDD0Ccj15yZwxmmA9QTSINWx
        pLFcn2MminI9TNTe/0NS/PVnGg==
X-Google-Smtp-Source: APXvYqynRI01eO1fYwKFW25INxMrTheYRYlf7PGDeX+77jnNAOkkPYIuZOeB0pAEfbh+4FmCSDeScw==
X-Received: by 2002:a05:600c:2208:: with SMTP id z8mr2687432wml.113.1568893173499;
        Thu, 19 Sep 2019 04:39:33 -0700 (PDT)
Received: from [10.230.33.15] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id z142sm11043922wmc.24.2019.09.19.04.39.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 04:39:32 -0700 (PDT)
Subject: Re: [PATCH 00/20] Add support for Silicon Labs WiFi chip WF200 and
 further
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Le Goff <David.Legoff@silabs.com>
References: <20190919105153.15285-1-Jerome.Pouiller@silabs.com>
 <20190919112508.GA3037175@kroah.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <7639195f-59f0-a0dc-02f2-45b3a08e7002@broadcom.com>
Date:   Thu, 19 Sep 2019 13:39:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190919112508.GA3037175@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/2019 1:25 PM, Greg Kroah-Hartman wrote:
>>    - I also kept compatibility code for earlier Linux kernel version. I
>>      may drop it in future. Maybe I will maintain compatibility with
>>      older kernels in a external set of patches.
> That has to be dropped for the in-kernel version.

There is no need to maintain such compatibility. You basically get it 
for free with the linux-backports project [1].

Regards,
Arend

[1] https://backports.wiki.kernel.org/index.php/Main_Page
