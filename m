Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA74F95059
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 23:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbfHSV7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 17:59:09 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40682 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728352AbfHSV7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 17:59:08 -0400
Received: by mail-qt1-f196.google.com with SMTP id e8so3685960qtp.7
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 14:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=gBtqq3IvZRaHl6JRTtznEC05xSuSPrBYeH5TY2P8Yio=;
        b=yCRR5Rgw6+zRfd7svu3uNd8G6A4hgfojo5FgGNk10rxwqf5SSa1m4ayDw/hC0I9taB
         qM8SPfVeeu6dh+paFD+01nvSo2/iR1jHsPo8RdkM6LCMyGgvmzAu3Kgr/lI/5/nHBZPF
         QT9cEsqwsG4tW8f6Qk1gwcaD5JtrxmIRFf4t9473UZfaKJMedVF6AMf+2XpwjJz9IGLF
         hdNx9es/jawsOhDWBAnHc7LHTKVOki+asV6nmPCbE8iY0SGdzQmSdJSDJYEdvjfNV/CA
         YGHRR0VkRrTjkPGfKYOuhvB+NXlxk340v56yh+toXcWYwyW8mqbzCofo5hT4Wf9qAKQa
         ANdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=gBtqq3IvZRaHl6JRTtznEC05xSuSPrBYeH5TY2P8Yio=;
        b=WCV3MRbfpRgaoHNTfZlU06vTVGPXGC09LhNvC+KyvUdoPsP4VU9omCqIzSbpPIqcGa
         tzqawThMIAXrc2wDuBAYylDDsjQCtdFyp5WcKsWCjqPzWoNyZ1EO4IpYCF+O80tmM+FF
         fzJJkMgfeJL/m8GwFWyPG3oWkVPCjwgVsMiFH06deP3fw4DxdCRASrX/0cN42s3HZajE
         /XeBjmNr1KhJnnTzE3QnMedSE7mgrukXK5WfHjAdU+7qcvBqM8S9qk/89s4lJ0vpmkUA
         XB436YQdoJ81NgdBHBYXNwei5qsh6dwAxKZ4L/NgaUuDGU/AkNs4wQXq7s74wfUBVlmH
         Rukw==
X-Gm-Message-State: APjAAAUJyrwEJ0+6eYGSck/sUltS49Is1CI1oInOSVkw+jVnfOtYAIOI
        fyKkqSJJPuj1SgytbHiUvJKIdQ==
X-Google-Smtp-Source: APXvYqyNKIluiCsN354Gu3GxN+1pbjKw0W00/Qfd72e5TBmdB3ArFfNk2netEmooUZQZYTzu5z/eAQ==
X-Received: by 2002:aed:3325:: with SMTP id u34mr22547902qtd.324.1566251947962;
        Mon, 19 Aug 2019 14:59:07 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y204sm8317292qka.54.2019.08.19.14.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 14:59:07 -0700 (PDT)
Date:   Mon, 19 Aug 2019 14:59:00 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <idosch@mellanox.com>, <jiri@mellanox.com>,
        <mcroce@redhat.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] netdevsim: Fix build error without CONFIG_INET
Message-ID: <20190819145900.5d9cc1f3@cakuba.netronome.com>
In-Reply-To: <20190819120825.74460-1-yuehaibing@huawei.com>
References: <20190819120825.74460-1-yuehaibing@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Aug 2019 20:08:25 +0800, YueHaibing wrote:
> If CONFIG_INET is not set, building fails:
> 
> drivers/net/netdevsim/dev.o: In function `nsim_dev_trap_report_work':
> dev.c:(.text+0x67b): undefined reference to `ip_send_check'
> 
> Add CONFIG_INET Kconfig dependency to fix this.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: da58f90f11f5 ("netdevsim: Add devlink-trap support")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Hmm.. I'd rather the test module did not have hard dependencies on
marginally important config options. We have done a pretty good job
so far limiting the requirements though separating the code out at
compilation object level. The more tests depend on netdevsim and the
more bots we have running tests against randconfig - the more important
this is.

This missing reference here is for calculating a checksum over a
constant header.. could we perhaps just hard code the checksum?
