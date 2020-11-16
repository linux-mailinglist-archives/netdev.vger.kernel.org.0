Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4932B3F73
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgKPJIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:08:24 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51516 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbgKPJIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:08:22 -0500
Received: by mail-wm1-f68.google.com with SMTP id 19so22984688wmf.1;
        Mon, 16 Nov 2020 01:08:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sZWpXTMZhBYNMXQLkNSi+nx/qUOUqjH8uwxWQ2rWk0s=;
        b=TURybanUEzub3VZi1Xn6OZKgcA/ifswtkSFHXd6uFD77ycnHrbs1q3LPJggcq/tk9Y
         DRCl/kSIQgYoDQfpAYoRYxwC5yol4IdrKkWxB6AMbuJfjVJXr/7hHpA1NsXkKGkQPTZB
         00iUQ4WJEZTG2GyX97SzfpKsCw3wKD6WCkZAupSkV7Ftjigy/eUwUFFjGXInW9hvyCH6
         1Y7lVsr6NMP6+VycgYrm4lcXcxYLVZVuUcxnrCgtdTD9h6vewwvOImGJZAGiZkbDvCRu
         Llvk6TYHrYwRY+rvaWuRbtYfjOU/Mc2eLT7Xjh8Kn/NwNM1gYgU7WkSzeMmQtGaB1JKL
         MvfQ==
X-Gm-Message-State: AOAM5327mKrJQ5flA1MN+ASqPnfNv2q742Dq0yyW1BL2O0P3qUUIHd+z
        gL3m+3IPZk1m8IAMTvahLAQ=
X-Google-Smtp-Source: ABdhPJzeeJsikt2cm7eKacJ2H72vhOCG8oAnZZ3cMfRtvEakrqBU7SwjtlegU3S0hxGyctFwfTLdFg==
X-Received: by 2002:a05:600c:d2:: with SMTP id u18mr14527459wmm.102.1605517698893;
        Mon, 16 Nov 2020 01:08:18 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id v6sm24189475wrb.53.2020.11.16.01.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 01:08:18 -0800 (PST)
Date:   Mon, 16 Nov 2020 10:08:16 +0100
From:   "krzk@kernel.org" <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon@samsung.com>
Cc:     Krzysztof Opasiak <k.opasiak@samsung.com>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] nfc: s3fwrn5: Fix the misspelling in a
 comment
Message-ID: <20201116090816.GB5937@kozik-lap>
References: <CGME20201116011755epcms2p7f7232e0865e8e1bc11a4b528c10d3571@epcms2p7>
 <20201116011755epcms2p7f7232e0865e8e1bc11a4b528c10d3571@epcms2p7>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201116011755epcms2p7f7232e0865e8e1bc11a4b528c10d3571@epcms2p7>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 10:17:55AM +0900, Bongsu Jeon wrote:
> stucture should be replaced by structure.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  drivers/nfc/s3fwrn5/firmware.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
