Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1522B11357A
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 20:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfLDTLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 14:11:17 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:44979 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbfLDTLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 14:11:17 -0500
Received: by mail-pj1-f65.google.com with SMTP id w5so184809pjh.11
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 11:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0mtPLUBDUZNxIDlqYatMH176esO/n0zoyo9pGhJpYDw=;
        b=vKYTjNIUUehfLsJKA0/zqoE4dSbPrMHwYu0aFjR6ve8MnySmoN1ml+BdX2+PDYBlZg
         PiCBMIFaUKe/KgfMLJjBNLXv4v7mP2ZhHH5PmsVf6VLohSLn9woFgpbM/+XE2wwfyyer
         IQEJ7gFctPvk/M2l/R+uVs2GNy3qi0ZVGkRTor2ickhFb+nCwbPxMtj1atkwdvt/1oMj
         mBBxddrJQPhNIwri/xVcyGp7b4l+sMSmO+pfvhtNVln53pZcpoelxHACMZQn45o1lNXl
         7tzIK1JFqv3ukQew8AnRb54OJEI+W4hDbD0csh6d3zwD1E4w+VTTtlECdJWvjsHCrypr
         /uWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0mtPLUBDUZNxIDlqYatMH176esO/n0zoyo9pGhJpYDw=;
        b=cbFcUm1vV3ez/oCxc2nwhRzZG81YRVS6kVhFt7uLt4ps0qiuW3bs204mXkhoI+JouO
         2d/v5wiA9l6PFi0s30+bkI5Nt/JK5NPV6swPjFxfPl0PGWAcsh9M4LwxzPXNm1mv4Zi6
         ALJCTJOC9qFnNYrCGBUVbNKrqfVWY1wCSxVm2lgHPSY0dMtcYrDTnIYu2x/WpewNVvYk
         7FP0xiPoUzAYAnHMi42bxdiDBRGzp4omQ/k7Jxe2PeWWUNA7uWOUu6AVOYZqbDMfvVS0
         GYUttZp4IE9rVpLylk5ktGID65XRbtNjTZ4RVbc9ArNOenLEPp/NGFrCMFxaa0x7ZsRk
         rj1w==
X-Gm-Message-State: APjAAAWLVTpYovfPQCJcoxbXI8kbvT+/i/iK5NDvEv/4gXKUTpDBNi6H
        zHUW8XavoyprKP3FlcXsJI8Ewg==
X-Google-Smtp-Source: APXvYqwmfhEmCrIz7XKZpH6t0I2b+FLAuUuQkK0NFjOpn4GfrIHZ+awjdLpKDkyig5BZq+cO6ioGyg==
X-Received: by 2002:a17:902:8682:: with SMTP id g2mr4977456plo.110.1575486676425;
        Wed, 04 Dec 2019 11:11:16 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id gc1sm7365845pjb.20.2019.12.04.11.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 11:11:15 -0800 (PST)
Date:   Wed, 4 Dec 2019 11:11:07 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Maciej Zenczykowski <maze@google.com>, netdev@vger.kernel.org,
        Hritik Vijay <hritikxx8@gmail.com>
Subject: Re: [PATCH iproute2] ss: fix end-of-line printing in misc/ss.c
Message-ID: <20191204111107.4a8d7115@hermes.lan>
In-Reply-To: <20191127052118.163594-1-brianvv@google.com>
References: <20191127052118.163594-1-brianvv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Nov 2019 21:21:18 -0800
Brian Vazquez <brianvv@google.com> wrote:

> Before commit 5883c6eba517, function field_is_last() was incorrectly
> reporting which column was the last because it was missing COL_PROC
> and by purely coincidence it was correctly printing the end-of-line and
> moving to the first column since the very last field was empty, and
> end-of-line was added for the last non-empty token since it was seen as
> the last field.
> 
> This commits correcrly prints the end-of-line for the last entrien in
> the ss command.
> 
> Tested:
> diff <(./ss.old -nltp) <(misc/ss -nltp)
> 38c38
> < LISTEN    0   128     [::1]:35417   [::]:*   users:(("foo",pid=65254,fd=116))
> \ No newline at end of file
> ---
> > LISTEN    0   128     [::1]:35417   [::]:*   users:(("foo",pid=65254,fd=116))  
> 
> Cc: Hritik Vijay <hritikxx8@gmail.com>
> Fixes: 5883c6eba517 ("ss: show header for --processes/-p")
> Signed-off-by: Brian Vazquez <brianvv@google.com>

This commit message is really hard to understand and causes warnings
in checkpatch. Also, blaming old code for doing the right thing
is not necessary. The changelog doesn't need to explain why.
The offending commit is already referenced by the fixes line.

Instead, I propose:


The previous change to ss to show header broke the printing of end-of-line
for the last entry.

Fixes: 5883c6eba517 ("ss: show header for --processes/-p")
Signed-off-by: Brian Vazquez <brianvv@google.com>
