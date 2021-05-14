Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D2B380189
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 03:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbhENBo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 21:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbhENBo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 21:44:26 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD109C061574
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 18:43:14 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id q7-20020a9d57870000b02902a5c2bd8c17so25269411oth.5
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 18:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pNZvmZvKd1iamWe2K0NJ3BobbL0ETJfh8Aahfbg8xIg=;
        b=NWJt2ujFOj1oPxKlQXbDsEd6dTbPzL97qrr7C54RC0ZM3VMQA7rsEpDlkdXqlVjU99
         RXjQEG68No3Z7KhYALkc6ivd5MiWpp1jUzqQd7q1ByQkqqJK+QNWpKoE8jDaQngYWrrL
         alTVFruyGtkfGAk/E5J8UzL0N8S51V5pVXWM14+1yCX4LZGC8e61stDn3vY8AOhdUUQF
         gKFzEBLZwWzPczV8pSwFooGgogzVHS7FwbTPIX5O6GMwsEe5pH2fllwelfKrA2FXCq9G
         lMTSzxh3Tglbb6Dy76jfpccCIA4bY1i37IsQA5fupFvWNWWb2Ad4ng2D623vliSyxqwH
         mjqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pNZvmZvKd1iamWe2K0NJ3BobbL0ETJfh8Aahfbg8xIg=;
        b=dyT8U7P9YXvbaXtzcAiSs7Ap2x+wOZfxnLd6Yn/r9j1+/1NNAoKmYf+NBO/RETEuE6
         mXG0pbR/r+ZKTyYNs97pWiKjSfhTNL5sr5riPSj95ATCKKg98SRTb7IVNDUoUAjqoKlB
         u89+3qbawvt7OyvHTNC9pGN0pH/stHE4m/ue7TyyShtKcqpb3Jjjpa+kqdSsjPSUF9PY
         SGPz8bRNUlM9HP9LYwR4OTT+E/daguqbgjM7nkIf2YT2rw4Z5e9H6JyH5PWsCpY8SMas
         r3FYJlcEaJKlZ1AZ2/znqFBlRWbd2lhH4dbaeqH0Yb6CoyMQpvmzp769nFnw41GmF7Ti
         sv9A==
X-Gm-Message-State: AOAM531imw51MQ8iWIcNFHdh0oSRg2OOPjMMZkjkifHla91bY2doJtaw
        EvQj1WzC0e3GydUuXsa+N2M=
X-Google-Smtp-Source: ABdhPJyFw9XbjeVISLQX03zedP05O7NvOkgr+i6Oq5Rk7eK8B0MYHkjPGdAZFOfj2CBGuevqppJt9A==
X-Received: by 2002:a9d:761a:: with SMTP id k26mr36648698otl.193.1620956594236;
        Thu, 13 May 2021 18:43:14 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id 2sm1028078ota.67.2021.05.13.18.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 18:43:14 -0700 (PDT)
Subject: Re: [RESEND PATCH net-next 2/2] selftests: Lowest IPv4 address in a
 subnet is valid
To:     Seth David Schoen <schoen@loyalty.org>, netdev@vger.kernel.org,
        John Gilmore <gnu@toad.com>, Dave Taht <dave.taht@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
References: <20210513043625.GL1047389@frotz.zork.net>
 <20210513043825.GN1047389@frotz.zork.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2d21eacb-68f8-767c-5aec-e42ae6aab544@gmail.com>
Date:   Thu, 13 May 2021 19:43:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210513043825.GN1047389@frotz.zork.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/21 10:38 PM, Seth David Schoen wrote:
> Expect the lowest IPv4 address in a subnet to be assignable
> and addressable as a unicast (non-broadcast) address on a
> local network segment.
> 
> Signed-off-by: Seth David Schoen <schoen@loyalty.org>
> Suggested-by: John Gilmore <gnu@toad.com>
> Acked-by: Dave Taht <dave.taht@gmail.com>
> ---
>  .../testing/selftests/net/unicast_extensions.sh | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


