Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A787A2B9D71
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgKSWJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgKSWJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:09:58 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA4DC0613CF;
        Thu, 19 Nov 2020 14:09:57 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id h21so8097961wmb.2;
        Thu, 19 Nov 2020 14:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=ZLPw5t8Q3S6R5Cu4mnS0Y3M36trsW+AyO0nPcsojeRo=;
        b=jzCDkQhoboxo7W2c72VfZsx+046aVHpoxzkfJ9UK8YCsTMmOxe581haJ2Yt3hced06
         O3MFwdgvVB5/YtcBoSx3PaydkDnc5UU8RS51o1GDvTpX/HJy9x/fVyKyNexq5/IENXN0
         cCz3nh4LDoddO6lEW5RfiG+WpgvxRm+Hq3eRIDBQf1HrHCmuV+LXvKE+i9dar+dVKfwx
         ZcQ5ISszqo/x3Q+HeyCyZc+GwKD+qo+b5SVI+Ju0o/IefSkgUTOXXkkeSkauxcjQjfbc
         9xM3MxL/+OK93AcWmeTp6BYdv50heIIa9Y/Yex7DgybRkYKBHB7eq8rHj1IPtN/Q+51c
         Nfgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=ZLPw5t8Q3S6R5Cu4mnS0Y3M36trsW+AyO0nPcsojeRo=;
        b=J2UfhQd5HimxnGeY7X6hbNG/rvLfqjHVMlUkae8KTjrVEjtx1nffe/qOzubdq0vP9o
         j3FwgesfrxoNZU6JtpwjhhzyIQR6EOuXCBEifnkegkTQ7iyJa6PuPqRb1zFarXCmv3gP
         3z12y/33NM6EpUY18/wLINQO5MU1hSP98uXmYvhxeC08RopSjG+IfkBGf63CQQAn7Bbt
         KJ37/z1QtJA4k+hUU6aoxwtPcD5RFBsnmfy57ZNGo1wvGjbIxSJv8IG8w1Hm2ATFkJ3S
         mfrK1xTi15jwnSJDq/V0qpEC0yTOSjHtyoKoO4fN5fcVbWYQjk0io3Bdq97pbKobUObR
         lASQ==
X-Gm-Message-State: AOAM530vAvZFUi46/F85KG//fh8bImtTftp0VmOJFRESS6+lRTMnXcmy
        4DEl4ZzSsM0c30t2Xx+c4S177nyz+ic7bg==
X-Google-Smtp-Source: ABdhPJy/g3bybC2vz16iAR02W/13ZlP5Xo5zGAZKmYwrReaKPoOIMqxD+EjNq4wv4cUr+hRFtZY1fQ==
X-Received: by 2002:a1c:c205:: with SMTP id s5mr3333169wmf.122.1605823795749;
        Thu, 19 Nov 2020 14:09:55 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:6d7c:9ea3:dfaa:d617? (p200300ea8f2328006d7c9ea3dfaad617.dip0.t-ipconnect.de. [2003:ea:8f23:2800:6d7c:9ea3:dfaa:d617])
        by smtp.googlemail.com with ESMTPSA id 89sm2090567wrp.58.2020.11.19.14.09.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 14:09:55 -0800 (PST)
Subject: Re: [PATCH v2] mdio_bus: suppress err message for reset gpio
 EPROBE_DEFER
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20201119203446.20857-1-grygorii.strashko@ti.com>
 <1a59fbe1-6a5d-81a3-4a86-fa3b5dbfdf8e@gmail.com>
 <cabad89e-23cc-18b3-8306-e5ef1ee4bfa6@ti.com>
 <44a3c8c0-9dbd-4059-bde8-98486dde269f@gmail.com>
 <20201119214139.GL1853236@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <221941d6-2bb1-9be8-7031-08071a509542@gmail.com>
Date:   Thu, 19 Nov 2020 23:09:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201119214139.GL1853236@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 19.11.2020 um 22:41 schrieb Andrew Lunn:
>>>> Doesn't checkpatch complain about line length > 80 here?
>>>
>>> :)
>>>
>>> commit bdc48fa11e46f867ea4d75fa59ee87a7f48be144
>>> Author: Joe Perches <joe@perches.com>
>>> Date:   Fri May 29 16:12:21 2020 -0700
>>>
>>>     checkpatch/coding-style: deprecate 80-column warning
>>>
>>
>> Ah, again something learnt. Thanks for the reference.
> 
> But it then got revoked for netdev. Or at least it was planned to
> re-impose 80 for netdev. I don't know if checkpatch got patched yet.
> 
> 	  Andrew
> 
At a first glance it sounds strange that subsystems may define own
rules for such basic things. But supposedly there has been a longer
emotional disucssion about this already ..
