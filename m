Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2277204564
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 02:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731895AbgFWAb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 20:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731754AbgFWAbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 20:31:24 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DE3C061573;
        Mon, 22 Jun 2020 17:31:23 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id g12so8345947pll.10;
        Mon, 22 Jun 2020 17:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fVew+g13SgHpevB7NYz5oIWPb+gVvjb6LhTgV6ElRAI=;
        b=DoNtra67tk5DOU2BlpqpJR6vR9ir2YE9mvacp9/vQuslbOCepuZgBoisibBM5qzkSj
         hsk5D8HOv0Mp90t2QW1GKEao7IJAbxx7w/clR+QglxZTWkNSt/S6lar4r9LxtRD7Mz2B
         JvKnozhLIDBZm6NTcpKKvcE1Mqq5xo8L2+Fhmet18LKbMeWJPduJDqOBDKa7MbnW1wUv
         UAUZW2bjuuLkAzwXiCnLxlNjxNuA6TfJvWB7ETqyeRSSZRYDofUcIJXT4PGN8lAyzvUt
         7MDyePJZ/MY4//da+o5l5opjBWdBYuRGR/o1Sp6ujmLy1WHZg5rvKmGGRSdOR5tVMSt4
         RETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fVew+g13SgHpevB7NYz5oIWPb+gVvjb6LhTgV6ElRAI=;
        b=p+jy86W4e572MUi9DBN5c5XTljgjjYw4x8cZDgvSco8uhJ+W7SooPnw44BX2vrrqhH
         INl9ks3LT5bStDs0f4kio8IW0NPP5Hr48O3JZeeZklrRp08iIEjGa+4OrnguaBP2sxgR
         1hUNms0QV3XV84/nVGd8NHQiltA40MuTCG/abaJV20H7OOLlEjkfYprRyWydALo32H08
         tiQ8nOofP2Od+021Nd6I5BthjAwYHpDt5iXaqdBa4MJedA/c4WL4h/JqzZV/6Kx6EDBr
         sZ218R1qWObz3qf/PSXeNHACGm2cOiY1TUGonCyI+GSEVUcBwO4SNicxKUknPQLCBysH
         AR6g==
X-Gm-Message-State: AOAM533YTyWD6JNafImBhzaWxHUtrpJQ6v3EmVdzZ/ttxBOEAmozAId9
        KYvDqBesuI/BbfE/1yaI8lk=
X-Google-Smtp-Source: ABdhPJzl/3fJJ+vvNS8ahGFjVdZOuaZYmbjO4U1wZSB4BeVTIQ4fBfBOTPFSVt/I9HWty8+i2K15wA==
X-Received: by 2002:a17:902:7881:: with SMTP id q1mr4482279pll.159.1592872282626;
        Mon, 22 Jun 2020 17:31:22 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:739c])
        by smtp.gmail.com with ESMTPSA id m10sm584860pjs.27.2020.06.22.17.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 17:31:21 -0700 (PDT)
Date:   Mon, 22 Jun 2020 17:31:19 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, john.fastabend@gmail.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 3/3] selftests/bpf: add variable-length data
 concat pattern less than test
Message-ID: <20200623003119.onlwey7ko5z6heyq@ast-mbp.dhcp.thefacebook.com>
References: <20200623000905.3076979-1-andriin@fb.com>
 <20200623000905.3076979-3-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623000905.3076979-3-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 05:09:04PM -0700, Andrii Nakryiko wrote:
> Extend original variable-length tests with a case to catch a common
> existing pattern of testing for < 0 for errors. Note because
> verifier also tracks upper bounds and we know it can not be greater
> than MAX_LEN here we can skip upper bound check.
> 
> In ALU64 enabled compilation converting from long->int return types
> in probe helpers results in extra instruction pattern, <<= 32, s >>= 32.
> The trade-off is the non-ALU64 case works. If you really care about
> every extra insn (XDP case?) then you probably should be using original
> int type.
> 
> In addition adding a sext insn to bpf might help the verifier in the
> general case to avoid these types of tricks.
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Please keep John's 'Author:' on the patch.
git commit --author= --amend
or keep 'From:' when you applied to your local git.
Also add your SOB after John's.
Even if you didn't change the patch at all.
Same thing if you've reworked the patch.
