Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9782CE558
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 02:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgLDBpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 20:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLDBpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 20:45:31 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E096AC061A4F;
        Thu,  3 Dec 2020 17:44:50 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id n10so2538735pgv.8;
        Thu, 03 Dec 2020 17:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fgqxl/AN+N0hATAo9NGBlF2InSMDPXebP+vkDCFING0=;
        b=Q3TCentnDg7Bm6ArwnCLB+sJjpXldF/DXeNh2jpVu4NfEvgdIBVz60HYskqChYO9T6
         +6/KRiHtUL72mVlDLzOGgDLP0sx99p2Q+YNZbcsD8sHIdZ/nAy9D4R0khJIlEeNLTMIA
         rkvUtLd8R/ALGayvXlS74fHqc+sbe6sGzpZjz5DefzLPGiUglA7rWZTg7VcNQRH3oxYv
         zB9/ADJZMD4gNLm49JAtTVcyyvzeILwiXGi7LLFH0KAsDYEf8OHTMMc7V33SB3GH04QG
         6N280w6gbWtpLHRKxysyqkpmNxqv439ahujKTEiWSgA+L5vqTDs2xGrkk7W6biO323iW
         DemQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fgqxl/AN+N0hATAo9NGBlF2InSMDPXebP+vkDCFING0=;
        b=J2zsnyG7wJT7dgZdNwBNgLYnVBjXu3F5pbLZY7TdFnro54IKUEfGVBFhSwA7rSDucT
         DNfPsxVkzDHRz3z+X78pj5Lp3VnYG4Dh+CC5iSgBDerEYTLD4o0Vft4ZkN2L5n+TobFe
         DtRbA1ZIFXt7y4QJuRstCcmmhszODNdw89BXbo6s742yh+MuH9Tu39p3sIwcYshjRDvD
         DjCpG6RU7FtrV1mm5sg5O38QcCS53OcrJDBJRiq/lBiw3VMZLfOZS9PhQK5N4yr0pl5I
         vflyITo3i2nWv2m9KkiEsBct7CAfbf4pPaLxEItnV5EHgbXDejo4C2sZQb4D+WIsg401
         6KuA==
X-Gm-Message-State: AOAM5338hypsTjTk7rUjHjcJUX4/BMrTNI3eue3HRVZOddoSbxJ6JPLs
        wbq3eO5+rmBQG3URy9hX53ryYVzI+Yw=
X-Google-Smtp-Source: ABdhPJyqxReCzUn1deW4VqQFrX+iFEsJ3Y1rkoVJbGZlx861yeI+S0Chq+b02DBkH5H8MJ7iTmxNag==
X-Received: by 2002:aa7:8494:0:b029:198:aa:bd6d with SMTP id u20-20020aa784940000b029019800aabd6dmr1633795pfn.13.1607046290484;
        Thu, 03 Dec 2020 17:44:50 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:2ca])
        by smtp.gmail.com with ESMTPSA id x12sm2111170pgf.13.2020.12.03.17.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 17:44:49 -0800 (PST)
Date:   Thu, 3 Dec 2020 17:44:47 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Prankur gupta <prankgup@fb.com>
Cc:     bpf@vger.kernel.org, kernel-team@fb.com, netdev@vger.kernel.org
Subject: Re: [PATCH v4 bpf-next 0/2] Add support to set window_clamp from bpf
 setsockops
Message-ID: <20201204014447.i43tm6qrquygnx26@ast-mbp>
References: <20201202213152.435886-1-prankgup@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202213152.435886-1-prankgup@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 01:31:50PM -0800, Prankur gupta wrote:
> This patch contains support to set tcp window_field field from bpf setsockops.
> 
> v2: Used TCP_WINDOW_CLAMP setsockopt logic for bpf_setsockopt (review comment addressed)
> 
> v3: Created a common function for duplicated code (review comment addressed)
> 
> v4: Removing logic to pass struct sock and struct tcp_sock together (review comment addressed)

Applied, Thanks
