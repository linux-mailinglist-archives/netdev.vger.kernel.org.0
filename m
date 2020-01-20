Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A34A1430E6
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 18:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbgATRjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 12:39:49 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45527 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgATRjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 12:39:49 -0500
Received: by mail-pl1-f193.google.com with SMTP id b22so128702pls.12
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 09:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Wf30pxM6yJw5r86D0MZMogGqyjhnuDGT22bEtdTrsO0=;
        b=GE91JJl242oKxUyX7GMB6YsMn+MQodChAX2VCy81Cc4qotjL1Z4zUNDFkf/pAyjpIZ
         GKK9S6NpnbgLyEpNhWFmoOMrg/bHSJfUJC4L0XYjXLBO/merM0usdnz9RIj6/zWQZnUm
         KJanRgcwm4WK5bmXHul84lIXANXhuXsToC1c+uykxaVdXHtHC6DtsE6oXa0Kp4ym5A2P
         iH/dPpIrNIveU3/ibzB99XMRPPyUthiqH6RZGWTsON1T9PKXiExlzqkhSbjesiT098CT
         G/PP4KfvlGs0WtAssspMmWXFfm1BbuJM7GgfPcaT7i+Cw+LZsSbJqIir5inTut8da2cu
         kV6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wf30pxM6yJw5r86D0MZMogGqyjhnuDGT22bEtdTrsO0=;
        b=uEq4uEfWI3LCFLDKiAr50t5anH1cAhOXiVCf9Eu1IvZuwED6/N/4gAJZd0bXGCtbxb
         Slx9Ml8b9C2PgyoWxz1WH1Ku4shuE7R8UPjo0MJP/iKiaUxUI1BTAqU7lNe/QCzGphcN
         5D1pNtEEhQYdqoE7UN1IvOfR7fhxX0C2DmW3JVsX64lTQMsMlBUzlRbts6W94LaHAHdN
         dnGeFWvkyB0zRNJM05/pBJt0NvloNWhn1z5dRQnCRulFFumUKMNS7EYhAOZqn9n3Fdh6
         h7/zhNF50bBHm2EjW3c4p6+bdf2xNgGocsGrxAABw53wtLRIHDFVgnotxgb669eOpZit
         uLJA==
X-Gm-Message-State: APjAAAV2x4VKGlKdTBCOfkNS3mefwwcsQmTIG8qWqavP6muBpN8X9UE2
        sfNU4YXsxa6j2MFrMW3NfJc=
X-Google-Smtp-Source: APXvYqzbHyi5i+/Fk1AexkA6WZCeO1d//BHVcg24T1oSfILObw2isSKWQFBpUicWItWskQTA0du1dw==
X-Received: by 2002:a17:90b:3109:: with SMTP id gc9mr107698pjb.30.1579541988634;
        Mon, 20 Jan 2020 09:39:48 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id fa21sm71646pjb.17.2020.01.20.09.39.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2020 09:39:47 -0800 (PST)
Subject: Re: [PATCH] net: usb: lan78xx: Add .ndo_features_check
To:     James Hughes <james.hughes@raspberrypi.org>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
References: <20200120111240.9690-1-james.hughes@raspberrypi.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c7b52e83-44f7-76d2-3075-c3340df2ff48@gmail.com>
Date:   Mon, 20 Jan 2020 09:39:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200120111240.9690-1-james.hughes@raspberrypi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/20/20 3:12 AM, James Hughes wrote:
> As reported by Eric Dumazet, there are still some outstanding
> cases where the driver does not handle TSO correctly when skb's
> are over a certain size. Most cases have been fixed, this patch
> should ensure that forwarded SKB's that are greater than
> MAX_SINGLE_PACKET_SIZE - TX_OVERHEAD are software segmented
> and handled correctly.
> 
> Signed-off-by: James Hughes <james.hughes@raspberrypi.org>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !

