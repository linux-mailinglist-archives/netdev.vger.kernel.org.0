Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5AB3B212E
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 21:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhFWT0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 15:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhFWTZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 15:25:51 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5BBC0617A6;
        Wed, 23 Jun 2021 12:23:32 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id j1so3845570wrn.9;
        Wed, 23 Jun 2021 12:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dq4bNmoezBnbnji3QvGAbb4dAnBkndoiAymK9jeUq04=;
        b=CXI/3Xn46DPHunYRKMemj/2lg5t37dPGcrxC3jgZ8wJ2Xt4NSh5BnW6ztXNkFQqpFG
         1Cr8LrePNp3O7IgldKcRLxV4LsGPfuX7pYwcwtf/+KuHpXQ4FJuVtPHydSQS/hzdJfqX
         61vbLpJ6/1H43UteLHFlJjVztyn2WSzGo0E8XSU6KS8kgxV6I1KuIvnT/HXYjV6u+W6e
         df77zCiRRWOgmmyOQyFsspvB+WaKv6E+jRUurODdeinnfEYibe5E05eF5Rjo11SK2Jlf
         oyFkzNRkbyou005ife0lSyBZYirff5jVaRB0tFxMQKQ6rLLwt0rRo7F/b9px68EwAo6i
         fHpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dq4bNmoezBnbnji3QvGAbb4dAnBkndoiAymK9jeUq04=;
        b=FjTyhCoNHyUOmnyA2RNPnLfbq3Rf9rmGDJH0xn8GhC8tZ2xEJ9qAP8BjZR4hjySj5A
         tFNOut8cPlXmkdPVkMz3U0lVKXIxs0TCdpEidpNw+OzrPfnTfKe9ZghjEVcA7Nh5t6WR
         PafonbgVixYQyW5xoxY0N8cohMNj5iqmBnYRvrDmU75rmCFRySd4kPoZ2Wjphu+zFIJ0
         XYiLJ9O0vfY9q47OtqsMck6EseOpvVuxgy0c2i0pczqKqfKhXNSW1+8mRgp5226GpNLC
         LPkAh1PmBNQ0mQfJ0ce6kikzSachmXOXZKG4ekyLhg59i0MDLbemVe4DFJKS5O5j7eZu
         XQow==
X-Gm-Message-State: AOAM532o1An3y/cP+HqSgjPwKQdMxS+H5Su46VA89Ll3B64PeIfy53/A
        H2NfbybF2QaC2bA74fRvRFk=
X-Google-Smtp-Source: ABdhPJxVE30MVKLDbgompMmg6DCsBEGcqwOjveqUOXfXf4Yg4EnJ59pE44Lg0c84bsQbJrVeZGVd1Q==
X-Received: by 2002:a5d:5988:: with SMTP id n8mr1906893wri.261.1624476210812;
        Wed, 23 Jun 2021 12:23:30 -0700 (PDT)
Received: from debian64.daheim (pd9e29157.dip0.t-ipconnect.de. [217.226.145.87])
        by smtp.gmail.com with ESMTPSA id x7sm905871wre.8.2021.06.23.12.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 12:23:30 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.94.2)
        (envelope-from <chunkeey@gmail.com>)
        id 1lw6ak-000BL4-DD; Wed, 23 Jun 2021 21:23:27 +0200
Subject: Re: [PATCH] net: ath10: add missing ret initialization
To:     Pavel Skripkin <paskripkin@gmail.com>, kvalo@codeaurora.org,
        davem@davemloft.net, Yang Yingliang <yangyingliang@huawei.com>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
References: <20210623191426.13648-1-paskripkin@gmail.com>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <a0805010-788a-5ff8-2e6e-34e7ded8c34b@gmail.com>
Date:   Wed, 23 Jun 2021 21:23:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210623191426.13648-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/06/2021 21:14, Pavel Skripkin wrote:
> In case of not supported chip the code jump
> to the error handling path, but _ret_ will be set to 0.
> Returning 0 from probe means, that ->probe() succeeded, but
> it's not true when chip is not supported.
> 
> Fixes: f8914a14623a ("ath10k: restore QCA9880-AR1A (v1) detection")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

I think this is already fixed by:

commit e2783e2f39ba99178dedfc1646d5cc0979d1bab3
Author: Yang Yingliang <yangyingliang@huawei.com>
Date:   Mon May 31 17:41:28 2021 +0300

     ath10k: add missing error return code in ath10k_pci_probe()


Cheers
Christian
