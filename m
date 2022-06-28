Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816BE55E7F1
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345961AbiF1OSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346441AbiF1OSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:18:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81CCDEA;
        Tue, 28 Jun 2022 07:18:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AFB9B81E0B;
        Tue, 28 Jun 2022 14:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5F2C341C6;
        Tue, 28 Jun 2022 14:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656425908;
        bh=gNqsfpabtVurh3KrN/HDHkVIuq5HYEGkFj0dq9pxBp0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LKmDxdeiZbNhcfCtRCGKrWsyjlCMGrWNe6JPI6+0Ud4+CdurjXwUmrO+N85g9uStN
         ZMyX+h6jcWDShk2bKHv4I1CwjG76KgIokSJRaPNHE+tAExMRqCJhyYb+qk23PpSnt8
         UZagMIRlLLl0N2746CMcacDFBvR451lE95WpeBq0GW4QDuaouxlRRNIVOVHDclrQ6f
         3R9oBNaPqtGDm4Fzozu0TEhclsuvbNSWpoAarBMEoFPJEcd4AO2pVjb65zJgdF1PVp
         ef3Ggil+1czhmYD/i4aHezmCjBjk3ri61YXhTXJoT9Ami17Y24U2vq1uockAAm5n3K
         LL1PsE5NQ0Syg==
Date:   Tue, 28 Jun 2022 16:18:23 +0200
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, dm-devel@redhat.com,
        linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-can@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, io-uring@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-mtd@lists.infradead.org,
        kasan-dev@googlegroups.com, linux-mmc@vger.kernel.org,
        nvdimm@lists.linux.dev, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-perf-users@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        v9fs-developer@lists.sourceforge.net, linux-rdma@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] treewide: uapi: Replace zero-length arrays with
 flexible-array members
Message-ID: <20220628141823.GB25163@embeddedor>
References: <20220627180432.GA136081@embeddedor>
 <20220627125343.44e24c41@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220627125343.44e24c41@hermes.local>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 12:53:43PM -0700, Stephen Hemminger wrote:
> Thanks this fixes warning with gcc-12 in iproute2.
> In function ‘xfrm_algo_parse’,
>     inlined from ‘xfrm_state_modify.constprop’ at xfrm_state.c:573:5:
> xfrm_state.c:162:32: warning: writing 1 byte into a region of size 0 [-Wstringop-overflow=]
>   162 |                         buf[j] = val;
>       |                         ~~~~~~~^~~~~

Great! This gives me hope. :)

Thanks
--
Gustavo
