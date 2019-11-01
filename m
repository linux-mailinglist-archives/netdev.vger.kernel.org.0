Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D4BECA4D
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 22:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfKAVbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:31:44 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35064 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfKAVbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 17:31:43 -0400
Received: by mail-qk1-f194.google.com with SMTP id i19so2948518qki.2
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 14:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=UhCdITbnMEPxdWYd5oSjnQcR2dTwNbgmLprqXoXoLKI=;
        b=dgWpr+JhhzUIsHoeyElLVgnLjMvXQfv0PeTKpt1z11jQFkXtuOLnqs24iUAV0zh0+Z
         ymW0fKLrMdPhdmgrBckj8+SR7E+N8TFV/ZIexRGyIJckkh3pXrHw65i1z3NZv7oLmIEp
         zQjPOFy58JB9efehcKTsk1QSLSul7z8mkKnShlMCPjtkOvPuhDq6YQVkDsuxfKIVLhQI
         6B2+VhzZuVttqEj84tg0mGbTKI1POsFAjc3t88avzoPrSjlPWpmAYy6JQfiYwuGXZL5W
         yAILvBMJQ7Cf8ljW4pMLCByXACAD0d2K3HUyafZfIaTCfSgGX8Y3fYVG5qsrfEEAP4Tw
         vW9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=UhCdITbnMEPxdWYd5oSjnQcR2dTwNbgmLprqXoXoLKI=;
        b=CDOd0SeZqxc9OO2DOqJx2uTTaA6DLxbmNw/czwTwWB6uRdOW4GUBT2BygaMrYszrk4
         EofU8qpXWMH8UTBjrnOjuVGSQkVWCYhgaNLqGk107eniPL/oAFIbjEwnB1ds5/eoZ6Hh
         QvhtBTLD1Tv4hwg6Xv9HliYXF23vbRFreFKI26zxju9gHvSShxSRv/KRCv7WOGnceljU
         tnAefqJiK08Tq9AcSxMAAPVikT95w7f2DHfKEFf8AHg8TRC9qvEJL5yELhidYKeaWe7Z
         XvOdMEWr94GrgxX0RRLZs4fBRAYc64UHuL5TVaDq7/W+xmrLWtQVC3FJd22OtmPF3Krx
         35Wg==
X-Gm-Message-State: APjAAAVApFI+VvUKa4pRjBrN78M42GqVci87iFORoi06kwKGHxhxHSih
        rPWZPV2HJL2FJ8nXvYGIQ4Rtw23rrxs=
X-Google-Smtp-Source: APXvYqwDHzMori8JxpAq6LZGznytduTwoOHynn+PGxalTuLGtUzKHM2oElFGqVJyTNGVgL3JGaQyxA==
X-Received: by 2002:ae9:e30d:: with SMTP id v13mr8194982qkf.401.1572643902694;
        Fri, 01 Nov 2019 14:31:42 -0700 (PDT)
Received: from [192.168.1.104] ([74.197.19.145])
        by smtp.gmail.com with ESMTPSA id f10sm3509361qth.40.2019.11.01.14.31.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2019 14:31:42 -0700 (PDT)
Subject: Re: Followup: Kernel memory leak on 4.11+ & 5.3.x with IPsec
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org
References: <CAMnf+Pg4BLVKAGsr9iuF1uH-GMOiyb8OW0nKQSEKmjJvXj+t1g@mail.gmail.com>
 <20191101075335.GG14361@gauss3.secunet.de>
From:   JD <jdtxs00@gmail.com>
Message-ID: <7faa5b0c-d404-8b5b-3f00-f3814c5a2487@gmail.com>
Date:   Fri, 1 Nov 2019 16:31:41 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191101075335.GG14361@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/2019 2:53 AM, Steffen Klassert wrote:
> On Wed, Oct 30, 2019 at 02:30:27PM -0500, JD wrote:
>> Here are some clear steps to reproduce:
>> - On your preferred OS, install an IPsec daemon/software
>> (strongswan/openswan/whatever)
>> - Setup a IKEv2 conn in tunnel mode. Use a RFC1918 private range for
>> your client IP pool. e.g: 10.2.0.0/16
>> - Enable IP forwarding (net.ipv4.ip_forward = 1)
>> - MASQUERADE the 10.2.0.0/16 range using iptables, e.g: "-A
>> POSTROUTING -s 10.2.0.0/16 -o eth0 -j MASQUERADE"
>> - Connect some IKEv2 clients (any device, any platform, doesn't
>> matter) and pass traffic through the tunnel.
>> ^^ It speeds up the leak if you have multiple tunnels passing traffic
>> at the same time.
>>
>> - Observe memory is lost over time and never recovered. Doesn't matter
>> if you restart the daemon, bring down the tunnels, or even unload
>> xfrm/ipsec modules. The memory goes into the void. Only way to reclaim
>> is by restarting completely.
>>
>> Please let me know if anything further is needed to diagnose/debug
>> this problem. We're stuck with the 4.9 kernel because all newer
>> kernels leak memory. Any help or advice is appreciated.
> Looks like we forget to free the page that we use for
> skb page fragments when deleting the xfrm_state.
>
> Can you please try the patch below? I don't have access
> to my test environment today, so this patch is untested.
> I'll try to do some tests on Monday.
>
>
> diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
> index c6f3c4a1bd99..f3423562d933 100644
> --- a/net/xfrm/xfrm_state.c
> +++ b/net/xfrm/xfrm_state.c
> @@ -495,6 +495,8 @@ static void ___xfrm_state_destroy(struct xfrm_state *x)
>   		x->type->destructor(x);
>   		xfrm_put_type(x->type);
>   	}
> +	if (x->xfrag.page)
> +		put_page(x->xfrag.page);
>   	xfrm_dev_state_free(x);
>   	security_xfrm_state_free(x);
>   	xfrm_state_free(x);

Hi Steffen,

Thanks for your reply and patch. It applied cleanly to 5.3.8.

Early results are looking solid. Been running a test for approx 4 hours 
and the memory appears to be staying consistently the same.

I will keep the test running over the weekend just to make sure, and 
I'll follow up with you on Monday. If you still want to test it/verify 
it's fixed, please feel free.

