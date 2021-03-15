Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0CD33C426
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236093AbhCOR3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbhCOR2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 13:28:40 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9E4C06174A;
        Mon, 15 Mar 2021 10:28:40 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id o3so2361737pfh.11;
        Mon, 15 Mar 2021 10:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5gnEZY9mFGBFMfKq49DrvBCMPyNX5q5pukAl05EuTws=;
        b=O7d04w+g65wkjQSjN9kSHAW+hdiPAjBi25iwq/uLbh6IS3zxrFqvpnAi/VTkz+CizL
         rfXV7/1plKzg4JvtsRMv8DGn32fjDN1MFrf/pgOFWvht0nh2KxM0BnxS7ZecU87zvVsK
         5/Gl67eKcYe4Eo9s6/AgYVkrP1SHoBJHETrmAW92wsWf8eX+eH6W3rcSN3wMJAGInsFW
         EQlK0GwegHsZvWA8rzmwsEwYo8N6NIC162Ecdby0XzavyBh0gGSB7KX2I34F23qYDcVY
         wrwhZjNYxnWdsFznV5bZTGO3H5853/Z9czTvnQm3CDnlWgreKBHFMFr6325do7ABhNG3
         dhnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5gnEZY9mFGBFMfKq49DrvBCMPyNX5q5pukAl05EuTws=;
        b=VFxMMs9IctzNG9bXOilzS8tuZNqKxhkQ+PLgli+U1Z2QDSrgr6fK/QZwcoefqQ7dMl
         fk/X8C55Le0oWxKP2r7BAmk3hW19ZHfIstDeAtDuraIVqCt6pQ1UfyF5hQX30bHwPkFz
         GPt6msvwvaBLbj7VlJli/3hKVLOY6hOoov3Hxzh3dSgF9+kW28jHCruIoDZZCwUYaUu3
         nIaMTf4rfHqGI4wlXe/y7MEWfDptYwBSz8ygYcBXxk6bYCLOwcjtyUc6qFoRuTAF65cA
         onJYRqnHPJLmZKMlCCDzT9dehCQ+gtavpMmA2YzVJgkqm/9O3oR6Gl88t9/VyMFdLTFn
         jGfA==
X-Gm-Message-State: AOAM532kR/GG3jRAHVrvQzRDBpFJuGh2aXgTjeDFsP1RuKyAzLXn+5ws
        +tnDPDbzk1dZH3Z+xkxK+75T4ae8CixDMQ==
X-Google-Smtp-Source: ABdhPJxCyPkvAC/1zsx3cLBzAVQAvVUt6KZS6L9LBmrU/jVzsbM4wwPNP8IatVlzERw24Tf6Vbq2Tg==
X-Received: by 2002:a63:f70f:: with SMTP id x15mr170946pgh.109.1615829319543;
        Mon, 15 Mar 2021 10:28:39 -0700 (PDT)
Received: from ?IPv6:2405:201:600d:a089:d096:1684:81a3:45b7? ([2405:201:600d:a089:d096:1684:81a3:45b7])
        by smtp.gmail.com with ESMTPSA id c24sm229672pjv.18.2021.03.15.10.28.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 10:28:39 -0700 (PDT)
Subject: Re: [PATCH 00/10] rsi: fix comment syntax in file headers
To:     Kalle Valo <kvalo@codeaurora.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     siva8118@gmail.com, linux-kernel-mentees@lists.linuxfoundation.org,
        amitkarwar@gmail.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20210314201818.27380-1-yashsri421@gmail.com>
 <CAKXUXMzH-cUVeuCT6eM_0iHzgKpzvZUPO6pKNpD0yUp2td09Ug@mail.gmail.com>
 <87a6r4u7ut.fsf@codeaurora.org>
From:   Aditya <yashsri421@gmail.com>
Message-ID: <643c93f6-1c01-a18d-6ef6-d4d0fb5304fa@gmail.com>
Date:   Mon, 15 Mar 2021 22:58:32 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87a6r4u7ut.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/3/21 2:11 pm, Kalle Valo wrote:
> Lukas Bulwahn <lukas.bulwahn@gmail.com> writes:
> 
>> On Sun, Mar 14, 2021 at 9:18 PM Aditya Srivastava <yashsri421@gmail.com> wrote:
>>>
>>> The opening comment mark '/**' is used for highlighting the beginning of
>>> kernel-doc comments.
>>> There are files in drivers/net/wireless/rsi which follow this syntax in
>>> their file headers, i.e. start with '/**' like comments, which causes
>>> unexpected warnings from kernel-doc.
>>>
>>> E.g., running scripts/kernel-doc -none on drivers/net/wireless/rsi/rsi_coex.h
>>> causes this warning:
>>> "warning: wrong kernel-doc identifier on line:
>>>  * Copyright (c) 2018 Redpine Signals Inc."
>>>
>>> Similarly for other files too.
>>>
>>> Provide a simple fix by replacing the kernel-doc like comment syntax with
>>> general format, i.e. "/*", to prevent kernel-doc from parsing it.
>>>
>>
>> Aditya, thanks for starting to clean up the repository following your
>> investigation on kernel-doc warnings.
>>
>> The changes to all those files look sound.
>>
>> However I think these ten patches are really just _one change_, and
>> hence, all can be put into a single commit.
> 
> I agree, this is one logical change to a single driver so one patch will
> suffice. I think for cleanup changes like this one patch per driver is a
> good approach.
> 

Thanks for the feedback Lukas and Kalle. I will be sending the
modified v2.

Thanks
Aditya
