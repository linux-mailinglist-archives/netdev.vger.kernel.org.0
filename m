Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A68B228BE0
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 22:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388115AbfEWUuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 16:50:44 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36333 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388099AbfEWUuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 16:50:44 -0400
Received: by mail-qt1-f194.google.com with SMTP id a17so8475116qth.3
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 13:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=lpL8ojvIEr8ukXNiESGhIsoffjmCk8KMLj43HM6HLz4=;
        b=yAnTwWEY+lJbUe4bXzjKztu/N/SseCiSiDleV9D5fsAwcexR7uRCdKRb5mmTyGXIN7
         oY/LTRkZ6tahByC8Y1TawOSGk99ulRptsJaXNHO1b6FD4VR/rQOlaHsN2zMdgipw1PO5
         AEgnZyHRBUBIcoJqx8MvRK87ZRO87AMH8RuSYqPKmA3LfIhoMYlPhLqyu8i5DCRUAYgL
         KssZ+O5MRhMvwysRRtlg05Kurzos9hK8IPgfhJGxWULwzewBmEqyWFHAxlalel6UlqVJ
         gpZcy87xNdUq9u/7c6CjLacAi9iVLSI314vSLtx8e+zGkra7Ge30Pd9ZJSWlARtEKK0z
         r5Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lpL8ojvIEr8ukXNiESGhIsoffjmCk8KMLj43HM6HLz4=;
        b=ZDUQSrp6fHEZWgX5jwnOccrhL0OAatnCswP+OcpO8/EBkEmdNtqvrGmJWktmOGy5Ca
         ullfnKzi2Kl0EMChArmhWou5z/5+BlRcLBMzRlHCecRkzWKT5THSp9ATSPXtAlFETKyK
         pA+yW9Mg+CBcupTMaT57DRSDmSLxX2dV7VtU2LABP9A4lgnTisXzfyKv4p5yv0svR337
         EmA8sP1hZjkAXsbDxOoDonkT/RCi02ZMBNU7X5v+xQUDSGK39vD5JF8KM08+yXAl+8jg
         /8DX4TAMP/TELcqCyQQm6Pxup2lhQIsQAQDk799tTabKX2SZMZJyoyqfqJkddys+crJb
         GNVg==
X-Gm-Message-State: APjAAAUOazusGpC/ctU3LkziuDQpV5PKMvi0r7gCb+QjGstsScnaTdsZ
        I44UYjcs2wlW/ngQozSLT77nng==
X-Google-Smtp-Source: APXvYqxu711RUPGjVuBzybSILVyhLSTuj76groh0SMI7Zd0AVrXpSkWwTCl0GyOl/a22l6J+VtIjWg==
X-Received: by 2002:ac8:3509:: with SMTP id y9mr82785474qtb.336.1558644643185;
        Thu, 23 May 2019 13:50:43 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v22sm273781qtj.29.2019.05.23.13.50.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 23 May 2019 13:50:43 -0700 (PDT)
Date:   Thu, 23 May 2019 13:50:38 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 10/12] bpftool: add C output format option
 to btf dump subcommand
Message-ID: <20190523135038.2f11f792@cakuba.netronome.com>
In-Reply-To: <20190523204222.3998365-11-andriin@fb.com>
References: <20190523204222.3998365-1-andriin@fb.com>
        <20190523204222.3998365-11-andriin@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 13:42:20 -0700, Andrii Nakryiko wrote:
> Utilize new libbpf's btf_dump API to emit BTF as a C definitions.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Thanks!
