Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43246180B5F
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgCJWUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:20:24 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35253 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgCJWUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:20:24 -0400
Received: by mail-qk1-f194.google.com with SMTP id d8so232985qka.2;
        Tue, 10 Mar 2020 15:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NEpWOdVoi/iDtTT5Bsmm6f/B1M2omplWiBwyNHZRkjI=;
        b=Jf/Q/zMHy+/L1gSUu+KICKyM/xmYJDxJ/IbQ320PnkWOU0159X1Aky8hQAVWPT5Iag
         lNxYCngL3V54655yZwv5ANH+Ye+upLo5I/HO/d2S4OoqS+I21E01Aw0z9vydNtwJcrUd
         2n63OYFANiT3HNOVGC7Bc+n52vQCG64gBoomIGidOz8seOO5IVKTwt+mk0IenaszTApg
         WdbNM22CJhIhvLJnfvmgJeDWQ6DjU3H+2q2MeSzo/kBWAWj/j2TQMkRfTcf/s25hfOL2
         gBgEJ3icckH86dBWOa/CGyaKUijdtO0i6feJs/s7ppZebqRSKiFJsmdjjDQU9Uxf0WwX
         sBCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NEpWOdVoi/iDtTT5Bsmm6f/B1M2omplWiBwyNHZRkjI=;
        b=Ipoohm0V4YfqU4UonYykrRgipm68y04JrubxVQoe3bnQio7s62kH4+JC6T2VCxMaYd
         lnptPRhR86XJcbn66rXJAdQflh8VtjYUWFkA77coiZYPkSmK7oOXJgrKi7WETnmS/5n6
         ABVefWdbEqOomOh4axA/Y8fQGtMIxdkIqfAXuwVYixuBheiGNOwuX/Hp21co6fgspXiP
         FXc0lkhkpZIYfyZ983MOB7OuBDHFW8i7IkU7Jvy2z7f4qYkmxIOlXpb78ncQrfBdD4Oq
         YZMxnUySyz7CzQmYMsNT6y4fIk3yJn5lpJwewXJjkPdWurZnMn85gXiNAFfejCJqDcNk
         Tgng==
X-Gm-Message-State: ANhLgQ2X7OPFkXnTqXS3UQVjihthoCD4Zr3InsS3tJEikOfPOhaRXMtH
        gC7N11vmp/AfjLQxvQ4vGgUrka4g6Is=
X-Google-Smtp-Source: ADFU+vu5osNvBMkK/6mmAyOzwJOslfa0QZFZDJ9P4Ra92MuBL0vU9KuWTYyPACu33MxlkJH9/IY2gw==
X-Received: by 2002:a37:66c9:: with SMTP id a192mr109147qkc.10.1583878822402;
        Tue, 10 Mar 2020 15:20:22 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d1::111b? ([2620:10d:c091:480::fee])
        by smtp.gmail.com with ESMTPSA id g3sm9305059qke.89.2020.03.10.15.20.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 15:20:21 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH][next] zd1211rw/zd_usb.h: Replace zero-length array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Joe Perches <joe@perches.com>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200305111216.GA24982@embeddedor>
 <87k13yq2jo.fsf@kamboji.qca.qualcomm.com>
 <256881484c5db07e47c611a56550642a6f6bd8e9.camel@perches.com>
 <87blpapyu5.fsf@kamboji.qca.qualcomm.com>
 <1bb7270f-545b-23ca-aa27-5b3c52fba1be@embeddedor.com>
 <87r1y0nwip.fsf@kamboji.qca.qualcomm.com>
 <48ff1333-0a14-36d8-9565-a7f13a06c974@embeddedor.com>
 <021d1125-3ffd-39ef-395a-b796c527bde4@gmail.com>
 <fb3395d7-e932-10ac-1feb-ab2ceb63424e@embeddedor.com>
Message-ID: <361da904-5adf-eb0c-e937-c5d2f69ac8be@gmail.com>
Date:   Tue, 10 Mar 2020 18:20:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <fb3395d7-e932-10ac-1feb-ab2ceb63424e@embeddedor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/20 6:13 PM, Gustavo A. R. Silva wrote:
> 
> 
> On 3/10/20 5:07 PM, Jes Sorensen wrote:
>> As I stated in my previous answer, this seems more code churn than an
>> actual fix. If this is a real problem, shouldn't the work be put into
>> fixing the compiler to handle foo[0] instead? It seems that is where the
>> real value would be.
> 
> Yeah. But, unfortunately, I'm not a compiler guy, so I'm not able to fix the
> compiler as you suggest. And I honestly don't see what is so annoying/disturbing
> about applying a patch that removes the 0 from foo[0] when it brings benefit
> to the whole codebase.

My point is that it adds what seems like unnecessary churn, which is not
a benefit, and it doesn't improve the generated code.

Best regards,
Jes
