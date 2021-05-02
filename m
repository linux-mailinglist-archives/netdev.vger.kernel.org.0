Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A239370B16
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 12:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhEBKUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 06:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhEBKUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 06:20:20 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B49C06174A
        for <netdev@vger.kernel.org>; Sun,  2 May 2021 03:19:29 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id w15so2026896ljo.10
        for <netdev@vger.kernel.org>; Sun, 02 May 2021 03:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=QwUvFze+9KAMyRcqid64lXu7mIav5IlHFP55zkjN8zk=;
        b=UlpuCPXICZQyaSIU2rKL8fHbySiYvtmbmLkxhLCfo9OtZT/XS0DHR2AeX7wqkXVBj5
         YNMpKPOBo89j0OdkVt/XEH4OzgbHLwbJexfyS9oVd2QtcdeViy+eabdTneTMsFXxjJF0
         ihEZbJE1JdIegJtF6TbvaWxkBHmozPnGwxh8P2k91524Tp1ks/vy1p2hqesWIrl7NxTE
         jFojLam9LDugXHtYVcvy01xiHuJhPJ7kwlhlXK6/KDiY9jLgf7M4xDrBarPKTfU2cTwo
         xWWexH9abRhcjXQR8mn2X3DgIqEUND6CwES9hO+ndC6W9/nAZDH6GraAI+R3TXh0Or1d
         umZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=QwUvFze+9KAMyRcqid64lXu7mIav5IlHFP55zkjN8zk=;
        b=ZQwCZZ53tL3cyJ/jvL00Kn3AG8IV4R2+TrJg437O8TZDFk3cz3IZu/84q11+p/Fdpq
         htsRAFd/TgqWdg+MB9o1Y8EL4iXvwAOy5FKD6YUYURDPIgSm7NDT395Ok6oOd29HeSOr
         mOtJv77N0GhBP04Fz46jkl6nMdRpzrBq/o7cx56/RCR1ZLQdmisgFY+UwmjKL4B+f/14
         FgiWjEPCyLUBBi1nBUEYKXqgAKQUqm3WutL/Za+KMdBrc8cY5DTKZyHvcRbgRr56+wn+
         FSD02+3jcUzFab/aGVLFKwOtrFyQ+fd7Tqnsk5f/WR6D23m7nmPovoOyUsT1MIIovGs3
         VHfQ==
X-Gm-Message-State: AOAM532kNniRZa6FC/ge6f088FBPFhrZYvXoK3yNvRXch8enVqHybnng
        5y5ZTcCy20yxY19kNvmBmAM+jENVSJo=
X-Google-Smtp-Source: ABdhPJxxJhydpFBkVHP3g3gVdHxKxVrbXuziViAtrE2EKzPk/zWnigkrbc1whRXb5O/O7ooTzx4bJQ==
X-Received: by 2002:a2e:9ec5:: with SMTP id h5mr10123532ljk.169.1619950767741;
        Sun, 02 May 2021 03:19:27 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id p13sm807309lfh.27.2021.05.02.03.19.26
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sun, 02 May 2021 03:19:26 -0700 (PDT)
Message-ID: <608E7EE5.50706@gmail.com>
Date:   Sun, 02 May 2021 13:28:53 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Johannes Berg <johannes@sipsolutions.net>
CC:     Chris Snook <chris.snook@gmail.com>, netdev@vger.kernel.org
Subject: Re: A problem with "ip=..." ipconfig and Atheros alx driver.
References: <608BF122.7050307@gmail.com>                         (sfid-20210430_135009_123201_5C9D80DA) <419eea59adc7af954f98ac81ec41a7be9cc0d9bb.camel@sipsolutions.net>                <608C3B2C.8040005@gmail.com>    (sfid-20210430_190603_013225_96A76113) <acd09ebe17b438fad20d4863dfece84144b5e027.camel@sipsolutions.net>        <608C9A57.5010102@gmail.com> <608D5CA3.7020700@gmail.com>       (sfid-20210501_154106_642617_08B34215) <2784fc9d11a97ae4734d12058a6e0e6564ac9309.camel@sipsolutions.net>
In-Reply-To: <2784fc9d11a97ae4734d12058a6e0e6564ac9309.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

02.05.2021 12:04, Johannes Berg:
[...]
> I guess I can see about making it a real patch, should only take a
> little while to audit (again) the hardware access paths wrt. locking.

Greatly appreciated! Hopefully it makes it into mainline soon.


Regards,
Nikolai


> johannes
>
>
