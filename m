Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE97145015C
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 10:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237137AbhKOJah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 04:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237676AbhKOJ37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 04:29:59 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831B8C061220;
        Mon, 15 Nov 2021 01:27:00 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id e7so19513703ljq.12;
        Mon, 15 Nov 2021 01:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cHDJGKZoIt3Qvf99KfbasimQ+ZvWTUZpWV/kwcIxxcE=;
        b=IWmt0HHNxT+F5HX7t+OPRF+L3YGJ9ilWgsiQGUpin9c3mIlnxjnL/SLvlvDj4iT7RF
         s5LehX2AY1VZ+oowhzUcOAeICJW6ccmU/Ma+BuEc5159xr+pgd11fLjX4AQwMugCQMSy
         5ZbHrMlnkrb+soOcWOMF06nnMmSWF3EqVecB8ANiiyTSCGqq1CQSgiMCYlY7TCR5Hfa2
         5KnknkyMatKYgL+seUMbq7NknpRTS4IfT52HckTTNXfBUr6kz7R5c2JaUsdbto55EWPC
         yFW4rWRtfeN0CWe/CABR0l76fW7l8hjCCotWcNLYvGOz57kDTqgizPgl3KSAhaogVAL+
         eBdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cHDJGKZoIt3Qvf99KfbasimQ+ZvWTUZpWV/kwcIxxcE=;
        b=Cpy5B6/h3XvOZRkeSlgOr8aTlJMPZsp5YFIrC9ArIQrzshyxug8XXqvWwRYsF8dNxV
         1bzABJDCmKzEz89RZioAdnGIPdmjUBvTtfpM347IK0ZzQqQNUqCazpNFrvL5e0kxG0bN
         3cnGU7mqy8zngDyBcF+QJaomaEbjchzBvKgSFa8C89ustY3xxlrq/7Xw6DGogL4Ub+AE
         6SBY5Ps3Ir1JR0IuNAOqVFJUf1eyyHPfVFEEASICzGKGjJ320nr02D12yx9K++3RpN0o
         9W+xVtLehiU67YFw+wMwtOxBF8ZlKPBLctROekytW8M5t8K8ftGeI+hNDHFO0bvpyzik
         il3A==
X-Gm-Message-State: AOAM533GhNruI978mcdvj+mfoXUUrrN+XmeJW7TVh839hpghKiXa7Rec
        51TzSWohwKTW+N7XoCikLYs=
X-Google-Smtp-Source: ABdhPJxv/LcPZowZ9jkwjHoLct8hWdA+g5iJ23DCn5Pn/SmRFJiOK/9ULfpreoKtUN7cnthEssX1eQ==
X-Received: by 2002:a2e:a54d:: with SMTP id e13mr28507661ljn.319.1636968418855;
        Mon, 15 Nov 2021 01:26:58 -0800 (PST)
Received: from [192.168.1.11] ([94.103.224.112])
        by smtp.gmail.com with ESMTPSA id j21sm1354975lfu.151.2021.11.15.01.26.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 01:26:57 -0800 (PST)
Message-ID: <af7d7175-730e-5a41-4cff-92c2554010d9@gmail.com>
Date:   Mon, 15 Nov 2021 12:26:56 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2] can: etas_es58x: fix error handling
Content-Language: en-US
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Johan Hovold <johan@kernel.org>, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <CAMZ6Rq+orfUuUCCgeWyGc7P0vp3t-yjf_g9H=Jhk43f1zXGfDQ@mail.gmail.com>
 <20211115075124.17713-1-paskripkin@gmail.com>
 <YZIWT9ATzN611n43@hovoldconsulting.com>
 <7a98b159-f9bf-c0dd-f244-aec6c9a7dcaa@gmail.com>
 <YZIXdnFQcDcC2QvE@hovoldconsulting.com>
 <e91eb5b1-295e-1a21-d153-5e0fa52b2ffe@gmail.com>
 <CAMZ6Rq+3uPE31q=HN-BdkXsMYZf53=VfNSn0OD6HcweLO0u-_Q@mail.gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <CAMZ6Rq+3uPE31q=HN-BdkXsMYZf53=VfNSn0OD6HcweLO0u-_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/21 12:24, Vincent MAILHOL wrote:
>> Sure! I should have check it before sending v2 :( My bad, sorry. I see
>> now, that there is possible calltrace which can hit NULL defer.
> 
> I should be the one apologizing here. Sorry for the confusion.
> 
>> One thing I am wondering about is why in some code parts there are
>> validation checks for es58x_dev->netdev[i] and in others they are missing.
> 
> There is a validation when it is accessed in a for loop.
> It is not guarded in es58x_send_msg() because this function
> expects the channel_idx to be a valid index.
> 
> Does this answer your wonders?
> 

Yeah! I have just looked at the code one more time and came up with the 
same idea.

Thank you for confirming and acking my patch :)



With regards,
Pavel Skripkin
