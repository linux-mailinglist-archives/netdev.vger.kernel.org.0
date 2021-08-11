Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F303E8888
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 05:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbhHKDCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 23:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbhHKDCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 23:02:01 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6587C06179B
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 20:00:52 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id a20so846288plm.0
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 20:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IoIC4KNLgYmTZO3SuHkymRDaDjdYaBngSUC39CQQ+5M=;
        b=PxlnbG9c7RGaPUhK3wnJTo9suxfoejr1R7mg0/mIR1xfqvtj05sK4r8BJGAKBgyqkn
         nLltyS563K6vc1oJl4tlulVRIKvKccpxZrrBeVQ/3fkjOpAtICPW3z034/u1c1OlDdXy
         y/sPLf1bl7Lq5ZG2r+ru6ZbCSdVb+9Fn9TnVEyyei7rqN+9Ngfn40WQWT/WkkwS/olQu
         q0NQL1cw9zoZ553d7NM2k5ZaTz6ZW0kO4XHUKNJwr+QTv/hGjlnVCE0633+tDvyg0seE
         4u/kfuth9wwE6NRb/5eecUYOqq4dr2Pdf7m5h50aCKKqEabzewna3IzMjjKR6AVGswfq
         eJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IoIC4KNLgYmTZO3SuHkymRDaDjdYaBngSUC39CQQ+5M=;
        b=E/kjPN7FaJDS43QRnO3SV8GZn9hqgERjlQnB+UTrymGCg4/WzHAQvKQdGPa2XhEsJT
         c1bPsFv3AQMG/vEGUoyhxrfpZHsTD4DOQ49Oht20zf5s+qiJXfzSEP2WdHGoNa3McBpD
         E6y7EE7ndm44GJC7QlaUqGeB+UoEaSFosv3GK7N6jaqk9T5ZzaQ5k5ppqIMP5A37zgJd
         rBc7qIZYVOTOKKsWdDwvzKKKs16QKXDnjf2WOzfr1CLxTiIhNP3RHSZhMUdC2Ui32zWD
         R8K63c7a+KxHHGX6tFaJaM0txuzV/ZFZngBfvqks0hm7okb8efUcf/7YyI44RNVCR70I
         g33g==
X-Gm-Message-State: AOAM530+mVvEwz4mwldriHoLw7CiC6Mcg8iDtuz+7hdsWxowN9V+pQNy
        /FtIATBlpXha9MyII6PTGHfzxw==
X-Google-Smtp-Source: ABdhPJzs3RqFG3YBgR5tVJ2FWF2yk4vYSOrxKFtdhqp0BlKi7y0nqm/+kZBWA+WWfZu3ra8y74wjqQ==
X-Received: by 2002:a17:902:8507:b029:12b:533e:5e9d with SMTP id bj7-20020a1709028507b029012b533e5e9dmr27961755plb.53.1628650852286;
        Tue, 10 Aug 2021 20:00:52 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id fs21sm4656216pjb.42.2021.08.10.20.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 20:00:51 -0700 (PDT)
Date:   Tue, 10 Aug 2021 20:00:48 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, haliu@redhat.com
Subject: Re: [PATCH iproute2] lib: bpf_glue: remove useless assignment
Message-ID: <20210810200048.27099697@hermes.local>
In-Reply-To: <25ea92f064e11ba30ae696b176df9d6b0aaaa66a.1628352013.git.aclaudi@redhat.com>
References: <25ea92f064e11ba30ae696b176df9d6b0aaaa66a.1628352013.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  7 Aug 2021 18:58:02 +0200
Andrea Claudi <aclaudi@redhat.com> wrote:

> -	while ((s = fgets(buf, sizeof(buf), fp)) != NULL) {
> +	while (fgets(buf, sizeof(buf), fp) != NULL) {
>  		if ((s = strstr(buf, "libbpf.so.")) != NULL) {

Ok. but it would be good to get rid of the unnecessary assignment in conditional as well.
