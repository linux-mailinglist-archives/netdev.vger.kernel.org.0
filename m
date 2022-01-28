Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF0349FD97
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 17:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349911AbiA1QEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 11:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235310AbiA1QEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 11:04:45 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDF4C061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 08:04:45 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id h20-20020a17090adb9400b001b518bf99ffso11325714pjv.1
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 08:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=f0bjEmIIIoUkWWzpp2W/+V9lhmgF7r4w9XidjjkYdR0=;
        b=TzzOO6CHPX+z4Q7fuEOrtfRGOBF6oVzsiijZBFQpaG8idOTeefM5ltZummGhNvSyhh
         yjkMuQ9W+JGKgApR21gvIP2Jpx6Uha1qx5W5PnYb75Qsox0bJmAl3cIRzunAaADv8h3z
         jrJnNKciIhClRZEF/HT0Hi4fTQTXSaRZOn9dIx5/4mdrwlyZwHO6fe9nq/kqmVgicBc6
         bRbnJ0xEiw9JgIH2HFY4Lo+6eEfJL6Y1U7knvpHcw1sM5IoqmQ1xhSy00ZqSK9ZCrwz9
         FcTWkOjBTPm0LeApq0cOuSIBVW9/GluwJBPXc+xh9FEW5SfYbi8+17AkEGj0CnnDk/nP
         miNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=f0bjEmIIIoUkWWzpp2W/+V9lhmgF7r4w9XidjjkYdR0=;
        b=QWOTeFlSsNSI4I35hTamsUFOTqXIccvCDspYFspw4AdBVakC+3C1GO16w3aNvspjzK
         ssebwoIywvSN7P1NtcwmZ1ARIv61ZkNfOzyhDP61ppPatii+wnUp0oPlM3FV/nfCk3vp
         eXUKpJYvNA1zsKfrzH20krMwmLyqaceghlXKsoNH77rYft2l6TmhRIDVEPVpJ2dSs2m5
         eGWmIu5WepNy4ZJj+ggR/W146kYifHpfDVL+g6jTzyqdmnnaTgnV4Y9RHTnZqKaOt93w
         mGciSENsb02wExJP1g4I3Irbcf2S1NJ5LsiKdd+q1XP/ZpInpUaBy0EvjisTnM5VQmpW
         RcTA==
X-Gm-Message-State: AOAM53312tKl6dv43Oopu+cnr8fESZ/8jbvLgl7Lt21AMD3IuNDBd8rG
        8JeS9xZmTNK33qENjYdjta0=
X-Google-Smtp-Source: ABdhPJxoeZy0R2MVrWHy7gySWhoK/JGsjIGcNLPPud3QgTkB9qGom3zqhXIhhBVKwe2NfxS23eSreg==
X-Received: by 2002:a17:902:ab8e:: with SMTP id f14mr8975448plr.103.1643385885154;
        Fri, 28 Jan 2022 08:04:45 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g19sm4055550pfv.4.2022.01.28.08.04.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 08:04:44 -0800 (PST)
Message-ID: <4ebd8840-be4d-fc5b-d83f-a40dfd219e54@gmail.com>
Date:   Fri, 28 Jan 2022 08:04:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v6 01/13] net: dsa: realtek-smi: fix kdoc
 warnings
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de, davem@davemloft.net, kuba@kernel.org
References: <20220128060509.13800-1-luizluca@gmail.com>
 <20220128060509.13800-2-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220128060509.13800-2-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2022 10:04 PM, Luiz Angelo Daros de Luca wrote:
> Removed kdoc mark for incomplete struct description.
> Added a return description for rtl8366rb_drop_untagged.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
