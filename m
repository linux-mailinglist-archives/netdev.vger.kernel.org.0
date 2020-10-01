Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3147827F974
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 08:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbgJAG1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 02:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgJAG1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 02:27:22 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E1FC061755;
        Wed, 30 Sep 2020 23:27:22 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x22so3515117pfo.12;
        Wed, 30 Sep 2020 23:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=15hvua2G0rK9lRUp1nUHf2IUjiPsvNjx968oDCqbQi0=;
        b=itcL9Q5aR3OjgaRXO8UyphN147FCa2xOJbBQ9CPLqhFEfNwElAvsUJew9Q0Pfp/983
         5sSEnplHexRjKJP3TNgq/I6hN8cg0hVv5rB98mxQdla7hl4lZVOgz7fg+8iG1s2It+vI
         xbeEAF7p4PtoIH0bDMiS5ylfuKLMk96SNXREZD5c5M/u1m8Ov+2gIzwFVi2tu4WTEn/D
         8mXiz1pEIA6aLEneNCxHIvzQoFroySZwWjMwzxeSE+GK+uXAd+iT5ad8dza4b+t36+Wz
         4SjWqNz8crKru6fQJWmoQx+z2T7yNn+wC5Vs2hItQZHclAanR52XrsamrGmFc9iiOgGD
         AXFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=15hvua2G0rK9lRUp1nUHf2IUjiPsvNjx968oDCqbQi0=;
        b=gsHPrxj2VlyvlOlMhTIZDJs6ngJaXbvRJoEdMqzN8E9A+mX/r2VeuH8ZazWhsUHZ/p
         k3Y7BEWstcAc3mA0sDeIWieMiAj2an80PI94PJq6c984VUwsrXdMdqsGkd7/urZAndxK
         DlOoEII8Zuo56cfgpfIIgdQg9HkN6Mp2yrF+uyNcVmkoHjsSoGugC5Ygl3HfTGRtRDaE
         Nj/Mg13EMPxNyOmLSTaNU/BbFlLFSYKOLmp0jOsYw4uTHeAkk1srfkIXWVWYhPib2+Uh
         5MXNmqAn8/dZtAWeapTOveP6JrPSW80Xk5FHwLD2061ppcEOzPwoWnSAgkYVT0zgkGvn
         asAQ==
X-Gm-Message-State: AOAM533OXFxxOgYpeg+krF9mfgkNOGqrl5FsDt6zW8iMSTgKLGMnRAKO
        raEMIxSKNLrJjLgatmUUZVs=
X-Google-Smtp-Source: ABdhPJzsr8Xc17Sk8T1A1XzcySsHl4OUDkQ6M4xw6gwfugU315BF2hrAHmpHBUevBmNUGRInTwGHSg==
X-Received: by 2002:a63:5b60:: with SMTP id l32mr5094410pgm.134.1601533641967;
        Wed, 30 Sep 2020 23:27:21 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:76d9])
        by smtp.gmail.com with ESMTPSA id a3sm4809876pfl.213.2020.09.30.23.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 23:27:21 -0700 (PDT)
Date:   Wed, 30 Sep 2020 23:27:18 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        kpsingh@chromium.org
Subject: Re: [PATCH v5 bpf-next 2/2] selftests/bpf: add tests for
 BPF_F_PRESERVE_ELEMS
Message-ID: <20201001062718.uvtymy4l7jq6qkin@ast-mbp.dhcp.thefacebook.com>
References: <20200930224927.1936644-1-songliubraving@fb.com>
 <20200930224927.1936644-3-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930224927.1936644-3-songliubraving@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 03:49:27PM -0700, Song Liu wrote:
> +
> +SEC("raw_tp/task_rename")
> +int BPF_PROG(read_array_2)
> +{
> +	struct bpf_perf_event_value val;
> +	long ret;
> +
> +	ret = bpf_perf_event_read_value(&array_2, 0, &val, sizeof(val));
> +	return ret;
> +}

After removing printk there was a pointless 'ret' variable.
I've removed it while applying.
