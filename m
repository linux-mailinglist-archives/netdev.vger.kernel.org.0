Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3323A2231
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 19:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfH2R0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 13:26:22 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36892 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727173AbfH2R0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 13:26:21 -0400
Received: by mail-ed1-f65.google.com with SMTP id f22so4916103edt.4
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 10:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Z1hBM6a12jbRaXAj1gbdtajsBiZ8JIeFnckIVn0uufQ=;
        b=Wr7eLRBzruTapyxdyGwXFoXNW0p3BWFPkFw/DztOzWOeC9G57fazasY0H9F8bPuA37
         Ts5kqQb7nSWlVBcp+35YI2i3S1p0YCKzQLUKFLsIqw+P886usS7AE8Sga+s8y+ncu+/Y
         udARhxyL4CDkuowRDP5WPliVskuL7AfLteC4oPoesciSnyi7xLq/eIth6v/8Z4HOUJDu
         ZC8kuiU//tV3paZRyZ3T6IAq5JJqG/AXXOROWolHmrEU6iZhEibTd6jX4NEMboZn6GLg
         jmD+bfP66yirOwtE8hG9l5h+2nCOo9mbBV4lv1HdW51pY2cM1FqmWUcg4PXoPRHPGaGB
         NgjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Z1hBM6a12jbRaXAj1gbdtajsBiZ8JIeFnckIVn0uufQ=;
        b=V2udebexElEXvgd9RnCEuM9b7nAKGmLY0iAqzg7rCftndKgeDCcpSgV30aKsrG0LNc
         Brx43kBKB2gCLjRMTSSjFctYM305ykIKugYK17tUGKDGG5foQGI0ym365boPqPkl+IQi
         G6YdGg6M5xIMOAFD6PhPo0Fvug1WjudzeO8aB9LOy5MPoCa98ekHmSLo3lqW17SbeN3C
         kOlYIgBB/+ypQGLLi0XEpZokiwY9sehlFmS6SBD8PTVtaOnc8TgX9axdhSV72rqGTol1
         q5sCVvj16hVpEmG03MxATkGBCvsS7Dp6fzgCKx0N8A6r7TRn8sT5sPq9Ppm5QlzbJ+cS
         rZyQ==
X-Gm-Message-State: APjAAAUY/Z3rGwJS4FuMt7baBzmk2UCbdymGiYARH974cSxox/v0asyK
        1WLasdt/ZC/W9TQr5O9jaNUdqw==
X-Google-Smtp-Source: APXvYqyL6jX1KOmiBWT9jCF/AXYT3OfqegjzZmbilhO3X8HK1KqwBRDZPwT6Molcehm9IGGfJiLgJQ==
X-Received: by 2002:a17:906:4e8f:: with SMTP id v15mr1119760eju.147.1567099580191;
        Thu, 29 Aug 2019 10:26:20 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id k18sm385333ejq.45.2019.08.29.10.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 10:26:19 -0700 (PDT)
Date:   Thu, 29 Aug 2019 10:25:54 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Lorenz Bauer <lmb@cloudflare.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: Re: [PATCH bpf-next 0/3] tools: bpftool: improve bpftool build
 experience
Message-ID: <20190829102554.2fdbc80b@cakuba.netronome.com>
In-Reply-To: <20190829105645.12285-1-quentin.monnet@netronome.com>
References: <20190829105645.12285-1-quentin.monnet@netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 11:56:42 +0100, Quentin Monnet wrote:
> Hi,
> This set attempts to make it easier to build bpftool, in particular when
> passing a specific output directory. This is a follow-up to the
> conversation held last month by Lorenz, Ilya and Jakub [0].
> 
> The first patch is a minor fix to bpftool's Makefile, regarding the
> retrieval of kernel version (which currently prints a non-relevant make
> warning on some invocations).
> 
> Second patch improves the Makefile commands to support more "make"
> invocations, or to fix building with custom output directory. On Jakub's
> suggestion, a script is also added to BPF selftests in order to keep track
> of the supported build variants.
> 
> At last, third patch is a sligthly modified version of Ilya's fix regarding
> libbpf.a appearing twice on the linking command for bpftool.
> 
> [0] https://lore.kernel.org/bpf/CACAyw9-CWRHVH3TJ=Tke2x8YiLsH47sLCijdp=V+5M836R9aAA@mail.gmail.com/

I think Ilya has a point, but otherwise looks good to me :)

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
