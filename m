Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D142FD98BA
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 19:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388743AbfJPRtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 13:49:09 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45273 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727400AbfJPRtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 13:49:09 -0400
Received: by mail-pl1-f196.google.com with SMTP id u12so11592509pls.12
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 10:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=1CYanzBAmlB3jQRtweRaRTG+rbpP/n7wTvScjVK1e/c=;
        b=vV9fBMVvWsO1gbT4kIxyv3aaSiKBwDc5Gwc83M5Nq5FWeYRavCF/CQJjTS1hAuZItM
         HMLD+r1XOa3lmN8TI9NIQJX/ZIdTc0sbvdry+PNBS1GM7hYm4EjmGpjdZTQLY03WS4+I
         LR74k+7efgX/xBkMxbgFQlk0XkqW1RAA+n7Gg+OIKm6XjwTXGsdymspr40ZdKET2Hz2E
         HNrX5KZsxgABEcBh4c+k3ZEgOMN+W23uh8vGUxcwGsGh8MIQAhl5gYoQLCCPqOad/EL8
         jFvlG9DSb9HxkkDVbE+gTVDbcRHUe8kKmio75nqmx3qVLCKv0xpIJuYgCWKGeKe5rZ+O
         kLsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=1CYanzBAmlB3jQRtweRaRTG+rbpP/n7wTvScjVK1e/c=;
        b=M+EdalaOFYwNNz5c0/Wr+NqeTzUiM8dxr1wibWxytTJfrsRfKW1AV3t4/YON+ygdI9
         4eDp4qCE09A1Uy+NSf2HfI637xzu+CUrocYnLgrgydLA6uc4h3uJcyJTe8R7MIvdUrSc
         LPbK0k4lGSObFCbGrok45Icv31tWCPv3xAPhWv0xnlEAwEBFJO5kzoWOdTNgJJgA4VEk
         5bI+KmCRD5B4FyA6hzXpt7SwZTJ2Y0TZJZjF0MGiGsNJF/WtkOxfBk+Qmj4pfrryeYYF
         uqiAA7KBkCZ3t6B0uTB3PYganLqYblQXAgK5FVKnQehgsmIwig2H6LDrHxtte1nZ2JVU
         OIaA==
X-Gm-Message-State: APjAAAX7e6da7gjCMRBtn1wTilFBxfZ6aM27lPU5sGJhBZXJehzNBddn
        XtkgY70ApA9boD47ES3Mj7t+TdCPq1M=
X-Google-Smtp-Source: APXvYqxddniC2KCF5w95AdZWbKYpc1M5yC6QhNRySlc/OkyxnaJ00PMtVud+qsCkv0FAbkYQlJkSOQ==
X-Received: by 2002:a17:902:246:: with SMTP id 64mr529341plc.257.1571246387191;
        Wed, 16 Oct 2019 10:19:47 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id z12sm25424325pfj.41.2019.10.16.10.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 10:19:47 -0700 (PDT)
Date:   Wed, 16 Oct 2019 10:19:43 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH net-next 00/12] net: hns3: add some bugfixes and
 optimizations
Message-ID: <20191016101943.415d73cf@cakuba.netronome.com>
In-Reply-To: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
References: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 15:16:59 +0800, Huazhong Tan wrote:
> This patch-set includes some bugfixes and code optimizations
> for the HNS3 ethernet controller driver.

The code LGTM, mostly, but it certainly seems like patches 2, 3 and 4
should be a separate series targeting the net tree :(
