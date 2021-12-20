Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F70B47B263
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 18:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240298AbhLTRyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 12:54:00 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:38417 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240286AbhLTRyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 12:54:00 -0500
Received: by mail-wm1-f43.google.com with SMTP id 85-20020a1c0058000000b00345afe7e3c0so65558wma.3;
        Mon, 20 Dec 2021 09:53:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DKriEzh7Elx5Lb6bhAsX9FpEkdQAr11Q3q/0fePZh5Y=;
        b=tJ/H+gGfi09mKQwzVO2Maoj73E2T2FeCmn7XQV/x2QM7DEGaDJD+/FhiXq+UqvcNTS
         /hU0pd+7R5SC2wj9FP+FJfBiEdgol8k7iRu4TLPWvqJrl12VJM9XRJSpcGoNksVHH7/P
         WVaCtyRn4/43wg0nRoBeigtSeL6Ev3SNBrBh5foE1+a4NzQG03871FIHNvD298TvZofd
         I1U5hPqhHLwttC4HdQS8C4LDbkYPAW7nq5MeYIBOEGrJYKIO9+vv9B0Tz2nV502ZNyfO
         5qGBy5BohE5t6D7NGVHpgC58pXr6wVSMcairXMGpwgZJ5fpMh6a9pxpVZ/8BxishqVhp
         Vvjw==
X-Gm-Message-State: AOAM530ItPjMszVYMSdzJq5HZTBe4QIUHSGComyccdFZok5//A47Vmk9
        3NShD1B1ijD97ECCPYj4tG0=
X-Google-Smtp-Source: ABdhPJzOsPyR4Sb8GC+RVCDt5KiGwvXOYrBIBmxLvLXlhA/HVLtYdo5Xqp1NgECyZ3RGAJWPE8Ui7A==
X-Received: by 2002:a05:600c:600c:: with SMTP id az12mr81206wmb.86.1640022838674;
        Mon, 20 Dec 2021 09:53:58 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id bd19sm35117wmb.23.2021.12.20.09.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 09:53:58 -0800 (PST)
Date:   Mon, 20 Dec 2021 17:53:56 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Wei Liu <wei.liu@kernel.org>, David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>
Subject: Re: linux-next: manual merge of the hyperv tree with the net-next
 tree
Message-ID: <20211220175356.ozllm6jqid5zv7oe@liuwe-devbox-debian-v2>
References: <20211220185139.034d8e15@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220185139.034d8e15@canb.auug.org.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 06:51:39PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the hyperv tree got a conflict in:
> 
>   drivers/net/hyperv/netvsc.c
> 
> between commit:
> 
>   e9268a943998 ("hv_netvsc: Use bitmap_zalloc() when applicable")
> 
> from the net-next tree and commit:
> 
>   63cd06c67a2f ("net: netvsc: Add Isolation VM support for netvsc driver")
> 
> from the hyperv tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 

The fix looks correct to me. Thanks.

Wei.
