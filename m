Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF06B9ECE
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 18:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407729AbfIUQBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 12:01:06 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45742 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407692AbfIUQBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 12:01:06 -0400
Received: by mail-qt1-f194.google.com with SMTP id c21so12175031qtj.12;
        Sat, 21 Sep 2019 09:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=rKlUR1ULS3eSI85SU+gwQXiiDvPQ4a7KCA04Sk5G8Cs=;
        b=tQvfOUKaMflFJa7M+gJhbbp9EJn97iKzH+JhEQiz/qARwna5obmVTZfG/hMJGXLzCX
         jsP0FQUjgvJ06XQ5C3l3OdibHAeKZzrkElEsvN+yXvtli9dKZn5qoGVlb/dufDfddSeJ
         lgjmWkhKZA1nnQXXr5iEIbWPUNeZ0+baotpUZR0FP/HD1Dtapo8ZCwFbc/em797QQ2x5
         NZak/r1wM60/EwdkKccUxKWa2vYRM3SKQ6cSeAg6o9piPDBQ4jUmtSjrEEGEnMvuqGPd
         IL49pb/TQSAGrPaqkvbKIpzkDnbQ1h7XGtipSNYvYCxJ4kebtGQMeaTTjb8ZJfVlv7uE
         230w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=rKlUR1ULS3eSI85SU+gwQXiiDvPQ4a7KCA04Sk5G8Cs=;
        b=oyU6iMyt7mVSCZO5AAg9ba/lC5cZ9OVokw3FBvLEnp1g+Hu4Jg6bEVGRQQTquKqWf+
         6Ej/NwC0DhUmVEcG+TMHg2sc/cOqOtEjgfO/3/qfP+vIJND4pDafo+2BzMJTOcFRKJ/K
         lIGS/VLg+YxZ/H/+BRUUjX99sMXoIbI+U0Pmws+Y3fGRO2Ga4AoGN8H+ex6lP44P2JWr
         EfKund7aSQSsD9TbnYvl41xT/JttTu/rq/ffEXR5DkeXvUxEt9yXJQT0ugYwy4V9RM1L
         NhPbYzHWbbr4UPBrgMgSKRo4nB7gZFNWHDIwbE1paQcnQ9BpNoP1MN9SQQKRnfIxWwv3
         1PPQ==
X-Gm-Message-State: APjAAAX+CsK/RxdOured8h0ksu4QHky4SLy9eL0jAtHCBni+Irx0FsKA
        f6PufL+FmFZI8bH7XBQD9G4=
X-Google-Smtp-Source: APXvYqwYB1W1PKvXthUp8oFz8rhbgJo0DUr12r/LqLMFth9iw0bV/MhdsmnA7I4SKrJx8I3bTKeaZA==
X-Received: by 2002:ac8:5414:: with SMTP id b20mr8595257qtq.85.1569081665465;
        Sat, 21 Sep 2019 09:01:05 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id h9sm2742515qke.12.2019.09.21.09.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2019 09:01:04 -0700 (PDT)
Date:   Sat, 21 Sep 2019 12:01:03 -0400
Message-ID: <20190921120103.GB253404@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Nishad Kamdar <nishadkamdar@gmail.com>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?UTF-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: Use the correct style for SPDX License
 Identifier
In-Reply-To: <20190921134522.GA3575@nishad>
References: <20190921134522.GA3575@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Sep 2019 19:15:25 +0530, Nishad Kamdar <nishadkamdar@gmail.com> wrote:
> This patch corrects the SPDX License Identifier style
> in header file for Distributed Switch Architecture drivers.
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
