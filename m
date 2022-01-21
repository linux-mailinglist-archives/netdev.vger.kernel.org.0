Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E305A495D13
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 10:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379785AbiAUJwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 04:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiAUJwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 04:52:51 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E63C061574;
        Fri, 21 Jan 2022 01:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=huKIaVgiGnWWbcgV7nT1kjaAHzLSM7cb3lsQXtDY1bU=; b=H/StlckykPg0QkowRv1lO2f688
        stfbZi4QWJWFR/CkSHjZVN7IKgCoKayu3J3lzVxaU8qRtVd1tPRCv0U71q/me7PwZgrXJb8+7Rb1s
        G/P9PnbFOH2HSCbfwbzoktaQR8RUWm3NlxOD74b6uwkAEIRKmm6dFvXDRtKGUa46Hfe616PDWdHoG
        B9IlIoOxig/Nf0/i4shTiGbIFMiFh/RfTc24tMxVf96iNpT59wC6nUiaZC0TkxLxFkJOovoKFnj3w
        FBPKcezupV83mOlu/cYw58E0EUFbrgiP8wdHB7ZFsKO0Ay7fmV01e/M715iSk8z/TG/I9NnXlgofP
        KP7+2bsw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nAqb0-002YUv-BS; Fri, 21 Jan 2022 09:52:38 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id DF0239853F1; Fri, 21 Jan 2022 10:52:36 +0100 (CET)
Date:   Fri, 21 Jan 2022 10:52:36 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kernel-team@fb.com, x86@kernel.org
Subject: Re: [PATCH v5 bpf-next 5/7] x86/alternative: introduce text_poke_copy
Message-ID: <20220121095236.GD20638@worktop.programming.kicks-ass.net>
References: <20220120191306.1801459-1-song@kernel.org>
 <20220120191306.1801459-6-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120191306.1801459-6-song@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 11:13:03AM -0800, Song Liu wrote:
> This will be used by BPF jit compiler to dump JITed binary to a RX huge
> page, and thus allow multiple BPF programs sharing the a huge (2MB) page.
> 
> Signed-off-by: Song Liu <song@kernel.org>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
