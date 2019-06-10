Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90DFD3BFA7
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 01:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390501AbfFJW7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:59:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36989 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390340AbfFJW7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 18:59:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id v14so10828283wrr.4
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 15:59:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NaJwvaYNh7njuHoZQECaDJ97+f9+iFyeQ+zOolol2Qw=;
        b=SegPwG4SdRfJnYjEMJGs3lQ1qBhvMrArj4dTF8h/iBosGhQJ+Kcd1dXeAl1N7A/xEo
         YwUxpxhv1pVCHkoUL6O/dwHErA7wg+zEtOxsinwelJyRrvwpINxU46CvrXtqyIvjK+cs
         Zwl7TRN5IUdf6SsavcghOIL/pfoC0/aNYDxuuLdUc6vxvebkq/xZRP+22MN0RDQu+n8Q
         pxPllWHX31vYPW6lvgGo0o/Mlk40TjTPWLUGEv0zu+AgV8FVcPHT2CQbqO6BnrbV1S4N
         CNs/MK3ZbLBB+yq8b2ZVwmId4SyTf8D49x1vaxODdlCWBU5IBh5hnU5ItYb6OtNCtnnm
         UXEw==
X-Gm-Message-State: APjAAAV91GtkZQ7WPcfpleIXJvCLSKJybdFREi3mIi2MjCUfyqHD37Xw
        RrhCB+3lNTTH6PbqslqWPenQfw==
X-Google-Smtp-Source: APXvYqwegzqf1FACH2p2+SrFjWh/iN0B4eoaM5RtACePtKL38YSrDWj8Q6MV9uHKRJ3Py2svJuo8Eg==
X-Received: by 2002:adf:c654:: with SMTP id u20mr21811860wrg.271.1560207571162;
        Mon, 10 Jun 2019 15:59:31 -0700 (PDT)
Received: from linux.home (2a01cb058382ea004233e954b48ed30d.ipv6.abo.wanadoo.fr. [2a01:cb05:8382:ea00:4233:e954:b48e:d30d])
        by smtp.gmail.com with ESMTPSA id z5sm598741wma.36.2019.06.10.15.59.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 15:59:30 -0700 (PDT)
Date:   Tue, 11 Jun 2019 00:59:28 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] Don't assume linear buffers in error handlers
 for VXLAN and GENEVE
Message-ID: <20190610225926.GE19832@linux.home>
References: <cover.1560205281.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1560205281.git.sbrivio@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 12:27:04AM +0200, Stefano Brivio wrote:
> Guillaume noticed the same issue fixed by commit 26fc181e6cac ("fou, fou6:
> do not assume linear skbs") for fou and fou6 is also present in VXLAN and
> GENEVE error handlers: we can't assume linear buffers there, we need to
> use pskb_may_pull() instead.
> 
Acked-by: Guillaume Nault <gnault@redhat.com>
