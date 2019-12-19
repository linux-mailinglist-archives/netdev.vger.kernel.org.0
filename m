Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEDE125946
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 02:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfLSBf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 20:35:29 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45050 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLSBf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 20:35:29 -0500
Received: by mail-pg1-f193.google.com with SMTP id x7so2217903pgl.11;
        Wed, 18 Dec 2019 17:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=V9CV9BaQt0xTPSvPPcYe5ZuTRlahoiIA49Vi1uWbMvM=;
        b=cbzK8Dck0ndGX8bRvwxkVj8Uo0hrI5ltXJXALS/8XqaLCZtedvC0mY7abFutYaz5hC
         CQgoY0ZMYIZ3vcQYM1tuoZg2TVlN2WalGj1G7jgyCOJkBJA4i9wjw2pmFKSvT2dUpolS
         NnWYCrq9tqlswbwMNpinOwrrEKbG/MjuJFMRh7F1aiyiD0ni39+LynMeusDe+EUWhfM1
         2lVirY7p06POHezp4IUR14yLBkTFfF71v/T9vck0btC2w7OZdSA+6Y5/Bx2jeogI4YpA
         qJGb4Pi92uBgnbUHqqVaKd1bD/jmk4yJkkpfwjDVLmNfmMQPd09Li+zlce3av6olws43
         H1+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=V9CV9BaQt0xTPSvPPcYe5ZuTRlahoiIA49Vi1uWbMvM=;
        b=VHkGHdaxwV9dHD6tLM0OrRFOPX71VBYJs1QAJDgjIRmwxqpOR20ueUebBqPLS7IP4b
         puwe04TTK3Fx5OljBtxgwFS4nya1QOgDyvxPvhUFuQTuTQXt5X1Het+SFZ/05BSbZPf8
         Q7pb/H/uRFm/hQ8Jr8iNraJxIuZslcEvp0GVpBVje/sVseqzwOIS3xCiTHe5QjcKvN93
         /tVNrCBB6v7Xzap5RRf7minJSE7USxRiDbSUUcOQvBd9ByPuq+vCLrE5wKENB3t86W2w
         mKMWbPk85+j+WaubwMn/B2JbKBwVMoJIzvUNsXEVuZ6wqwyvkAiuXKemR+M5FTsbYyOQ
         OYFg==
X-Gm-Message-State: APjAAAWpUI3GvPOM8N/MuKBVCQB8ePmK2yscl4MPqefomyQcCkc8BQXi
        Xx4MMh0LJF6iw6HLR0Z2NXI=
X-Google-Smtp-Source: APXvYqyt41S9BWAxY1jH/gqa8OMjLQxbDKx07HbzVI6HJI5rRAGu39IEy8qRUv9sDgQDqduRt9PMqQ==
X-Received: by 2002:a63:a43:: with SMTP id z3mr6364243pgk.232.1576719328218;
        Wed, 18 Dec 2019 17:35:28 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::4108])
        by smtp.gmail.com with ESMTPSA id 144sm5437955pfc.124.2019.12.18.17.35.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 17:35:27 -0800 (PST)
Date:   Wed, 18 Dec 2019 17:35:25 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/3] Libbpf extern support improvements
Message-ID: <20191219013524.klow6gvmumgpqb6s@ast-mbp.dhcp.thefacebook.com>
References: <20191219002837.3074619-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219002837.3074619-1-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 04:28:33PM -0800, Andrii Nakryiko wrote:
> Based on latest feedback and discussions, this patch set implements the
> following changes:
> 
> - Kconfig-provided externs have to be in .kconfig section, for which
>   bpf_helpers.h provides convenient __kconfig macro (Daniel);
> - instead of allowing to override Kconfig file path, switch this to ability to
>   extend and override system Kconfig with user-provided custom values (Alexei);
> - BTF is required when externs are used.

Applied, Thanks
