Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395EE2B3F84
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgKPJIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:08:50 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56083 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728511AbgKPJIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:08:49 -0500
Received: by mail-wm1-f68.google.com with SMTP id c9so22983792wml.5;
        Mon, 16 Nov 2020 01:08:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0KWD0bnj4k/0SSS3VjjzTSsaeo2Viy6TEj9KR57CckA=;
        b=NeqR2+yoO4n8oBM84I54S6TdrDkI9U707uNguAlyZM3vl/ea2N5br8gjH1/0qUxD/H
         mWOI21Pa43v8fiFTAmB475NBgprCkLUBoIa+YTNMKQD217p5NQXnlJ9moQhyX7BUYn9+
         Bh99R5rZ1Ddm4EMJtppjVcC+AsJZL27QlHjxmoR7uumBdRayhU1ebQ9EyhuUuMcYFFzY
         qJ3gqfdQ0BcMF4cTDo3/T123/uz+CMNwun+2yPqr8rECrxitk7sfpWfbjZ01Hj6QkKSP
         q/xhHFXqtOWKVEquXzfkIGtGxacOssVu3b2QiNsB80HnS/+KsFPiEcHxBKRKQAwVqgGR
         +ICQ==
X-Gm-Message-State: AOAM53071xlMa8J+pQObYIAlHV/ej6RIGcUIfs7C8uNSAemLprr4uVW5
        muOeEgYdCyRx8S53wmKKPCh8fjUUse4=
X-Google-Smtp-Source: ABdhPJz/Lf2wqPhOxrZqNgUCCJkm0zp09JujFcjpcJD08dh6iRRnjH4y8BACbHylFmzfQqCiTza3IA==
X-Received: by 2002:a1c:c2c3:: with SMTP id s186mr14756745wmf.160.1605517727932;
        Mon, 16 Nov 2020 01:08:47 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id o205sm19078656wma.25.2020.11.16.01.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 01:08:47 -0800 (PST)
Date:   Mon, 16 Nov 2020 10:08:45 +0100
From:   "krzk@kernel.org" <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon@samsung.com>
Cc:     Krzysztof Opasiak <k.opasiak@samsung.com>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] nfc: s3fwrn5: Change the error code
Message-ID: <20201116090845.GC5937@kozik-lap>
References: <CGME20201116011950epcms2p68117cc4a7228db2baecb7d4a4840b955@epcms2p6>
 <20201116011950epcms2p68117cc4a7228db2baecb7d4a4840b955@epcms2p6>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201116011950epcms2p68117cc4a7228db2baecb7d4a4840b955@epcms2p6>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 10:19:50AM +0900, Bongsu Jeon wrote:
> ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  drivers/nfc/s3fwrn5/s3fwrn5.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
