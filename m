Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DBD2608E3
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 05:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgIHDFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 23:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728188AbgIHDFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 23:05:36 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F332C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 20:05:36 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j34so3641670pgi.7
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 20:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LF59rusRyo98bS7MWP5gs3wU4MnGdW6n0GTyTzodIWo=;
        b=Lk9IkSJ7BpCnTqgVGEmX1F32oUGNAtsuNmTk0+MR+3lRStD5Mu+s5CnqYh8ASeJk5b
         UmKYHoDDsMV3WeMbzLirSN8stUoRuaYNwCdfWlzpPJZv+Q+EAQbzxJFl0KSSIfvTn8MP
         oLzOW5OgegBvm0sKSqjppSHjWIK6IKgo345/KpVxrcCr6JrWyp4EihZMzoqqke4A2Us6
         MxfpSCdP9LU5w4pe1m5r2r3vAorzGZCZ5Ms5nmYz4q4y496lqVy1MkdD0dhbZBZv0yuJ
         7MUvC87ivs2WvbRCZX+e1zt7hDQFqYsly6Bjhj21EfSAUZBzZ+34UzIIK/CleiMD7DVw
         1cyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LF59rusRyo98bS7MWP5gs3wU4MnGdW6n0GTyTzodIWo=;
        b=BGz/0OTBUVHU2z98wyInZTbMl5RQSvfY9Qylfvj+Jo1apI4M92gTb3cwr7l3/RODmq
         1mIrAiUVieXnq7+s3Yh1coIew3SlcKOgteCDDjpF0rG5HGnsKzPtJQ+C7LL2Pb0TLa/a
         pRogZ6bowqfDZExPyciFzuzPVm6Mqy46u8/fKSEN3G7Cl2c/VprFgXon+VMiQMfRKrSZ
         7gEkWXW8iIojmLLGOhCdF+ihr6GNybeHUlzkPE8eL40mg5dhuzMMvWKmUxVaEUciTJJU
         gSdbjwhKaQd6DGcV5Q9XLBmSh5ZU/inzZ/kd9f8cndg6UNAUeChY3sJRPDKf9vDfgLWR
         U+mg==
X-Gm-Message-State: AOAM532xUiTq4/GJ8klWoYHd3wT3i4Iz3kQsILhGO4UWy5XjObnGml1+
        6dtOW7+Z5NYDFW2m2opuprqLttR4L64=
X-Google-Smtp-Source: ABdhPJy/PFMlE7m65RoJhM11aCXkDRN7RCDuu9A4OlsDnqVKSQEqivxCaAHY3fDD6bGY7zZn6FXGKQ==
X-Received: by 2002:a62:d456:0:b029:13c:1611:66c2 with SMTP id u22-20020a62d4560000b029013c161166c2mr20380944pfl.13.1599534334990;
        Mon, 07 Sep 2020 20:05:34 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id v10sm15706014pff.192.2020.09.07.20.05.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 20:05:33 -0700 (PDT)
Subject: Re: [PATCH v2 net-next] net: dsa: change PHY error message again
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org
References: <20200907230656.1666974-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9e5a9e12-a372-fef6-90e2-24593c4b027e@gmail.com>
Date:   Mon, 7 Sep 2020 20:05:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200907230656.1666974-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/7/2020 4:06 PM, Vladimir Oltean wrote:
> slave_dev->name is only populated at this stage if it was specified
> through a label in the device tree. However that is not mandatory.
> When it isn't, the error message looks like this:
> 
> [    5.037057] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
> [    5.044672] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
> [    5.052275] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
> [    5.059877] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
> 
> which is especially confusing since the error gets printed on behalf of
> the DSA master (fsl_enetc in this case).
> 
> Printing an error message that contains a valid reference to the DSA
> port's name is difficult at this point in the initialization stage, so
> at least we should print some info that is more reliable, even if less
> user-friendly. That may be the driver name and the hardware port index.
> 
> After this change, the error is printed as:
> 
> [    6.051587] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 0
> [    6.061192] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 1
> [    6.070765] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 2
> [    6.080324] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 3
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
