Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79E88CFE40
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 17:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfJHP6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 11:58:06 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44264 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfJHP6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 11:58:05 -0400
Received: by mail-pl1-f196.google.com with SMTP id q15so8615037pll.11
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 08:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=6gOxaCzvxyQYLEEc3Fio6F/e2srKJMBHV7CJrvKM4Ik=;
        b=nDudyy02/3mEDiFNhdvNbHjNKHwmMVHwOcLOacoWFLTKnvtW0fRDYfGpFixqygLfIX
         NUi1AS5SX6JSh7F8e8x1Mzvzhya3n5O3vu2oWY4jYDXpqesar4EDIwrflLT8qa8yOHKe
         S/uzqLzZ9sDJUBGnenXInbxlOmT2qDBvIhYll7+ApwTtebZO5mBTNxtObcp45LfapkZ/
         JiNkwO+D2DRfX67++p6KFD8JzsItEfZ7Mjs92eZD0/ACkLczCu/AVGNL4Zu/KUuwAoKH
         +YeoWfHIa96q9PG+ezvhijhjpijMIwswNHQ4sjSHESlwoeUdlXVdSnBSPb2YmjLT3TM5
         7ZuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6gOxaCzvxyQYLEEc3Fio6F/e2srKJMBHV7CJrvKM4Ik=;
        b=aTy/g9oYxlMsyZYu3OCEycNpoVEDUjXJimCcUfotpQj9yDpT8NZylgHWWIBfeG34jg
         Glhz6SKrxjB4q0bDy1EPzCdGgkrFpsJuxS8yBWb6acUK5ArO9p7+QGqWN9mdSjMCbOo/
         8PfaA2DTpFA47e2YBEMDavjLrd9h1ayNVoR0H3AR6hyFuPYGsRG8XWviwDQ145cGZx3U
         ideZ+D5nT8BYLwx6G03a4eXk6RfQjzWSmg59hFPkDSMk+McD0PnVGaDRbshdOBL1iTec
         3OWSMdlqwoWdXAXvdMmlCejTMidJRXtpR9pW0eNkmTqnLP/Ro0q/+9tDovKq5d5ADqpo
         tH5A==
X-Gm-Message-State: APjAAAXbCotGS5qGEY984r9cRyW6deym1kNdrOuFi0LVkCkktrbS1qXf
        wa7KpOSQDGJQjnBjaJwmvag5GplAfg896g==
X-Google-Smtp-Source: APXvYqyMyd/vNlcSlAX+bFD6Da7BfqbIJ+bKdeB0IqWNLusQ+gHOnr5asV5zW8Lg2bOFLVdTYTbdQg==
X-Received: by 2002:a17:902:7c94:: with SMTP id y20mr4501178pll.229.1570550285049;
        Tue, 08 Oct 2019 08:58:05 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id k66sm2837304pjb.11.2019.10.08.08.58.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 08:58:04 -0700 (PDT)
Subject: Re: [PATCH -net] Doc: networking/device_drivers/pensando: fix
 ionic.rst warnings
To:     Randy Dunlap <rdunlap@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
References: <b93b6492-0ab8-46a6-1e1d-56f9cb627b0f@infradead.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <c4f5cb98-730f-2818-d166-b6aad9ef75f3@pensando.io>
Date:   Tue, 8 Oct 2019 08:58:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <b93b6492-0ab8-46a6-1e1d-56f9cb627b0f@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/8/19 8:35 AM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Fix documentation build warnings for Pensando ionic:
>
> Documentation/networking/device_drivers/pensando/ionic.rst:39: WARNING: Unexpected indentation.
> Documentation/networking/device_drivers/pensando/ionic.rst:43: WARNING: Unexpected indentation.
>
> Fixes: df69ba43217d ("ionic: Add basic framework for IONIC Network device driver")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Shannon Nelson <snelson@pensando.io>

Acked-by: Shannon Nelson <snelson@pensando.io>

> ---
>   Documentation/networking/device_drivers/pensando/ionic.rst |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> --- linux-next-20191008.orig/Documentation/networking/device_drivers/pensando/ionic.rst
> +++ linux-next-20191008/Documentation/networking/device_drivers/pensando/ionic.rst
> @@ -36,8 +36,10 @@ Support
>   =======
>   For general Linux networking support, please use the netdev mailing
>   list, which is monitored by Pensando personnel::
> +
>     netdev@vger.kernel.org
>   
>   For more specific support needs, please use the Pensando driver support
>   email::
> -	drivers@pensando.io
> +
> +  drivers@pensando.io
>

