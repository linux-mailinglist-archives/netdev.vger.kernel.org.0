Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC27A0E26
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 01:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfH1XTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 19:19:55 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36758 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfH1XTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 19:19:55 -0400
Received: by mail-ed1-f66.google.com with SMTP id g24so1873767edu.3
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 16:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=M+altPdUhJXeOTwHA/oSnIsndgm2Hmqt8quJCF+sxbc=;
        b=WzCFTqXfFkywaGuT8K4gAg5rA3m05yrJhWcL3uNHs7TQEHC64XLGOH3p0KU9yPvVMq
         kTpzlVn9Vs13K6FdRPi4V0bUOiMxvklXizkiAPwJZv+Wn/Zbcaq3oonB5XtdMeacvw8Y
         xEOkSJkBrtqXU3v+wdu5IGZJJe+6uOPxj7cv+pgZICiZQTud2rhyo8EUe6f+OctuWSjs
         zDWZJH4YImndwQUNzX3HD70AqZRR4x7twtRqwue/5+0wO6z8mTieCark4wFzI6je+67+
         f4hDKZzOwmTZPBlfFfBb9q5igpart7Yx9Asjucgx3SmDMpjcUwNYW74AVS3AgfngiNzF
         U50g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=M+altPdUhJXeOTwHA/oSnIsndgm2Hmqt8quJCF+sxbc=;
        b=HUDfNta/L5LEVMtNfjnIY7WwY8tfwnwejv/qnC/FVNlQhRluammYR3lsPEjfHLM1DO
         kn+a+OQDyoTycti1MBTPfMjrNhgLVM7zDShHPswAj5QhcPcIGhSpGQ6pzee+9GDm1oF/
         97aP/7GZbhx7UjLx5jjxlD00iIBzpfymJumamdpwO/1PTZr9s23iJ7R6DsCtRFPn5psb
         qGXgfkI7eKZfeZkoWjwWobJDzCoIZLxFRyACU7EMLj6C0P4OaKpZWmzv2nwEO+PyjLbK
         fPWAcHANrt+dvRVXH+y4rFsbzmE5zSuiSiLBX6iGXH2S6351G2sXPq668g3kTuwjw7PH
         jyKA==
X-Gm-Message-State: APjAAAUYnt3h2eoSfV7S3C5n1ii1ZdlEJc3tAnRK6KxG3gJarv05qnzR
        iLPtfbq3qMItdmJA2MpASNc9Hg==
X-Google-Smtp-Source: APXvYqxCHpyV+rsCxYbI2mAgGsXNwr5OfEHodnscKaidhDW/FKVB9MkvcPQOD611LZru5nvF1mWwZg==
X-Received: by 2002:a17:906:f742:: with SMTP id jp2mr5333218ejb.87.1567034393780;
        Wed, 28 Aug 2019 16:19:53 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d20sm107011ejb.75.2019.08.28.16.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 16:19:53 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:19:31 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 00/12] net: hns3: add some cleanups and
 optimizations
Message-ID: <20190828161931.1789697d@cakuba.netronome.com>
In-Reply-To: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
References: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Aug 2019 22:23:04 +0800, Huazhong Tan wrote:
> This patch-set includes cleanups, optimizations and bugfix for
> the HNS3 ethernet controller driver.

The phy loopback (patch 10) could probably benefit from an expert look
but in general LGTM.
