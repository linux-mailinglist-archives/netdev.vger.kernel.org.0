Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE5030CF30
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 23:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbhBBWkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 17:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235385AbhBBWjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 17:39:53 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B4FC061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 14:39:12 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id e12so4128953pls.4
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 14:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=83UAwik4kmcCenPF9VzrRT9RHO630VoD8eabpk52Kpo=;
        b=nGV13jBp+l5/p59CnSfyTGRAMdjqVZBEAceAWvddYkNz8tG9sj1BllLW5q2X17q0b8
         cfxlInmhvZpAK/JbrDFd+O4mxoDkeRhfhqYcOBThMsyJjQ9PchT2yze0VC7uoNzzpzun
         LhWozpPIwf8n5u88ltPp+Sf2oQowE2brq4OXFyw3+DspWrQntg9A51JPml1mXk/b29gN
         5gwwFlxNBlbAqrePS23r4FUigLmZ93ZmbQr2y9Ym1MXneksmLawfmxxGj2oTHqyP7WkL
         ZIXwb+b280HBb7jUtT0Y+vI2RLIWGeCEI8w53V+UY0NPMazNYSr+verAMszx//HonDsR
         isNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=83UAwik4kmcCenPF9VzrRT9RHO630VoD8eabpk52Kpo=;
        b=IO07pSozL70U2fdDkACJ8No3+V9Lt+uq8wJxLDYJ9m1IuKWbRP0ZaNvWnPBp4F4zO8
         mGhyYt2S1wfWY8jb5Y7/UslyW9FM+GhrEPLt2Zler04XX+D2RaS4b+3E/txoBe7xLAY5
         9vTWyz4Ba+R4JLmtYlOA8mRKooKrBaQcTpDSQSM98Cpd7zQMGoqSyZ1cyvOuA9bkSvfm
         B30ko9KlzR/Efd9daM00rG3+vrWIsdohKXgCXRDN3+lfM0Eekp6joQufbnf3INVAaZvF
         WQFaAjZPXB8e2zy2jzfUbmYBThHueG7rC/GlEDGC06o6xkviu0C00mw6CVOvxIQ7FiP3
         KDYQ==
X-Gm-Message-State: AOAM531mmYDmIxkN7kbNrWvvpbIMpNO7KsIMZk3bRd3/eXNGWmO172CT
        mUsKsm7i1TAxlgA4sWsBvhH6sw==
X-Google-Smtp-Source: ABdhPJz+3czUYyg605Q/O7vf47hB37zykjTUz+LSelpltwIyEXlm1PLdIEFGVx5VCpd0xMFbcRoxSA==
X-Received: by 2002:a17:902:6b45:b029:e0:7a3:a8c with SMTP id g5-20020a1709026b45b02900e007a30a8cmr214355plt.1.1612305551940;
        Tue, 02 Feb 2021 14:39:11 -0800 (PST)
Received: from hermes.local (76-14-222-244.or.wavecable.com. [76.14.222.244])
        by smtp.gmail.com with ESMTPSA id fa12sm60239pjb.13.2021.02.02.14.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 14:39:11 -0800 (PST)
Date:   Tue, 2 Feb 2021 14:39:02 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alan Perry <alanp@snowmoose.com>
Cc:     leonro@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH] rdma.8: Add basic description for users unfamiliar with
 rdma
Message-ID: <20210202143902.47dca3d3@hermes.local>
In-Reply-To: <eb358848-49a8-1a8e-3919-c07b6aa3d21d@snowmoose.com>
References: <eb358848-49a8-1a8e-3919-c07b6aa3d21d@snowmoose.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Dec 2020 20:47:51 -0800
Alan Perry <alanp@snowmoose.com> wrote:

> Add a description section with basic info about the rdma command for 
> users unfamiliar with it.
> 
> Signed-off-by: Alan Perry <alanp@snowmoose.com>
> ---
>   man/man8/rdma.8 | 6 +++++-
>   1 file changed, 5 insertion(+), 1 deletion(-)
> 
> diff --git a/man/man8/rdma.8 b/man/man8/rdma.8
> index c9e5d50d..d68d0cf6 100644
> --- a/man/man8/rdma.8
> +++ b/man/man8/rdma.8
> @@ -1,4 +1,4 @@
> -.TH RDMA 8 "28 Mar 2017" "iproute2" "Linux"
> +.TH RDMA 8 "22 Dec 2020" "iproute2" "Linux"

Please leave the man page date alone, we don't update it anymore


>   .SH SYNOPSIS
> @@ -29,6 +29,10 @@ rdma \- RDMA tool
>   \fB\-j\fR[\fIson\fR] }
>   \fB\-p\fR[\fIretty\fR] }
> 
> +.SH DESCRIPTION
> +.B rdma
> +is a tool for querying and setting the configuration for RDMA, direct 
> memory access between the memory of two computers without use of the 
> operating system on either computer.
> +
>   .SH OPTIONS
> 
>   .TP

This version of the patch does not apply cleanly.
