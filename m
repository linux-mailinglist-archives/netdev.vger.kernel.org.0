Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 529EB55760
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732995AbfFYSt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:49:58 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52930 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731728AbfFYSt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 14:49:58 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so3884366wms.2;
        Tue, 25 Jun 2019 11:49:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NnYdk1L9tNxJOrD8BD7rIwHwgh6hKQRIs6DjAkp3gAE=;
        b=Dp/hi+AnZRvnxV252Y1zilwrKb8DnTlvzlzlZ7571aQHlUTEFf+blfsC/9YM10g2y8
         4Z/jbIJxtlAsHvLlbOabt2tQ71m7RCujDYIkCwG47Wpx+Z2tw7NYUqc1qr4bNvyknw87
         D2NHpGF/XVK09k4FuV5z13cayPp6FhgLBgvEUD91ytD4v2F96agf27+jiJ4/YfG8SDMf
         r1B2Ow67nBRyMgeGmvDR3wgdDdK8IwD8eGX9okmSiXeJyB91SP1VCMaTM00/FufBRZdw
         NFHsJeLz5Ofm5Gwjfj+RmYQgAZ0SeB81RwbVkQvaODXOCnQkT8KwPQhw7SxHRFg827ak
         eR4A==
X-Gm-Message-State: APjAAAX4u0J4O/wCdUqmYHiSLIOhbBn3kC8FkCRF03a2IMQCdgXoIVt5
        8VypmjweWZTHv36c3Hvmva8=
X-Google-Smtp-Source: APXvYqzegnboHeF+ubq+Re36XcyZoE34C8XzPBywiqM+pa+uCqEiiTKajy0OCgcU1IWo0AD7Iuihsw==
X-Received: by 2002:a1c:ef0c:: with SMTP id n12mr19655866wmh.132.1561488595719;
        Tue, 25 Jun 2019 11:49:55 -0700 (PDT)
Received: from kozik-lap ([194.230.155.151])
        by smtp.googlemail.com with ESMTPSA id o14sm12298185wrp.77.2019.06.25.11.49.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Jun 2019 11:49:54 -0700 (PDT)
Date:   Tue, 25 Jun 2019 20:49:51 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Phong Tran <tranmanphong@gmail.com>
Cc:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        alexander.sverdlin@gmail.com, allison@lohutok.net, andrew@lunn.ch,
        ast@kernel.org, bgolaszewski@baylibre.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, daniel@zonque.org, dmg@turingmachine.org,
        festevam@gmail.com, gerg@uclinux.org, gregkh@linuxfoundation.org,
        gregory.clement@bootlin.com, haojian.zhuang@gmail.com,
        hsweeten@visionengravers.com, illusionist.neo@gmail.com,
        info@metux.net, jason@lakedaemon.net, jolsa@redhat.com,
        kafai@fb.com, kernel@pengutronix.de, kgene@kernel.org,
        kstewart@linuxfoundation.org, linux-arm-kernel@lists.infradead.org,
        linux-imx@nxp.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux@armlinux.org.uk, liviu.dudau@arm.com, lkundrak@v3.sk,
        lorenzo.pieralisi@arm.com, mark.rutland@arm.com, mingo@redhat.com,
        namhyung@kernel.org, netdev@vger.kernel.org, nsekhar@ti.com,
        peterz@infradead.org, robert.jarzmik@free.fr,
        s.hauer@pengutronix.de, sebastian.hesselbarth@gmail.com,
        shawnguo@kernel.org, songliubraving@fb.com, sudeep.holla@arm.com,
        swinslow@gmail.com, tglx@linutronix.de, tony@atomide.com,
        will@kernel.org, yhs@fb.com
Subject: Re: [PATCH V3 04/15] ARM: exynos: cleanup cppcheck shifting error
Message-ID: <20190625184951.GA10025@kozik-lap>
References: <20190624135105.15579-1-tranmanphong@gmail.com>
 <20190625040356.27473-1-tranmanphong@gmail.com>
 <20190625040356.27473-5-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190625040356.27473-5-tranmanphong@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 11:03:45AM +0700, Phong Tran wrote:
> There is error from cppcheck tool
> "Shifting signed 32-bit value by 31 bits is undefined behaviour errors"
> change to use BIT() marco for improvement.
> 
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> ---
>  arch/arm/mach-exynos/suspend.c | 2 +-

Thanks, applied with slightly different commit message. As Peter
pointed, there is no error because of GCC.  Usually we expect a reply to
comments on LKML...  and also you could take his hints and use them to
improve the commit msg to properly describe what is the problem.

Best regards,
Krzysztof

