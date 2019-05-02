Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A351189D
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 14:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfEBMAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 08:00:17 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34815 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfEBMAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 08:00:16 -0400
Received: by mail-wr1-f65.google.com with SMTP id e9so2992495wrc.1;
        Thu, 02 May 2019 05:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SM8TsU3OFAbO4NmdaDg8HRLgXAeSxN+PITGV00fL/z8=;
        b=RRe6eGaE2NobACjwADYIVifI7MLCrf179q/tvPwaPyETmkPdktv2tLUKfAdFhG8wju
         ZdEBVQHzBK5n5BoDfz9jMZc7+n/yW3+B8crJINVwUZZpSF8jRcEL+lSgnQEOM3p3Rxvt
         zLiy+PE/wLaLj7v6Kmpv0kJg3SgrHmv698Wz91H1+hlJQ2Tn8zSEm42/dI2RyxUVVWyp
         atSsAbd+TFTQAA+kolYOgm1IbswbtxfzMKTTl2jb40Pc19soZQmG9Lq9dCTGy+qZCE1q
         JIjW1AMtLteXKFpZ7K+oxbmSf0svRvFvDnGKc7BzA4l7Qv1WFKpUXvR8veMKd5kgf4p0
         +yVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SM8TsU3OFAbO4NmdaDg8HRLgXAeSxN+PITGV00fL/z8=;
        b=KqaAmlimuCd5QCLVrIr9fcwA0ZWVGndFB6T9/gjlGiaJQ6YqeImgLzZDsXPXCd3S5N
         AGmXAdo29jh+/wW9yCMEBDf+mfNa7Dh5WHfmDuDuAPF7OYDCJokgKHQ4mTs5gxYwTrtv
         OCfHD6XbVKksrO9HLOOSMOyLHt/kI+ZmVVL3E4O/4oQyh/W/xUVJ0c9upQV9pd8qRImD
         UwFhvDb8OLOM9b1fDdiamyT3R8+GvM30u4ek4CyWOTYdTFqcuw1KMcxG+uNJf2+08r6i
         LvzbyfsHf6myJfqBLusTKv4zG7BqnpevPLPpiOU9cqz9aRnHMegHalZkov2wLGYwT5Ko
         LUnQ==
X-Gm-Message-State: APjAAAXbkw9+XiGRr9pJMbPSsMdGDCgDp7436iF+4YuqFgzYrMSofxeL
        eanFUe7jN9hNLTr0Dr76zCM=
X-Google-Smtp-Source: APXvYqzn+hnz0noXV+/bfazc6gltFsCxIEfAJCDaQjenHHOvuLVabnZScGwgi7BuP3+NSYMljUc0fw==
X-Received: by 2002:a5d:40cd:: with SMTP id b13mr2579466wrq.103.1556798414862;
        Thu, 02 May 2019 05:00:14 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id t126sm752981wma.1.2019.05.02.05.00.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 05:00:14 -0700 (PDT)
Date:   Thu, 2 May 2019 14:00:12 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Kalyani Akula <kalyani.akula@xilinx.com>
Cc:     herbert@gondor.apana.org.au, kstewart@linuxfoundation.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        pombredanne@nexb.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        saratcha@xilinx.com, Kalyani Akula <kalyania@xilinx.com>
Subject: Re: [RFC PATCH V3 0/4] Add Xilinx's ZynqMP SHA3 driver support
Message-ID: <20190502120012.GA19008@Red>
References: <1556793282-17346-1-git-send-email-kalyani.akula@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556793282-17346-1-git-send-email-kalyani.akula@xilinx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 02, 2019 at 04:04:38PM +0530, Kalyani Akula wrote:
> This patch set adds support for
> - dt-binding docs for Xilinx ZynqMP SHA3 driver
> - Adds communication layer support for sha_hash in zynqmp.c
> - Adds Xilinx ZynqMP driver for SHA3 Algorithm
> - Adds device tree node for ZynqMP SHA3 driver
> 
> V3 Changes :
> - Removed zynqmp_sha_import and export APIs.The reason as follows
> The user space code does an accept on an already accepted FD
> when we create AF_ALG socket and call accept on it,
> it calls af_alg_accept and not hash_accept.
> import and export APIs are called from hash_accept.
> The flow is as below
> accept--> af_alg_accept-->hash_accept_parent-->hash_accept_parent_nokey
> for hash salg_type.
> - Resolved comments from 
>         https://patchwork.kernel.org/patch/10753719/
> 


Your driver still doesnt handle the case where two hash are done in parallel.

Furthermore, you miss the export/import functions.

Regards
