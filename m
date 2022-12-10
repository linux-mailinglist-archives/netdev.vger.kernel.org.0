Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFDB648DD4
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 10:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiLJJMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 04:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiLJJLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 04:11:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FD536C4C;
        Sat, 10 Dec 2022 01:07:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35CC56023A;
        Sat, 10 Dec 2022 09:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6384EC433EF;
        Sat, 10 Dec 2022 09:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670663252;
        bh=NaFpxIBHcluX/faYQxP/qdXrH/73a3B6ENni/WCKJgM=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=NVfD/EYy+R1kCJB7/QK2PNnA70zrogehL0NBbqhZ97QhRjJCr5dHIZe/t6yDCvSja
         uJ553qfzFDaaPjuDO4ArWKXFSbtuDhKK08IKpr8+QW43lWeNABA9Zx3TlY9yEh/xMs
         HoFrWq0ALv5QFBPw45xSgL5sLbNFcnoBqRkxYv7iZiZ/qDLZCnbm7rTF0Bn1MaK/FS
         bh1Tsl1HmAGgq/EDWYjHtM+J8qgBfv1o9wZF59d9J7NO504xX+YVXadBQ90+/jTFpG
         AQNaBuaVflWPtrsZQlB9dGgs1siTbtvNMFtSkKx2GKKGwazKWV4Z3mfs6ZtYwqILA/
         3GK8KSTrTZamQ==
Date:   Sat, 10 Dec 2022 10:07:31 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc:     Florent Revest <revest@chromium.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH HID for-next v3 0/5] HID: bpf: remove the need for
 ALLOW_ERROR_INJECTION and Kconfig fixes
In-Reply-To: <20221206145936.922196-1-benjamin.tissoires@redhat.com>
Message-ID: <nycvar.YFH.7.76.2212101007030.9000@cbobk.fhfr.pm>
References: <20221206145936.922196-1-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Dec 2022, Benjamin Tissoires wrote:

> Compared to v2, I followed the review from Alexei which cleaned up the
> code a little bit.
> 
> I also got a kbuild test bot complaining[3] so add a fix for that too.
> 
> For reference, here is the previous cover letter:
> 
> So this patch series aims at solving both [0] and [1].
> 
> The first one is bpf related and concerns the ALLOW_ERROR_INJECTION API.
> It is considered as a hack to begin with, so introduce a proper kernel
> API to declare when a BPF hook can have its return value changed.
> 
> The second one is related to the fact that
> DYNAMIC_FTRACE_WITH_DIRECT_CALLS is currently not enabled on arm64, and
> that means that the current HID-BPF implementation doesn't work there
> for now.
> 
> The first patch actually touches the bpf core code, but it would be
> easier if we could merge it through the hid tree in the for-6.2/hid-bpf
> branch once we get the proper acks.

For the series:

	Reviewed-by: Jiri Kosina <jkosina@suse.cz>

Thanks,

-- 
Jiri Kosina
SUSE Labs

