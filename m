Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBEFE42920
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 16:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437593AbfFLO3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 10:29:16 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42017 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437144AbfFLO3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 10:29:16 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so9759675pff.9;
        Wed, 12 Jun 2019 07:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=i2lHhyHM9Am5ZKv4ZERVjIYftF/2/pl8FBg2eVYcKHk=;
        b=JLmcSe+wAzzpnKkgwvo/T1DJShHK+8zUW4xmw1zWJyEFwLFoR2TFoW6jDWzWVft820
         iHjVOXhjGBw7OEiJyAN66RZdasUZcnvtNYqA+30QJDCD17RJEU+VTAmcbnbFDvKaT8cY
         HpPXZJn9Emvrt9lGfQfpeG0f3Wr/e8u0blJVePSPGWQBbuX5BbV+xrl1tvOpuelSJBo4
         wzXHtk0BZ60Bkf0cDdY2oHZ0ZdLf0F6A7bO7lNdYHwU6rraAtlN8qqe9M+fRmu6t5XmK
         NkqpoSB7t5Ld9ElLjyfDnbMm48It11x2lQpFhvnccQIgrBUxaHc8SM8cfjCwihiUptik
         Na9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=i2lHhyHM9Am5ZKv4ZERVjIYftF/2/pl8FBg2eVYcKHk=;
        b=B5GITcWw77BwKDPPC287cexNQqlU60Lw7ySRQ4NS4OFL+IEGBXVc59OPNQcwgFJKy+
         H+X9dIPIo57ClSefgs5xZWgdtuZnpb8hsmAAXBvZ2gtWVhgnCapnDsteX28G/Af8LmBb
         +/sRmrq+HdCERyR1Or8NPjiMS6qrhOAIcKTBtPgi1zlHw25TGA4iH2lhiu8eCW+GbtnE
         URvADwYSKYUZbz37woyLU+8HVsTYvoGBJUb1t9R8E6EcW+O7qGKnVYFjGOP2euBxtviV
         uZFbXR7Tu6pPVBZRnFQy3zfwTxqSvbtd+nzt4KXYErnJRq3wIP+a+NJY0i1OZ+5Gz0hp
         Omnw==
X-Gm-Message-State: APjAAAVtdXmp7P/NXySI/Z44J74wzk7uDUdXX+Nb7c1/l4EwSZSHGldE
        i0PtcbRBUauSqMETqPviCZk=
X-Google-Smtp-Source: APXvYqzFwERzMYTKTt+QXS/AxrGBHTzZgwv6lP7jSb9Fw8afo+Zi0xwYKJxnHkZ21IaK/DjcWBIeCQ==
X-Received: by 2002:a17:90a:2e87:: with SMTP id r7mr33021706pjd.121.1560349755472;
        Wed, 12 Jun 2019 07:29:15 -0700 (PDT)
Received: from [172.26.107.103] ([2620:10d:c090:180::1:1d4d])
        by smtp.gmail.com with ESMTPSA id j14sm19519914pfe.10.2019.06.12.07.29.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 07:29:14 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, linux-kernel@vger.kernel.org,
        xdp-newbies@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next] bpf: Fix build error without CONFIG_INET
Date:   Wed, 12 Jun 2019 07:29:13 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <CFE96009-1D3A-4D99-8A96-86C281772396@gmail.com>
In-Reply-To: <20190612091847.23708-1-yuehaibing@huawei.com>
References: <20190612091847.23708-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12 Jun 2019, at 2:18, YueHaibing wrote:

> If CONFIG_INET is not set, building fails:
>
> kernel/bpf/verifier.o: In function `check_mem_access':
> verifier.c: undefined reference to `bpf_xdp_sock_is_valid_access'
> kernel/bpf/verifier.o: In function `convert_ctx_accesses':
> verifier.c: undefined reference to `bpf_xdp_sock_convert_ctx_access'
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: fada7fdc83c0 ("bpf: Allow bpf_map_lookup_elem() on an xskmap")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
