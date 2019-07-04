Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09EB35FE5C
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 00:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfGDWNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 18:13:16 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33023 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfGDWNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 18:13:15 -0400
Received: by mail-pl1-f193.google.com with SMTP id c14so3621565plo.0
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 15:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=o5jK/lFAS+ONU/+opdeRt9/P3YNw9XJ8quHkOsC4h10=;
        b=hY0qIf3z6Ni/z4so7IV/FjBUGr0c8/glvUMwOm2RZJTLLBaV+yZiRYCr6U63l4gu8H
         8QOUaKoopVyo+MopFT9hBHjXUceCZvbyiPee97v3fiMqbVkvcQIdpgV9r7VysqQK0NCE
         uUdb7DOJcVYZbbg5DPL2ERoD7wXaZbYtDShQ9QBHP1yiIBvG4yYxbLkiDFwUHdyrUP4Z
         HtU+1XuvefrysiLbdF7P8065+4Smk29cK1fyalRGE0m6/MlosYH9KoMWygg/b+88EM9X
         byYqfHK6+AgTZP5jx7ZJz6fQwKPZhfQkEwNsQ7N73K1NIcsPSL5OtO0h3UO41NF9BQRm
         PKxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=o5jK/lFAS+ONU/+opdeRt9/P3YNw9XJ8quHkOsC4h10=;
        b=i3uhl8k2Ej9Mbbzajw5QsaaqgZdtFWWgUa1JCzcXb8D3k6LmZwdZHGCP5uLbm3RCZ9
         Gsp2pLVl1yb5Yg6QV8IT6MtXg7nBz3VgstvDekLiO030DCEFU8GGcYEggIt7z4Cu0M5H
         3AX6AzBz0TCT+9zkh05SZGjGxMEFoBX6pS0mcOyLpKqPRBpJNeYsnzAKaCuWLt5belJO
         kGS7c5Yo56bSHxgfbfBoLwyc1HPWIgzl2Z7j3AP0PQublFRSwiixnuCy3kO5TGICbOry
         tLEj5DUpKKUeZSjmFUcstssi6jL0MhzI/sbYd6qO4UIstOqWik7R7dVdqmlVvfqH9CAS
         OpoQ==
X-Gm-Message-State: APjAAAVvW5pB/EsUf33MVvdKCvCb5m5mN6SaS22zt4Hk8FDlGta1e881
        OoZA0snV3nbYCZwPc6wlXw3hHSQN0I0=
X-Google-Smtp-Source: APXvYqxJjAHRCHXIsBiM2KCzNk8ZSgGLbZJho8RZHhx69atxriuGhqlS3aQPFTgXT0dBm6QEEKXWKw==
X-Received: by 2002:a17:902:654f:: with SMTP id d15mr475786pln.253.1562278395092;
        Thu, 04 Jul 2019 15:13:15 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e50::3])
        by smtp.gmail.com with ESMTPSA id p65sm6455400pfp.58.2019.07.04.15.13.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 15:13:14 -0700 (PDT)
Date:   Thu, 4 Jul 2019 15:13:11 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH net-next 0/9] net: hns3: some cleanups & bugfixes
Message-ID: <20190704151311.21025194@cakuba.netronome.com>
In-Reply-To: <1562249068-40176-1-git-send-email-tanhuazhong@huawei.com>
References: <1562249068-40176-1-git-send-email-tanhuazhong@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Jul 2019 22:04:19 +0800, Huazhong Tan wrote:
> This patch-set includes cleanups and bugfixes for
> the HNS3 ethernet controller driver.
> 
> [patch 1/9] fixes VF's broadcast promisc mode not enabled after
> initializing.
> 
> [patch 2/9] adds hints for fibre port not support flow control.
> 
> [patch 3/9] fixes a port capbility updating issue.
> 
> [patch 4/9 - 9/9] adds some cleanups for HNS3 driver.

For the unsigned "fixes" it seems it may have been easier to fix the
macroes than the users, but perhaps that's hard.  Series looks
unobjectionable :)
