Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFEF60B21
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 19:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbfGERjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 13:39:11 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33141 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728046AbfGERjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 13:39:10 -0400
Received: by mail-wm1-f68.google.com with SMTP id h19so8058249wme.0;
        Fri, 05 Jul 2019 10:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O9swPDSYJr7EZr0T51si6Xds/FIWrNpB8I77hOVCdac=;
        b=AsjGyWu0MHdt/aDHe2ScBNnWcXK2JghONx4e7bVU/PT/gIxmdT7GSSZBqfQ+ACsqHJ
         tuIR66s+1jTR12Awc09QCIcX8iULwNyjA29Euk4BmJZH2k4Vccjoo6Z295zetx8EcGnG
         LgqZY5iKixA54ah6GVs2OjsNjm7D8Nz4r4lfFO0cX+8EUudkm3d5O0iS+G/GGFSylON4
         3vx/v+2SlQ5PngJ4PhU0wFChELrxEa+9U01/+Nlu6N87JLdHVRGwRExGVFMgFboUOfZH
         UxltwTJ1a76+06JpAUzDHGZukNB8YsCZjWYvZboOsvKt77WON9hHkBx/Fjax4mBcjvCd
         pVVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O9swPDSYJr7EZr0T51si6Xds/FIWrNpB8I77hOVCdac=;
        b=COwFyBk+ZuDloiytsuQUeLusEFUBhvsWDJI7QjSKtDs0St9cbVhNvsLNgynBZecLqW
         vEloIURTKLT5S555bLnj4G8FmYu+m2YHf/jpDIhM4TvTl3g0WGI14E7m+9WG93ph8tXZ
         zdABj65Dn64eYzsJ0ZbR/5jS6t5ieLgVZbFVvLhbLjjsBOvCS5sGXCDBG4pkiEu/Odg5
         JkTuHSwwdBUp3vDSA711sX/lQ8fccsA3/30e//oCXaRIj2ikiMnkjCLrYTy/wgl3hYSe
         XmG5D7N5NqNCkw68Q8pGph/2E7MkmLvlBqSgGdVtDlyFWXwGonHnxqshH3dO7C+Ep1cK
         s9kw==
X-Gm-Message-State: APjAAAVbsq7vYpJHTU/C0IxlkGReeG7qSp1mcv6jf4p68xG9imEL6dDB
        GSFZGYHxB4/qNBQoHn/jIh8=
X-Google-Smtp-Source: APXvYqw5WcQTpZtNvpZ+cJoxIYsaxIoyD7mLrOjU6KaPopbVyzxZhfATA+8fFZQon60yNsmXWnHIBQ==
X-Received: by 2002:a05:600c:389:: with SMTP id w9mr4093632wmd.139.1562348348266;
        Fri, 05 Jul 2019 10:39:08 -0700 (PDT)
Received: from debian64.daheim (p5B0D78D1.dip0.t-ipconnect.de. [91.13.120.209])
        by smtp.gmail.com with ESMTPSA id q15sm6435218wrr.19.2019.07.05.10.39.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 10:39:06 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1hjSAs-0004pn-CZ; Fri, 05 Jul 2019 19:39:06 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     chunkeey@googlemail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net
Subject: Re: [PATCH -next] carl9170: remove set but not used variable 'udev'
Date:   Fri, 05 Jul 2019 19:39:06 +0200
Message-ID: <3184726.muxUovjW6g@debian64>
In-Reply-To: <20190702141207.47552-1-yuehaibing@huawei.com>
References: <20190702141207.47552-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday, July 2, 2019 4:12:07 PM CEST YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/ath/carl9170/usb.c: In function carl9170_usb_disconnect:
> drivers/net/wireless/ath/carl9170/usb.c:1110:21:
>  warning: variable udev set but not used [-Wunused-but-set-variable]
> 
> It is not use since commit feb09b293327 ("carl9170:
> fix misuse of device driver API")
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Christian Lamparter <chunkeey@gmail.com>



