Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51831177B4B
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730205AbgCCP6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:58:34 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37765 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729770AbgCCP6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:58:34 -0500
Received: by mail-qk1-f196.google.com with SMTP id m9so3884997qke.4
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 07:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T99u6OQqFuLCQpNf/NdOYpBGisq4CV9Su0pw9sLcqrE=;
        b=WZUSU5IPOxc/4doIWQ/fwX2T/PGyFqg3Yd2VgD5bpqUkyNpG2nuZCCDXvnAA+kckgy
         Vv5apyLaD1l+/B+x9sxUbGzI1kC+i9SR5NMeaXaKWW7jvU/z09RyurFmA59WKrkNBHHu
         14zfA2VC4vcKVg6qDu2j+tT6kMmq416afkxbOGTqMnFrYZtcYA4cApYzUI1vUmEBfFi+
         zr1ZT9NzLLtUUstlNmOSn9p3fhD/NEkBYkXKU0rl0FuTP1YDrzeFe2PLjOhZSH8JMgwT
         2BizSwbZKh26rKhV01xsP8hDl/vxTNIGaGFtrc61qsn3jNFda2EosaZ3F5mmhSEyNy+a
         NKhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T99u6OQqFuLCQpNf/NdOYpBGisq4CV9Su0pw9sLcqrE=;
        b=PUpXsNUcRIagCPq62Xd+zLZ8mrqI0ZE2C8kOFx5ERM1didw1OdWYCR5nm3bpoQoMy2
         exSTgIQe75DGTl8aWDkZCsoFBFWouSFXoWDfEWj2PC43L9c05RBE7QNjDnDE7N7mjBr1
         32lRO4ctiCLJg9rwPfx3XEI8i7kPHbyC8aYxY6LNo/r17e1tySVj6uSfnoYB5xxy95WI
         QtXEq0p7J9nnoo3KD+ME+sR681DYtC1xDGGNkWVvrHHYhboLT6MMJOjYLPxRX67XNnPn
         OBb4EE5GYdUUe0F0slgMlDQ36121WlfudVGqcMYo20E3OJ8bI63gQzPuVG93N5gy7iC5
         6z4g==
X-Gm-Message-State: ANhLgQ2tTx9rwzeWXrMKUl+gFOSvH2JGHi4vshX+URAKyu69WtX/GncJ
        5zHIYivb6nrn12MsOWOsRk0=
X-Google-Smtp-Source: ADFU+vsqtUaN57DsS8OUiqN1U7OriIAWaK2D0vXfHVbAszqdV3cwWGsRJJlUAEfSN9AbzaoL8btj1w==
X-Received: by 2002:a37:e115:: with SMTP id c21mr4926949qkm.130.1583251113492;
        Tue, 03 Mar 2020 07:58:33 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:29f0:2f5d:cfa7:1ce8? ([2601:282:803:7700:29f0:2f5d:cfa7:1ce8])
        by smtp.googlemail.com with ESMTPSA id f5sm10087266qka.43.2020.03.03.07.58.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 07:58:32 -0800 (PST)
Subject: Re: [PATCH net 3/3] selftests/net/fib_tests: update addr_metric_test
 for peer route testing
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Miller <davem@davemloft.net>
References: <20200303063736.4904-1-liuhangbin@gmail.com>
 <20200303063736.4904-4-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <40921d69-3882-c25b-043c-84328cf45f4c@gmail.com>
Date:   Tue, 3 Mar 2020 08:58:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303063736.4904-4-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/20 11:37 PM, Hangbin Liu wrote:
> This patch update {ipv4, ipv6}_addr_metric_test with
> 1. Set metric of address with peer route and see if the route added
> correctly.
> 2. Modify metric and peer address for peer route and see if the route
> changed correctly.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/testing/selftests/net/fib_tests.sh | 34 +++++++++++++++++++++---
>  1 file changed, 31 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


