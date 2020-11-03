Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BB62A50E4
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 21:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgKCUbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 15:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbgKCUbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 15:31:47 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5012C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 12:31:46 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id za3so26220222ejb.5
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 12:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YNzYxjoKXGTxwFPvU6GwdHYBis3nWzjqlBNKfys40e4=;
        b=RJRJ7IrY3h6UE77cSlyKXPCCqdSekJ6zQSafCzIhBGaAWxPP8Z/hlrV1SIXqaJaGF3
         0eauHo3RTLa77rgQtpMWnq/mS2dXcj7tRrSTtoP1RWMu3VNjx1sbriOP56T5Z9ccGtdf
         SrGtBAWuCNBd5wpcQTDEbvLT5uT/oz5Bqq+6pC/4VN1aTNLyJ9FShOJ8nyU0IW9z4hnw
         +rTHCOG2Nr1U3+TJy4XjPwDxiftmb7rlvMIlMW6D4UbRymMHw926QxMYCh33f09VfPOs
         OS4h5yrLfa+2UrZo6p+P1bpUPQ/mjJdXOhdpRnYKRhwAafZG+0udA3T94CYl0UBsdEql
         kPPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YNzYxjoKXGTxwFPvU6GwdHYBis3nWzjqlBNKfys40e4=;
        b=aoYnX44QECXSKMup0KL7SYKYnopcQMujhyos0qu7Op7h6CzG9ZZU/8mp7irzQWXYOE
         1hZfrvx0CkJsDMYvxyycJ5mK3hR3ze/Ngrnagk+nnUhb6FlWQ8fM0cGmjcESZp4Acxb9
         0fO7vxv8HQ97N6vOWioMcW1sC4dP639SDZeTmAcZ5p0DBg5Ja7ppo4AmLDQMMMY+jXfZ
         WchOghxhHNFirVgGXFB2PZeWMLlQ2ZGFzGCIfc70TEH1hpki3WzxSZSB+twMhUc21Tmb
         ueWTq1bcqZsgi7bCHAWA9IFEGgsDcNg2xAU9CuGRKjhr20TW9GCddNcSUHHUW4la1BNi
         73GA==
X-Gm-Message-State: AOAM530ikcpgJmLj+85lOhEdibEJuszkPv/nt+OjV/rc4R5JQACC/a0P
        eSriedPAsDsK4KLSdexxRS9UCg==
X-Google-Smtp-Source: ABdhPJyxFj7/YT6zaH1nc4j98hSL5ce+WKNINxTbDbiB/5e+hsEzvPS9UNElEshPZZoHah4ZBYvogQ==
X-Received: by 2002:a17:906:86cf:: with SMTP id j15mr8207704ejy.260.1604435505392;
        Tue, 03 Nov 2020 12:31:45 -0800 (PST)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:7d2c:d783:ade4:8841])
        by smtp.gmail.com with ESMTPSA id v11sm441590ejj.123.2020.11.03.12.31.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 12:31:44 -0800 (PST)
Subject: Re: [MPTCP] [PATCH net-next v2 6/7] docs: networking: mptcp: Add
 MPTCP sysctl entries
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, kuba@kernel.org, davem@davemloft.net,
        Geliang Tang <geliangtang@gmail.com>
References: <20201103190509.27416-1-mathew.j.martineau@linux.intel.com>
 <20201103190509.27416-7-mathew.j.martineau@linux.intel.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <de3be6ac-1249-9029-cedf-ed744319fc0f@tessares.net>
Date:   Tue, 3 Nov 2020 21:31:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201103190509.27416-7-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mat,

On 03/11/2020 20:05, Mat Martineau wrote:
> Describe the two MPTCP sysctls, what the values mean, and the default
> settings.
> 
> Acked-by: Geliang Tang <geliangtang@gmail.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

Thank you for this new patch!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
