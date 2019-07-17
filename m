Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C41446C089
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 19:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfGQRlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 13:41:47 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45519 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfGQRlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 13:41:47 -0400
Received: by mail-pg1-f193.google.com with SMTP id o13so11486619pgp.12
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 10:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=xLvvdUhcOYPcutaZWia1N8eHoh7vQtJooWBeUbPqVEQ=;
        b=omBRCOtrH81WieNmHaiNeucFz4fc8tGUKuebPpAFTpfma87I2OLS8M4A08w9pazEhb
         uXziPo5yVWj1yUy/Bpma8kWv1S31+YdpOAQ+2geZjdZ1ehtD6hp2uSp3BS9KY5f4S1Sl
         kY1QU7I43SDVyfcoMbBj+XFN6izy5IBX0AXL/TI9C2vhxPc1Vuvm4cugIWl8DrV3jcr0
         Z0EPiFKKdDWJGThbjKAbFD3AgTznufiKxnz73KyuIQj6spxIkEooM/rTyFpWatrt+HTY
         5MUzSI1YMPcXkwEkjxENUICzAnN96DC/qFWi5BHlShua/AFiEI2o7wpBBt/+Rqnzxhb/
         kEhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=xLvvdUhcOYPcutaZWia1N8eHoh7vQtJooWBeUbPqVEQ=;
        b=f5FPZ10DqlIMLRSQj2/EWYTAP+ZgenHgtxcM4rAaY+k30xseVcc38inMF9PO8Nx9E3
         KdxHmRKY46dyKuqz3PPni5y1n1Mhwr6Db3Mm01xmWF4nUrVxJiniOdKVftC1LvU7+GJ3
         20hvmWUrFGGwIYVX4Z6U8NLKUeehgpz7GqaUP+pGbZg/ik1A17hplLNFX1DrsZGs1VaQ
         dLCPCOoQ8c+nf+n3htuxfo+Jwy1vVIQSgE7IHzMdMQ9v0GibMhf++sDJK3nF5qy1icBv
         xJj1jp7BR4u9HrqgHJpNcmZ2kmzE7Uje1xpu0Rr7E9STggejTMK86GV77009QqVKwrWN
         a6eQ==
X-Gm-Message-State: APjAAAUkh28ABZQLyLjxf2B/DQNT3uAU5hNQxLawA1u8OAblURfAjhk5
        ucDrZNRNkO6J+xz/GVm0GlrPqA==
X-Google-Smtp-Source: APXvYqyNGlZgFX4u80QjjB864ff373cfyz+UY/DMgocKHy4dz2M1C6AE1D/ZSZ1pgMWUgGehChtbYg==
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr10963054pjb.115.1563385306726;
        Wed, 17 Jul 2019 10:41:46 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o32sm22781780pje.9.2019.07.17.10.41.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 10:41:46 -0700 (PDT)
Date:   Wed, 17 Jul 2019 10:41:41 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH net-next 00/12] mlx5 TLS TX HW offload support
Message-ID: <20190717104141.37333cc9@cakuba.netronome.com>
In-Reply-To: <d5d5324e-b62a-ed90-603f-b30c7eea67ea@mellanox.com>
References: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
        <20190705.162947.1737460613201841097.davem@davemloft.net>
        <d5d5324e-b62a-ed90-603f-b30c7eea67ea@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 7 Jul 2019 06:44:27 +0000, Tariq Toukan wrote:
> On 7/6/2019 2:29 AM, David Miller wrote:
> > From: Tariq Toukan <tariqt@mellanox.com>
> > Date: Fri,  5 Jul 2019 18:30:10 +0300
> >   
> >> This series from Eran and me, adds TLS TX HW offload support to
> >> the mlx5 driver.  
> > 
> > Series applied, please deal with any further feedback you get from
> > Jakub et al.
> 
> I will followup with patches addressing Jakub's feedback.

Ping.
