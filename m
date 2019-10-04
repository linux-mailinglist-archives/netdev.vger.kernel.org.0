Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78CEFCBD8F
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 16:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389219AbfJDOkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 10:40:51 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39502 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389119AbfJDOku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 10:40:50 -0400
Received: by mail-wr1-f65.google.com with SMTP id r3so7554797wrj.6
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 07:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=bVYB3iaBKu6hqEMy7IiK8W2xGcuTKRwNP5QMtv3wYFQ=;
        b=tJopKaUBlABenT4ylmGSDy+I7t0hIGjesgfpNtSX0xCQ4wdftG4tbz0fWZ1ZW9yfVn
         qnor0XLIlQJe3nszHCPcuh5nQF/kpXBia4CYizl15KL/+djYfrXQCqNMoFvQkeb6xbw8
         9iDF6a1qCpXZ3KfIzHm/41NSPoHZpt5eZ3UhrCrZ9FFeb3HlSVchIWIPy0R6jWISxeIq
         xgc7P2GJSJ+8CZTFUhR1PjY5KCBKUXCNlGxEt2BIY8/Zf41oIgMW961ZPQJPVlqK1QeW
         OwRJz1zdzDOjxWO6iC7SjAGCOC3mJ59hlp8jnqGV0O0w1TbvbSZIGWMp6u3cQ7sMyrih
         0/Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=bVYB3iaBKu6hqEMy7IiK8W2xGcuTKRwNP5QMtv3wYFQ=;
        b=OPk/5hlZtzhT75M6dNbOnSRmTQXvcWaxtlr+mr/buRgE4CoZBGVh6eNQjTwGKko9nM
         83eSej/mu58/fvLkTzjG4Q1WGEjIkdL3nG5eSoGRQT5vbKidGyidx0fUHGe26p3gTul8
         LjvV/q59Im8eoUTrAJFsItPEHI0Lw5YKYbISBfSNNfMp446vou7mtgyYXIYqWV1U2t8x
         vGo8gkYHhco5xhxP8Et2Vp7DUkemRRYwr4alWQ6yh6W2pTZnv3W3tLtB4FvFO/5JfIeA
         UYRVevEzQGYYobf3TxDHyjlUhLUjNAkAnOnUirYMJGvgBNia/N6eWKNNP4UYGRrRItL7
         OWUQ==
X-Gm-Message-State: APjAAAWGKMHw+xkC9k88caJuoCIV2Zbezpmn6rdTtlbyTqyLJG/W8/xb
        Rk2mIiRHi3NorQm1NxjwtKu/Mw==
X-Google-Smtp-Source: APXvYqy9slbJZlb7IwHee5m1NXEKgsFSSD+s3ZkGv7TbF7FJLKEyUO3VrYbQ2U8x31bmys0HDopIvg==
X-Received: by 2002:adf:97cb:: with SMTP id t11mr5495100wrb.312.1570200049218;
        Fri, 04 Oct 2019 07:40:49 -0700 (PDT)
Received: from dell ([2.27.167.122])
        by smtp.gmail.com with ESMTPSA id r2sm5638979wrm.3.2019.10.04.07.40.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 04 Oct 2019 07:40:48 -0700 (PDT)
Date:   Fri, 4 Oct 2019 15:40:46 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     kbuild test robot <lkp@intel.com>
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>, kbuild-all@01.org,
        Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v6 3/4] mfd: ioc3: Add driver for SGI IOC3 chip
Message-ID: <20191004144046.GP18429@dell>
References: <20190923114636.6748-4-tbogendoerfer@suse.de>
 <201909232145.eyOJqt2k%lkp@intel.com>
 <20191004143718.GM18429@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191004143718.GM18429@dell>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >    drivers//mfd/ioc3.c: In function 'ioc3_eth_setup':
> > >> drivers//mfd/ioc3.c:281:54: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 4 has type 'resource_size_t {aka unsigned int}' [-Wformat=]
> >        sizeof(ioc3_w1_platform_data.dev_id), "ioc3-%012llx",
> >                                                    ~~~~~~^
> >                                                    %012x
> >        ipd->pdev->resource->start);
> >        ~~~~~~~~~~~~~~~~~~~~~~~~~~                         
> 
> I assume you plan on fixing this Thomas?

Ah, I see the new set - ignore this.

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
