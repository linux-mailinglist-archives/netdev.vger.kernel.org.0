Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C4521DAD2
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 17:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbgGMPwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 11:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729593AbgGMPwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 11:52:32 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85FDC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 08:52:31 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id m9so6191388pfh.0
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 08:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/a97FX2i+smaX1zg9smcPwxixXoLtj5Sj977bTM6kyU=;
        b=HdTBVv/PfXcSEiIH+2rUDpFXQNuqJirVY3YNGCCOozKvw0e/MjUi6iOdPKJnV1pWoH
         J46ZVU6eS9iEFV8FNGqLqADdyYbV+DpkpeeTvFz8BjJ+G8907DAccQaYfDAk/jw1Ezp8
         tFyU0Xgna30ZIK8Q2x2Dzas4DStFxbFq00hlQfSM2wtgrhM5mBSbYAckqzEYasjCwrH6
         9TUc0NMYbJxr+lV82qyxKL4R/1zZm/Vq2IoqKxxFU3XvwiFHryJMTju6W/5ir9wuZTNc
         uFAGiPgh+LUikawS2H4obhmVHRnt7vEwYsum0Fnv0/GpPK2Xqbo4bN9wBnQF8lHSo30Z
         cL0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/a97FX2i+smaX1zg9smcPwxixXoLtj5Sj977bTM6kyU=;
        b=E3k3pXyjcxQfoQrCOI+LoLRvgZzNYbQQpvcPaJszWR2ep3t6v1uZu7PsIvXO2ce17E
         EEiRNZ5f5PhQMKC4cisfQ752U9dzujWknLMMog4wa1xk3oCFUPYEk+uAZ/Rn5ybEyDsM
         i4+j+KTiHbvvxV8Tw+DpirAr2Ga89BBluGbqW5Q9H5LYlIqoxQF9v1S9MhuH5EjuMzu5
         hk5pjzdfd989zL6NLcy6D4kfOqe5TIwppMot3lRHvnvwF2F3D/lwsVKvbipUbDhy/ffu
         nIYHiJUu4RjRD0/fejlCOis+w5imUkIH4wCeCd24KhMXZpr/KAhZlHblxp7zQGaltzGz
         6sVg==
X-Gm-Message-State: AOAM533a+WHUJxOQKUCsO1xU0whrJIFVvOy90IZIOORXZjckpu/ltQr3
        lgJtA6WN1VToAZ0VhWgYcZEPqg==
X-Google-Smtp-Source: ABdhPJyvMNSuGYpCS+uBOR24rp2o5yWFxmVXrX03tk89l/rna99sO/WSiIDkyoEVrH/zyB/OQTw6LA==
X-Received: by 2002:a62:de81:: with SMTP id h123mr439428pfg.217.1594655551343;
        Mon, 13 Jul 2020 08:52:31 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id e195sm14236707pfh.218.2020.07.13.08.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 08:52:31 -0700 (PDT)
Date:   Mon, 13 Jul 2020 08:52:23 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2,v2 0/2] ip xfrm: policy: support policies with
 IF_ID in get/delete/deleteall
Message-ID: <20200713085223.6df4cc76@hermes.lan>
In-Reply-To: <20200709062948.1762006-1-eyal.birger@gmail.com>
References: <20200709062948.1762006-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Jul 2020 09:29:46 +0300
Eyal Birger <eyal.birger@gmail.com> wrote:

> Allow getting/deleting policies which contain an xfrm interface ID.
> 
> First patch fixes the man page with regards to the original addition
> of IF-ID in ip xfrm operations.
> 
> ---
> 
> v1 -> v2: update man page
> 
> Eyal Birger (2):
>   ip xfrm: update man page on setting/printing XFRMA_IF_ID in
>     states/policies
>   ip xfrm: policy: support policies with IF_ID in get/delete/deleteall
> 
>  ip/xfrm_policy.c   | 17 ++++++++++++++++-
>  man/man8/ip-xfrm.8 | 10 ++++++++++
>  2 files changed, 26 insertions(+), 1 deletion(-)
> 

Applied, thanks
