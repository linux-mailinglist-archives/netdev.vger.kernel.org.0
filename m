Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58BC16737B
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 18:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfGLQmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 12:42:19 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43696 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfGLQmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 12:42:19 -0400
Received: by mail-qt1-f196.google.com with SMTP id w17so8713504qto.10
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 09:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=lXKLRvMf/gAJtt1BUfhJ1ny49vER+Ck37U+mWbyytDE=;
        b=DAG/1VJ3xO9X0aClDvatlnrG+WNxsVe1qUUDW1oU0YX1o+PpwRRc//f0psOQeVpfk0
         KtrRnNj9OBF2DAipE7cRBHpAvcZGutZBDoYIMsF9OJ78mU9Ne1NGOT2js2EnqLBC/yfq
         azF9dPNJODaJ8rQCjW+vYpx/CzZtWjs6b9g4rYriQ4YPFTWcsEMZiBaHvnEQ9rY9sadB
         QzAVpF4rLViFIqXycDZJ3H7lio9lDtdE9if+S8Oboj/88/+MGeGcc+SAEoeOVmjJPvft
         U+cvhPkZfSr8gDkuA6fjddmMd+5Iuf0S6Y620iik0krl4pvBAhlHxSTk1uv9Xt6DctN3
         UmJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=lXKLRvMf/gAJtt1BUfhJ1ny49vER+Ck37U+mWbyytDE=;
        b=Gd8JPw8GjqvwwP7p7ujcHfZPaVQhENM1rzYflT3xpRYlpzVSQgsgPIIg0TbRQ8PXbC
         rsL0de6xemocsRPlibO3N5EBn3TaTnyzZiSW4T+/IhKRimiC7TlLfPlRIHwsYGRaEWPZ
         HorIDoId/sFBdSLVMy6y4PrtRKc/M2B6MtFL5hlGOoVCWQcjvIbOYb2KSzA6bcgHed1z
         uWyUpk7aRig4gEvSVKh6vuJx6FlmRKLTdBga+xyJjicqFIAucG/i+QHrv41RwgIMY4sh
         fHSlb06y+3eisr3Ay8x6qM67Hvf2BitTV58Fl++wsDRbZ+RP+ryHLeyNgQg4csNbkkRL
         UauQ==
X-Gm-Message-State: APjAAAUITul75+HzLTBp9o2lR3WDUfiEYjDbtbEJpggoHoEsmmL7YOp1
        u9B3g516aRryYiq2H2OHOdo=
X-Google-Smtp-Source: APXvYqyZVvrNqn+T4nHUxdguQGTTOnW5L53bEfAamsESiMpRf10kbroWybEycG0uaLn7WXVw6AE2SQ==
X-Received: by 2002:a0c:d604:: with SMTP id c4mr7462927qvj.27.1562949738537;
        Fri, 12 Jul 2019 09:42:18 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id b23sm5633718qte.19.2019.07.12.09.42.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Jul 2019 09:42:17 -0700 (PDT)
Date:   Fri, 12 Jul 2019 12:42:16 -0400
Message-ID: <20190712124216.GB13622@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] net: dsa: qca8k: replace legacy gpio include
In-Reply-To: <20190712153336.5018-1-chunkeey@gmail.com>
References: <20190712153336.5018-1-chunkeey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Jul 2019 17:33:36 +0200, Christian Lamparter <chunkeey@gmail.com> wrote:
> This patch replaces the legacy bulk gpio.h include
> with the proper gpio/consumer.h variant. This was
> caught by the kbuild test robot that was running
> into an error because of this.
> 
> For more information why linux/gpio.h is bad can be found in:
> commit 56a46b6144e7 ("gpio: Clarify that <linux/gpio.h> is legacy")
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Link: https://www.spinics.net/lists/netdev/msg584447.html
> Fixes: a653f2f538f9 ("net: dsa: qca8k: introduce reset via gpio feature")
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
