Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E486D96802
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 19:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730593AbfHTRsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 13:48:45 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33040 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730404AbfHTRsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 13:48:45 -0400
Received: by mail-qk1-f194.google.com with SMTP id w18so5238287qki.0
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Txs8pbiiUnD89seXj92NZ1C3XJDqPD2UGuLKY8IPMFc=;
        b=0Ltr1//G9vd0nPfrA5jE6D7NlTNa45ay6WkHgCO3SsE9r8mtxOhvowGF12dnlV6zMh
         pnGAE9sya4jpc2H0o/0w5cpxzllguT+n4iPUX4U9hMlIZbyR7VxYkK4cE4JZCiDpjhR1
         axU62EYZfHkwYqhhEHUoiat3tnrSBTmeuNgmBVXNExDN6+M0xfHoKpdx8/crQUG0l0yy
         lfiZtHGiVxY12xyox95uW7gcsnklHJoMEt7/Sd9oMI3WIgd6ZhFNFRIHNBxhLGshSbnO
         WgiEUX8quOHmIe68//amkAhfiGF/3yqkT6CxL/LYx92enCID0ecXx2xHPBVfaJcJUlPQ
         UlVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Txs8pbiiUnD89seXj92NZ1C3XJDqPD2UGuLKY8IPMFc=;
        b=OjHc+2gYhKSkSdc65ExyJeQT3G5S8djRvNxWOXIgTQkF0gBdlaOwxhrx9ZikHJBTRL
         xDf3FcESPvRSIs+lWzAIpSUSbQQTtHBbE4qPVGtDka1d3o0+rO9QIaVGCPNVuGq5+eAS
         b6oEILH6z8TBIa4wJ//P9R1Btd4folVlWBdiuIBuJxERTUAnO2hGUIUdLSWwU2EtsyVm
         xGejTczbTgG08n6SkAa6xhrKxKTTnZMMzMeLMlgUz/CUXM7xh4w1L6erdUc+krcrO394
         27oqHKadmTOn0wzxXCoZEnGRPN5z7f8nTUW7nD/AXjYxxec8OVraPD8VBRqCp9EId86p
         GktQ==
X-Gm-Message-State: APjAAAWSKkrFWDp3C3I8LqwdgP4eIBc2+uvG0w53LBfFodNSCUT8B9r3
        C24VXz2GVYsbEcitKuDLThMQhw==
X-Google-Smtp-Source: APXvYqzCCCSEvOkdqThKLK6ees6Nv3F3TFwKOs7TGo8msawi5kZi9dyH1dNAftj9ZcCgWcnoC+7Jkw==
X-Received: by 2002:ae9:e914:: with SMTP id x20mr26126049qkf.57.1566323324654;
        Tue, 20 Aug 2019 10:48:44 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t5sm8892207qkt.93.2019.08.20.10.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 10:48:44 -0700 (PDT)
Date:   Tue, 20 Aug 2019 10:48:39 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <idosch@mellanox.com>, <jiri@mellanox.com>,
        <mcroce@redhat.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] netdevsim: Fix build error without
 CONFIG_INET
Message-ID: <20190820104839.511367fa@cakuba.netronome.com>
In-Reply-To: <20190820141446.71604-1-yuehaibing@huawei.com>
References: <20190819120825.74460-1-yuehaibing@huawei.com>
        <20190820141446.71604-1-yuehaibing@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 22:14:46 +0800, YueHaibing wrote:
> If CONFIG_INET is not set, building fails:
> 
> drivers/net/netdevsim/dev.o: In function `nsim_dev_trap_report_work':
> dev.c:(.text+0x67b): undefined reference to `ip_send_check'
> 
> Use ip_fast_csum instead of ip_send_check to avoid
> dependencies on CONFIG_INET.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: da58f90f11f5 ("netdevsim: Add devlink-trap support")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Thank you!

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
