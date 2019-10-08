Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 178ACCFEE4
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 18:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbfJHQ0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 12:26:19 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41291 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfJHQ0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 12:26:19 -0400
Received: by mail-pf1-f193.google.com with SMTP id q7so11045000pfh.8;
        Tue, 08 Oct 2019 09:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nUEi7b2Xg516Vucqorkh6nwu1M0azdgypl+CVmTornQ=;
        b=swu2CpUIg8OQXUWKvhzJvvxfnjce9dVwGW+Kp4Yhmnc1bony+SLXPqGadZxoMQ4X3K
         ZbwuWTsEGJC+SSZBmHbdlkiEgJ6xLEoBool16ohacH09/pmV5epWPyyKXnGdpgJsJsd9
         IH6K0bjoidSfQwjaQRtw1bEqSbsTqM9lfgFLYQKo8F2p2UogSrIS7Wy0+oWSt9EFwbFG
         c5EgQ4SPBSHMMPpjRLT9thMWIthzCrKjCzqXqp40AYQZ846Lzj6LQincDbw44UjK7SFS
         pc2KNdtk49cYUzCT6YF4+ikr61GIINh3zd9cL3YIsLqFxXRVCoV8L3kEk/tq8ZmlaG0b
         VF3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nUEi7b2Xg516Vucqorkh6nwu1M0azdgypl+CVmTornQ=;
        b=tt1SShwh/uVHrRcHtUlZ93LlobBNnPgur/Va5ADgMew2TbuCWBf9EXgK4F7aGxI3gu
         DkVMnmhXFHge4c4hsxXjOmf1ACKBi6Ne4YXtEP2wgjtJLOxZiIVYvKN6vdcsEwUXSYbB
         aeo7SzWcV+bWjuYGGUr7YCu7w0QS85K2pfK55DcmV8k5+qHzpQ1cH0cPDkixJMO05KKh
         Pfdnm5HIdaVRWZ9gkt4Oy6sqKgE3q81SWrn4YWRJIuolCvJSV0IBXy1PIJBLMCd20pcR
         fnsXGNg9gD+rMLSjxRTueIcZAOPvvhIA7P0paTfqYbRdtKX2phIfRIAt5MVtUNHLSbxH
         oR4A==
X-Gm-Message-State: APjAAAW88g/ghdgO4z8nAhw78gNC9TLzIcJcBm4yutvDCcW7Y6x+xQgD
        LFf97HwfEogrD4FIbfdzxU9IMC3Z
X-Google-Smtp-Source: APXvYqxSZ5mR4npwRvdNOAmaoGhD0NoABC2Uc6OTEhDb1PsXAYOYcKbb6QmxcLci24zWb95HA6Jg9A==
X-Received: by 2002:a62:2f84:: with SMTP id v126mr40203018pfv.167.1570551977393;
        Tue, 08 Oct 2019 09:26:17 -0700 (PDT)
Received: from ?IPv6:2620:10d:c082:1055::2a69? ([2620:10d:c090:200::3:df92])
        by smtp.gmail.com with ESMTPSA id b5sm15704840pgb.68.2019.10.08.09.26.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2019 09:26:16 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH] rtl8xxxu: make arrays static, makes object smaller
To:     Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191007135313.8443-1-colin.king@canonical.com>
Message-ID: <87e99b3b-6b1d-4eeb-f08f-00cfff5e3b2b@gmail.com>
Date:   Tue, 8 Oct 2019 12:26:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191007135313.8443-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/19 9:53 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate const arrays on the stack but instead make them
> static. Makes the object code smaller by 60 bytes.
> 
> Before:
>     text	   data	    bss	    dec	    hex	filename
>    15133	   8768	      0	  23901	   5d5d	realtek/rtl8xxxu/rtl8xxxu_8192e.o
>    15209	   6392	      0	  21601	   5461	realtek/rtl8xxxu/rtl8xxxu_8723b.o
>   103254	  31202	    576	 135032	  20f78	realtek/rtl8xxxu/rtl8xxxu_core.o
> 
> After:
>     text	   data	    bss	    dec	    hex	filename
>    14861	   9024	      0	  23885	   5d4d	realtek/rtl8xxxu/rtl8xxxu_8192e.o
>    14953	   6616	      0	  21569	   5441	realtek/rtl8xxxu/rtl8xxxu_8723b.o
>   102986	  31458	    576	 135020	  20f6c	realtek/rtl8xxxu/rtl8xxxu_core.o
> 
> (gcc version 9.2.1, amd64)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Looks fine to me!

Assume you mean x86_64 since there's no such thing as an amd64 
architecture :)

Cheers,
Jes

