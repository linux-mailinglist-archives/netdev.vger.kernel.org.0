Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A53CB33D
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 04:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731493AbfJDCPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 22:15:00 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34786 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731470AbfJDCO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 22:14:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id b128so2948606pfa.1
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 19:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2FWEQ3r36Ej2/PfYXVJ+7YEmQn9qCDyo6po+XxMOozw=;
        b=lX58L9f3qTC7Eh8EXy+x6b4kKuv5NFAQ80j7gphlXQGX3jusVtqDBQ7QFw3HTCqbGk
         Pnh3MgRc18wlAha3CQM8jloBgapJheyNeJ4yPb6AHrdon++3cRRvk9+KV7GnDq6FvW3w
         5dRtIkSeOj9ZPX8CYWfgSuSQHoR2sF1yuhQL5NdHSy1KHUL7sXh9uc2xGritFUQOyXHe
         QuOJLDI/8TjmzlIb0Jk9oi65vTcZkd4H2yfJcCyoTPoTfvgC6M53n9qO3cGsxQNIN2NV
         yNnAinhMi3WWbq5FEAAbt1RsIP70oRuJAq7MLeLo4GEHKh2MSMYsfkz+oYLqY0MAw8qQ
         SnEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2FWEQ3r36Ej2/PfYXVJ+7YEmQn9qCDyo6po+XxMOozw=;
        b=o2T2WMh7d4WLtE0wlW/R1/4yZjrZMgmuf8JYcxjQmL1hWBArDu3fKGjXgv2vMQXdFt
         zSb6hoQos2YXNjvmwf2f1EfaifiiJhP+16qi5j4OPgiTk8X/zKFscEjy/KZ/6bpFcXOz
         /fwvSnKK3o9DzDvCUFCgyPEUmLC0aGeqspAixvrtv6luAHlvKVVRHkOSTPiKSl+HIfir
         HR15Sek3ReZPboEr5yuuNWv0emoN8KNda1K9MT5uOIGFQXp7A8ddCP3muLnYgaH2x9RG
         I+jdk9n1c7EMHuNpmjjG9P9fULOqsoQajY1pSGVBKsrI2MwFNRB6RyiFd9qLnG8nfyTx
         RHPQ==
X-Gm-Message-State: APjAAAXaG2rPxMssKWuZ5PZcW3jJKMS0VPjI0wp+Eg5pmsBiYaB2Jufg
        ZH5qAWf4ZtYCnsiaRomi8tlAwA==
X-Google-Smtp-Source: APXvYqwU2OtmK9Osayom3qGZRMBLKuM4FjIHpJfZoj5D9NvejkfM9VsfLRG+HcMa0fM0i03G8dYCOw==
X-Received: by 2002:aa7:870a:: with SMTP id b10mr14396843pfo.5.1570155298976;
        Thu, 03 Oct 2019 19:14:58 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([2601:646:8e00:e18::3])
        by smtp.gmail.com with ESMTPSA id a23sm3883189pgd.83.2019.10.03.19.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 19:14:58 -0700 (PDT)
Date:   Thu, 3 Oct 2019 19:14:55 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 0/2] mv88e6xxx: Allow config of ATU hash
 algorithm
Message-ID: <20191003191455.021156d2@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191004013523.28306-1-andrew@lunn.ch>
References: <20191004013523.28306-1-andrew@lunn.ch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Oct 2019 03:35:21 +0200, Andrew Lunn wrote:
> The Marvell switches allow the hash algorithm for MAC addresses in the
> address translation unit to be configured. Add support to the DSA core
> to allow DSA drivers to make use of devlink parameters, and allow the
> ATU hash to be get/set via such a parameter.
> 
> Andrew Lunn (2):
>   net: dsa: Add support for devlink device parameters
>   net: dsa: mv88e6xxx: Add devlink param for ATU hash algorithm.
> 
>  drivers/net/dsa/mv88e6xxx/chip.c        | 136 +++++++++++++++++++++++-
>  drivers/net/dsa/mv88e6xxx/chip.h        |   4 +
>  drivers/net/dsa/mv88e6xxx/global1.h     |   3 +
>  drivers/net/dsa/mv88e6xxx/global1_atu.c |  30 ++++++
>  include/net/dsa.h                       |  23 ++++
>  net/dsa/dsa.c                           |  48 +++++++++
>  net/dsa/dsa2.c                          |   7 +-
>  7 files changed, 249 insertions(+), 2 deletions(-)

We try to make sure devlink parameters are documented under
Documentation/networking/devlink-params-$drv. Could you add 
a simple doc for mv88e6xxx with a short description?
