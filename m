Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F187B9ED0
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 18:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407743AbfIUQBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 12:01:55 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45038 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407692AbfIUQBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 12:01:55 -0400
Received: by mail-qk1-f194.google.com with SMTP id u22so7119999qkk.11;
        Sat, 21 Sep 2019 09:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=0CSgrhBbloI9ST4YUeu2xGwT4V5LMyZuI9sw3TAxPpY=;
        b=HNMWjJOQjqGEp2LQpIZ85bRCLspsMFohflYRHFFZYlzAAK5PiRgbby+fTBAwEMpoUM
         P2oHoqnpDXI9vKlkOM1SE6gTpdKkCtyZdcEbhmnKzuZgq+eUv9QSAhkik+nJafZbQAXu
         CzDybqiMhe+3vl4/idVx8oVae3ErVwuubCb1bEYfX9IG4/U+/Wwf2KSURuHn1bu7xo1f
         ejOaKzvVS3M/MpZ7djm95kYY0ndUxSKBsxBKOHY9vXx+GaXZu+3IrklVVgVJrQRZA6VT
         1Wn25xmDGB6xvAINPTAUMhBzG+xDlYVTn/zzCzZLzyFhE5H5txMSRvauvlzLOChVbl5s
         UjkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=0CSgrhBbloI9ST4YUeu2xGwT4V5LMyZuI9sw3TAxPpY=;
        b=PWkLbyySo1ByqVfhNTAFwrvpq4EnDSxF89s/b9RxFalLXHy0ryIE+WVIGkiPFbzL6B
         yH+Rby0Dv8tGzR9sXf0ejUoncWpJYLwla5X4D5OetOtiW++zBxz/yRSUWQsI9izFX9pA
         LIOj1aj3nG7xJgqv+/4PmIdhMsDR7Ph94hYQNhZKbwWiqxj9EFmVvYSAjzB+Pc2wZYpI
         R2YzkKzebIPO7N6ErWx6B4FmYmgrK1H3By6vTi9eECr9FAMg5bOuoNrzsAiMcGwRwtg/
         B+tmnV7gX4sXpbPG98uQZ1lSp28IO8ftp3te/o+IVRXZVGF30o53JjmH/TBAgjlDlqHg
         GzEg==
X-Gm-Message-State: APjAAAWpmjmhXC4hKcTlwCfc8uE4uaVwZ8IGVc7dnIu4EeVd9l7PjIgk
        TGKAxVS3+PMLB7X2rxGFXDQ=
X-Google-Smtp-Source: APXvYqwlGoGAMiF5vXyUOJEphZ84TrKS+s8bUkYaTTvF3GHUqBYzRnKl0ukBv5wp1nkFmfJekzdGrw==
X-Received: by 2002:a05:620a:783:: with SMTP id 3mr1458576qka.467.1569081713710;
        Sat, 21 Sep 2019 09:01:53 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id t17sm3620412qtt.57.2019.09.21.09.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2019 09:01:53 -0700 (PDT)
Date:   Sat, 21 Sep 2019 12:01:51 -0400
Message-ID: <20190921120151.GD253404@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Nishad Kamdar <nishadkamdar@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?UTF-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: b53: Use the correct style for SPDX License
 Identifier
In-Reply-To: <20190921133011.GA2994@nishad>
References: <20190921133011.GA2994@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Sep 2019 19:00:16 +0530, Nishad Kamdar <nishadkamdar@gmail.com> wrote:
> This patch corrects the SPDX License Identifier style
> in header file for Broadcom BCM53xx managed switch driver.
> For C header files Documentation/process/license-rules.rst
> mandates C-like comments (opposed to C source files where
> C++ style should be used)
> 
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
