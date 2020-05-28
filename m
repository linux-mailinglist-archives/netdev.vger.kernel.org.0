Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07B11E6E79
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436926AbgE1WQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436879AbgE1WQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:16:53 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C15C08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:16:53 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s10so286572pgm.0
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cVGLi2cE4H5QflwwGd2ucgDGfQlkC0qStpd4VVnfSzM=;
        b=uT/BMW5pn5jyxb0Obs86RMJy5co2ND+dL/anwy6JUCez8j/FY+yrbkKGn86zS2KoHn
         j6ywv8H62FxM1wJOoChNxG/6WO+XWuBm27x8XwwBUZzOUmJ4dUuTbGP5hGsCAk3e9+kQ
         shT+GucxYHEi0BWv8o7LKzdfGjvvwJGlzR+3T0p3dhJBMxq2yS1EcH4H2gnAlWsrK5KX
         jhUQ9k9mm272+svv1Pvcc2opPz6eybiRfT+NrK02x8DAADjRQ3AaHaVOEGUOajDgXIFH
         kZT5iUFz2E7kEsnoc7Ncep5VLCAPIrGGtmQ2HBW9oJHxZv+7quxwGQj4s4EeO3CWiCD1
         sP5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cVGLi2cE4H5QflwwGd2ucgDGfQlkC0qStpd4VVnfSzM=;
        b=qaIFgmvz3fDn2lTy7liM1WXDIx1EVDT7BvqRGCizutGxz66lejwjMQ4VNwPwGT0I38
         YOL4E612rvCwDBt94iHoHnhLnhF2U4SKCH3bxOL6pgZziMkobKxgkMC8fRyBb7jr29/q
         UOGNrjBZmzzDz/6ulFozJL6wxii93CkxA8gy7z8/iRH751GXHtZsqCGI3T+C2ZGgS6/0
         21Su+lr6bzMoDQWwJjIff/qxs6XAtUfI4uw8uQS/TRSVIH3iTKRBmtsUKg3hZDBCGtDF
         jQRCxCLX/OxmwO5lDDxoWATpfkMFPe2+OBFD8AiEQTAPr7golEVDUDXDHJ/btIZ4Py8t
         Vi0w==
X-Gm-Message-State: AOAM532dNwYYnocfoYeN/hOiz+gGENzimIUSQ9gEnVuXnjmUGid9owr3
        DBDzB1XoaGmoQR+D4X/HVhet0M1Y
X-Google-Smtp-Source: ABdhPJz5o1c486EdIrghVlgzk0WMEyBaXvRZZSpqalaeNF2R7UfwZZ+zVmL3tFlWRd0xlLrGRh98cw==
X-Received: by 2002:a63:e60b:: with SMTP id g11mr5451606pgh.120.1590704212380;
        Thu, 28 May 2020 15:16:52 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id y136sm1263224pfg.55.2020.05.28.15.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 15:16:51 -0700 (PDT)
Subject: Re: [PATCH net-next] tcp: tcp_init_buffer_space can be static
To:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20200528220152.3999-1-fw@strlen.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9e50be01-8dfd-fa1f-e632-c79d81b29be2@gmail.com>
Date:   Thu, 28 May 2020 15:16:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200528220152.3999-1-fw@strlen.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/28/20 3:01 PM, Florian Westphal wrote:
> As of commit 98fa6271cfcb
> ("tcp: refactor setting the initial congestion window") this is called
> only from tcp_input.c, so it can be static.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Eric Dumazet <edumazet@google.com>
