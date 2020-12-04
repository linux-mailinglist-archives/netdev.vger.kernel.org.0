Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF88C2CE9FE
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 09:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgLDIin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 03:38:43 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35044 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgLDIin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 03:38:43 -0500
Received: by mail-ed1-f67.google.com with SMTP id u19so4994295edx.2;
        Fri, 04 Dec 2020 00:38:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eAUgRhiSnZxN+OGD6Xc3OKsBy+RlXxdYJUYaOeKp06I=;
        b=by8GUec4J0rnTceCPoMmXWv1MBDJwrfqdrFDbNI9NtoAnKO5uo1dVTY5x0SwzYTpuD
         UW7/8AChC/TIomvribsWJjRkoSoI3k4hAfCHYSERvcHuy8Omv2Aai87fHSxEZyuIrErK
         +gGjGgkUPxo4L5y6xTN2WCHi2UB4raZd4ef9VNV0H8WUHDZwdgGIGj913Sm7QRRim0K/
         8jPgR8lJPQtET/xjGX1G8sI8IXYD6OZ2lrnmdnhQH8KEkG52XxbCWcHMPgbBJteqL/GZ
         D+ga/Q3BXaUh659zOjDUzlraQaQPGtcQuUG/xOuGCAMN2T/0ncYLeoQCyvT/1iVjBJ1S
         mAgw==
X-Gm-Message-State: AOAM533VLpCxG1b9pd9s0XY14BZqeoTncl2B6SspaWZhNUv9YH5/0m4I
        9xhgxtIyoRYtVitd1ZUKFa6qLCGnZ9s=
X-Google-Smtp-Source: ABdhPJwoeQ7DRUewSq/Xsuh/+Aqe+eXqWEbDCW2HM2O2CWaN5JIHQ73iQJSmCs5B/CGsVPM+2/ZnhA==
X-Received: by 2002:a05:6402:2059:: with SMTP id bc25mr6528472edb.13.1607071076163;
        Fri, 04 Dec 2020 00:37:56 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id s26sm2891210edc.33.2020.12.04.00.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 00:37:55 -0800 (PST)
Date:   Fri, 4 Dec 2020 10:37:53 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH v2 net-next] nfc: s3fwrn5: skip the NFC bootloader mode
Message-ID: <20201204083753.GB5418@kozik-lap>
References: <20201203225257.2446-1-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201203225257.2446-1-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 07:52:57AM +0900, Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> If there isn't a proper NFC firmware image, Bootloader mode will be
> skipped.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
> 
>  ChangeLog:
>   v2:
>    - change the commit message.
>    - change the skip handling code.

Patch is now much cleaner and smaller. Thanks.

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof

> 
>  drivers/nfc/s3fwrn5/core.c     | 23 +++++++++++++++++++++--
>  drivers/nfc/s3fwrn5/firmware.c | 11 +----------
>  drivers/nfc/s3fwrn5/firmware.h |  1 +
>  3 files changed, 23 insertions(+), 12 deletions(-)
