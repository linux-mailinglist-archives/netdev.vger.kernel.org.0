Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E182B2519
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 21:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgKMUGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 15:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgKMUGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 15:06:03 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0259BC0613D1;
        Fri, 13 Nov 2020 12:06:03 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id i18so10070636ots.0;
        Fri, 13 Nov 2020 12:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Vd7RsNkdsEwNU5VSYm5O4l0IAdZsWi++HuSlWvu8GwI=;
        b=sEicq2CF30tBeD0C70jucFv3ygCnyscYaakPd6oMfUUYm4+T3oKOlZsNw80ofYosB+
         O2ibevfFTIZWHAGzyiAV2KwuTuqyCsM4rxdi0W9VvtOG9VK+elWprFIScPCCgsF5JNBL
         62TxgrBs4qS6IjQDjDL+0tasXz8K84XMGwdndERdouxbClcAwFbp9fRW8vHlJipk8M8s
         UWDYkKiDZU0zYlvtZlr83rV/ud3RjKCC2FGNA0ue5xXIYAzQ7gf+lBgOOJi5sWGvArMI
         zmt3YNFUObFeIsHK7zV0CCNfLnOC2J+u6lxVoTHyTDPkr6aGcimlc0Zm+MugajnnvsX3
         GcRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Vd7RsNkdsEwNU5VSYm5O4l0IAdZsWi++HuSlWvu8GwI=;
        b=K1T9burb0YQLQEmdWRDczpI7Xtj5c0i2MmJwgJGtV+NgGb0Fe1O/5oWUiv4lLJrHho
         AgM7rxjRcHrrYXdIbSuuFmKoWWmHAh6iW4gbLczXYeBbVTS7K1RHfJx8t6BjMmi1xQ/j
         Cl+EwDEBVKMwwdGsIS3JNgbwDaHbfGVK2HmASUdafLHB9DALPqQk0GpamWGZhYUSNVFg
         pExW6l2LFwBFaTgJ/o/LRUoVujECB51JiYhrgi3IXS7oZcOfOKAvWz7lvkj8Dy0J4rMJ
         RNTPMXEz9b6cDVm97a2e2fgTKrkBxSO1ko0tUdDY2V9FOorlKBQ69WWvEV30I6I0Q+kd
         Me+g==
X-Gm-Message-State: AOAM531gsjrPeJmy8Or3u+X5dz4YolAKofBNBfQgdVcvk9uaFhxIejcT
        YzHpX6q6KoVGmpeCHjmJQzY=
X-Google-Smtp-Source: ABdhPJyzs3zLnGNmYJlAI1J0mnynflt7XshlafEc60dMnPmATVyobwebj+4ebnsfCALsIUa6BqWbsg==
X-Received: by 2002:a9d:2646:: with SMTP id a64mr2857485otb.334.1605297962341;
        Fri, 13 Nov 2020 12:06:02 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 62sm2169008otj.37.2020.11.13.12.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 12:06:01 -0800 (PST)
Date:   Fri, 13 Nov 2020 12:05:55 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org, john.fastabend@gmail.com
Message-ID: <5faee72334db9_d5832085@john-XPS-13-9370.notmuch>
In-Reply-To: <08dd249c9522c001313f520796faa777c4089e1c.1605267335.git.lorenzo@kernel.org>
References: <cover.1605267335.git.lorenzo@kernel.org>
 <08dd249c9522c001313f520796faa777c4089e1c.1605267335.git.lorenzo@kernel.org>
Subject: RE: [PATCH v6 net-nex 2/5] net: page_pool: add bulk support for
 ptr_ring
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Introduce the capability to batch page_pool ptr_ring refill since it is
> usually run inside the driver NAPI tx completion loop.
> 
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/page_pool.h | 26 +++++++++++++++
>  net/core/page_pool.c    | 70 +++++++++++++++++++++++++++++++++++------
>  net/core/xdp.c          |  9 ++----
>  3 files changed, 88 insertions(+), 17 deletions(-)
> 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 81d7773f96cd..b5b195305346 100644

Acked-by: John Fastabend <john.fastabend@gmail.com>
