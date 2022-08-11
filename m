Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4564058F67D
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 05:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbiHKDyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 23:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233818AbiHKDyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 23:54:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D83783BCE;
        Wed, 10 Aug 2022 20:54:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3DDF61323;
        Thu, 11 Aug 2022 03:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8CCC433C1;
        Thu, 11 Aug 2022 03:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660190039;
        bh=6SH6afGD1FfbXG7YeYfQ4RzFR7jQhyCrQKdVXHLR+CE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=caE+NyZtm5V1+bQeW5fIYaocj+e/ChjqSmNOzfQCOsWOD8Ev7ORlTY/hDHCj8HOyo
         nskllk1TWIxgeiKRTgSNJONffT+cKngwQwkvqtnQ2nC8HtLMggm+FQisOgiyQfFDSY
         hT6sS365OTtb4QnRee5UrFRNklWm+9N2+u52K5DoTrKK78F9VOEgKIZHLnJvXYaAUr
         bhFNS6R4bpDqsNnE/acVo4TU8AsvPBnN2n4ZK4MTQGODZpcmaUV/pfRWBqSmL+2BPq
         fZjv611kYN6nypwQ/EDcWbtgx2OXbx+d+4QAMlbBnvOK6tpnYbdogurTuUo+L9PS7u
         r0xOof45W/MSA==
Date:   Wed, 10 Aug 2022 20:53:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        ast@kernel.org, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2022-08-10
Message-ID: <20220810205357.304ade32@kernel.org>
In-Reply-To: <20220810190624.10748-1-daniel@iogearbox.net>
References: <20220810190624.10748-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Aug 2022 21:06:24 +0200 Daniel Borkmann wrote:
> The following pull-request contains BPF updates for your *net* tree.

Could you follow up before we send the PR to Linus if this is legit?

kernel/bpf/syscall.c:5089:5: warning: no previous prototype for function 'kern_sys_bpf' [-Wmissing-prototypes]
int kern_sys_bpf(int cmd, union bpf_attr *attr, unsigned int size)
    ^
kernel/bpf/syscall.c:5089:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
int kern_sys_bpf(int cmd, union bpf_attr *attr, unsigned int size)
