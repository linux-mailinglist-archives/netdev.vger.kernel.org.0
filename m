Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C063224AEB
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 13:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgGRLVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 07:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgGRLVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 07:21:24 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79823C0619D2;
        Sat, 18 Jul 2020 04:21:24 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f5so15485202ljj.10;
        Sat, 18 Jul 2020 04:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=X09d7UPuMWINbpOrjh3wyufNwVTJRpmt4Rb0SetFYPA=;
        b=ZOgceqUjsb1sQhFZ4MGVt4xfmrut/K3zHJjVI0Fxmh9okFHe2JvOQlfooUzb5JoL+a
         5VTsWEDIXr+RXm0gd5TJrV2D3GySCovXXcj4rc5yDg1gvRr4tpsHWnmuUHK2Eh+l5+qr
         fJNyftuUpLHgDFMeyBfLsURkA/GgALtF0PvfESNRWaEWRfyoeIgooeGJPSGjdDeJL1Z5
         9sv/BLOvqdZKhz9FuuNZbH1iiUQdz68utExGdgztcr59d+ZFMakqUXO0isWi2bNjlp8H
         82BIEUVYluu7xRIrMkA4vUU+/TzDnHnNvP+BuqLPTjql5xfSZXHrfgawuTMO4WpLrsIO
         GDKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=X09d7UPuMWINbpOrjh3wyufNwVTJRpmt4Rb0SetFYPA=;
        b=eQr1HO5xyzv5XfXwPbrjA/cB0v1Ilt/qaOOuJvKwyD/CPbz73l/Fcu6hq7+Lgn/BXF
         KH18PdofASCRfLLC4QJqtuEWgK5QvkyUPWufLx9niJmNgstElEMP+AyIYaMA3Bxy2peg
         xd+GxpaPxiEBV9XzvhwwDI7meRPNPPPEmGK7UYVGKJEaVRIJlpJdHcXTik/qHzgniv6r
         /9k4qbFWQf4jjtnynucp1Do6fd3U002apGHjSNN3sZReVO501nt84YEhUWDBZTOoMdPp
         DrJN/DwoIlhrqaXcf433FlVo89AhZ//lTJf4wNOjHQDxxqXTOb8HM2qNzIyVge54dXnA
         ocrw==
X-Gm-Message-State: AOAM531Ep//zk1MTd/C1GFnT/c+r5T7M1n7mz33HdmJOVaVK5SXqjmy1
        PB6ZVBCreHINVvlQvoRPy9EKBQH3
X-Google-Smtp-Source: ABdhPJx+W/SgaDvYiOspanRHv2qyhpJVZy7vMo0WzSmB3b/k3m+i++ryMK+JYhgGbAWwBezgPh29XQ==
X-Received: by 2002:a2e:81d5:: with SMTP id s21mr6679587ljg.362.1595071282943;
        Sat, 18 Jul 2020 04:21:22 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id x13sm2148002ljj.92.2020.07.18.04.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 04:21:22 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, linux-doc@vger.kernel.org,
        Eugene Syromiatnikov <esyr@redhat.com>
Subject: Re: [PATCH net-next 0/3] Document more PTP timestamping known quirks
References: <20200717161027.1408240-1-olteanv@gmail.com>
Date:   Sat, 18 Jul 2020 14:21:21 +0300
In-Reply-To: <20200717161027.1408240-1-olteanv@gmail.com> (Vladimir Oltean's
        message of "Fri, 17 Jul 2020 19:10:24 +0300")
Message-ID: <878sfh132m.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> I've tried to collect and summarize the conclusions of these discussions:
> https://patchwork.ozlabs.org/project/netdev/patch/20200711120842.2631-1-sorganov@gmail.com/
> https://patchwork.ozlabs.org/project/netdev/patch/20200710113611.3398-5-kurt@linutronix.de/
> which were a bit surprising to me. Make sure they are present in the
> documentation.

By the way, there is another somewhat related issue that needs to be
addressed. I believe kernel needs to free user space from this trick
found even in kernel sources themselves:

tools/testing/selftests/ptp/testptp.c:87:

static clockid_t get_clockid(int fd)
{
#define CLOCKFD 3
        return (((unsigned int) ~fd) << 3) | CLOCKFD;
}

Once upon a time there was a patch for that, but I don't think it
addressed the issue correctly, here is more background:

https://lore.kernel.org/lkml/87y2pxvsbr.fsf@osv.gnss.ru/

Thanks,
-- Sergey
