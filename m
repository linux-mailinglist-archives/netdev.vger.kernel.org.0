Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00374356CE
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 02:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhJUAQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 20:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhJUAQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 20:16:19 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D017C06161C;
        Wed, 20 Oct 2021 17:14:04 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id u6-20020a17090a3fc600b001a00250584aso1777579pjm.4;
        Wed, 20 Oct 2021 17:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=92XZC3M6KtezTSTjAquE9ET2T2cgiRgUK/rsYPAsOKs=;
        b=giEmQggiVBwWjApyjs+//wLJIthkVcgCZsRMBvwPtNHfk350CYKI+u/gtndsIBKUOo
         zf6dAL/7Rd8p0uvcVhVgrpoV1H9ip0/DdFX+p/65Wmk2vOQymJ7EHsKWXGw6mtt2k8fw
         OAbgtLodImVFX9tK3VJymlFHXIsb4HMNO88OBAc+B4MZ1GFF8tJasbIeRvIPG6hXS0lh
         Yqud8PAfqGfydqvNI/LkDDevUQV9ZqlF8bHmVfXNaGZhjb8ubF651jEjlgSaSK6vAq5B
         oS33i32yCcm9Rbop4Pwm94WtXQ2BHViCP5iXrIowiJkV/oYg3do+rVcbF5MccDhS8m51
         w6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=92XZC3M6KtezTSTjAquE9ET2T2cgiRgUK/rsYPAsOKs=;
        b=cPhOzCmr6r9iLlMcvWfLZN09yxI8zKwqjShI4+307kkVU2Ex95PY+fkHi6+9yPxTzp
         YCi1l4NszENN4gfn/H5TY5/ekhqMb4MUPGeovQTSyjfBHqXa/QHZF07PfNtr3RVsyq+I
         iFlIoJVkoatrfcNLZ6daJh7jVk7V69jrKtUxvgd1nI7sWLhvvsTJySFzsZj/bOBXQB57
         OIViJ2YRXI/Mr7Lqk7oinxcg06ExBHLTE6IjgtunVBnDDnrRCJJy7JCks7qU8WqnhtZa
         xDloIvIEPNeHYbX4CT/WiBLdrMcwqNtgBxNtXOMQhWBxkPw3Emf4OyvUQx5eLsaVGqAW
         S/Hw==
X-Gm-Message-State: AOAM531iOPJFOlE5X3yhzj0QTfpZpMJlHNhPb59++axw35W7OdPQ2ODV
        2yq4LuAsTI9NFSN0IZTj/6ZSOaHHBQs=
X-Google-Smtp-Source: ABdhPJyS6Hj+9vNcLmCD36MOwKHX6qQ7YVPMrYBm3BkSvjwcENJ37lRCka6U2ihKrTofTHnazLn9Sw==
X-Received: by 2002:a17:90a:8b89:: with SMTP id z9mr2431176pjn.89.1634775244107;
        Wed, 20 Oct 2021 17:14:04 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8c95])
        by smtp.gmail.com with ESMTPSA id e12sm3577119pfl.67.2021.10.20.17.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 17:14:03 -0700 (PDT)
Date:   Wed, 20 Oct 2021 17:14:01 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 0/2] Support RENAME_EXCHANGE on bpffs
Message-ID: <20211021001401.p65y2yx75d42splb@ast-mbp.dhcp.thefacebook.com>
References: <20211020082956.8359-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020082956.8359-1-lmb@cloudflare.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 09:29:54AM +0100, Lorenz Bauer wrote:
> Add support for renameat2(RENAME_EXCHANGE) on bpffs. This is useful
> for atomic upgrades of our sk_lookup control plane.
> 
> * Create a temporary directory on bpffs
> * Migrate maps and pin them into temporary directory
> * Load new sk_lookup BPF, attach it and pin the link into temp dir
> * renameat2(temp dir, state dir, RENAME_EXCHANGE)
> * rmdir temp dir
> 
> Due to the sk_lookup semantics this means we can never end up in a
> situation where an upgrade breaks the existing control plane.

That is a cool idea.
The selftest doesn't exercise all of this logic.
It's only testing that RENAME_EXCHANGE works on directories within bpffs.
Do we need a test for other types of paths?
