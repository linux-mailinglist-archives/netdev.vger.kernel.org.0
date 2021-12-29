Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193A1480E95
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 02:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238214AbhL2Bdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 20:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232378AbhL2Bdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 20:33:50 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06494C061574;
        Tue, 28 Dec 2021 17:33:50 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id b77so11211673vka.11;
        Tue, 28 Dec 2021 17:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IBcil9O+VRrBlwSK9WQFnnXvi87jfhzw0Yvv4tQzzQ4=;
        b=noDIEQ8P8sUYyX/OE18Q5FGCEdOtXRbYUWogiKJXUl19FWceFTLSzy33NO7370WsVb
         xNtywJS1aHmXYo/ZkLPfxpKAuLKxK4YE+eVz8VTkizITqKtfycFbgYZ8mkgMJWEJt21+
         SNTUf5JrpwvWrXhCSoo6DxEmJYz1lYAcgrZn5Siak7Xevszf8m10NCTaN+zXiqI+KIS/
         Eu3eNT4oCfEFd0fiD/WXOlhQ5EblQr9RpaZdLMvylKbA5ymBdmZHyFsCK1nxmVisoAn9
         uYVylo+Wo6Qmr7pTJyQxMeOn82Ns+dOHizKeng6bH3WIfBKj/q/NPdRFTbbgDlFIWhAW
         0Xqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IBcil9O+VRrBlwSK9WQFnnXvi87jfhzw0Yvv4tQzzQ4=;
        b=3eKziM9dojfbmU9z227wmvZxlUvkvXHU2ObjzOZ+JHo4TGEQOGkgkHXx0VIKXk6Rbf
         wp0K0vm1TgBxuOtxfbryl3o+2Q18d/kTpo/EmRMCUboBYL7iH5dvQ7NnrwPvBIVala5L
         Fb960C6ya+ThkV7RaGLzjOyzm3tR+1bNlgdjqUfG8MpB7CevtAbtY7PdIYXACooshlDs
         j1Q4KTlpU0pYnu58qkRrzYRTUMRb0lo92oRsgedX0pJsGZ6vYSOF06g2nYBBGO5Cfbtx
         L4uMl89CL7qfLKHaZ9X3cz0A0lM51OeW0utowExoHZO2TBteF5pymxgUYdMpmghYxy9q
         1/8w==
X-Gm-Message-State: AOAM533T5kB3Po560hb5BI3iCorpl3jAHUh+HrfpwytPABF935FHV/k4
        rWQ/s+0C5WOUZuoj/Dh2Apo=
X-Google-Smtp-Source: ABdhPJwKKoiH34wYig8kLDUOCk3RH8x02XOvCc3/C+ewf+rsM//1r3lSXc1Bk8D6hTuZbPILWEIFJw==
X-Received: by 2002:a1f:9f04:: with SMTP id i4mr7411735vke.33.1640741629056;
        Tue, 28 Dec 2021 17:33:49 -0800 (PST)
Received: from [10.230.2.158] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id d15sm3964460vsb.18.2021.12.28.17.33.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Dec 2021 17:33:48 -0800 (PST)
Message-ID: <5a82690c-7dc0-81de-4dd6-06e26e4b9b92@gmail.com>
Date:   Tue, 28 Dec 2021 17:33:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH bpf-next v2] net: don't include filter.h from net/sock.h
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, dledford@redhat.com,
        jgg@ziepe.ca, mustafa.ismail@intel.com, shiraz.saleem@intel.com,
        leon@kernel.org, ap420073@gmail.com, wg@grandegger.com,
        woojung.huh@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com,
        george.mccollister@gmail.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        hawk@kernel.org, john.fastabend@gmail.com, tariqt@nvidia.com,
        saeedm@nvidia.com, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, jreuter@yaina.de, dsahern@kernel.org,
        kvalo@codeaurora.org, pkshih@realtek.com,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        viro@zeniv.linux.org.uk, andrii@kernel.org, mcgrof@kernel.org,
        keescook@chromium.org, yzaikin@google.com, nikolay@nvidia.com,
        jiri@nvidia.com, wintera@linux.ibm.com, wenjia@linux.ibm.com,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        ralf@linux-mips.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kgraul@linux.ibm.com, sgarzare@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        arnd@arndb.de, linux-bluetooth@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-can@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-hams@vger.kernel.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-s390@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, virtualization@lists.linux-foundation.org
References: <20211229004913.513372-1-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211229004913.513372-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/28/2021 4:49 PM, Jakub Kicinski wrote:
> sock.h is pretty heavily used (5k objects rebuilt on x86 after
> it's touched). We can drop the include of filter.h from it and
> add a forward declaration of struct sk_filter instead.
> This decreases the number of rebuilt objects when bpf.h
> is touched from ~5k to ~1k.
> 
> There's a lot of missing includes this was masking. Primarily
> in networking tho, this time.
> 
> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

It would be nice if we used the number of files rebuilt because of a 
header file change as another metric that the kernel is evaluated with 
from release to release (or even on a commit by commit basis). Food for 
thought.
-- 
Florian
