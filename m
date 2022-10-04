Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881395F3C36
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 06:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiJDEtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 00:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiJDEtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 00:49:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5672D95AC;
        Mon,  3 Oct 2022 21:49:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 295A261245;
        Tue,  4 Oct 2022 04:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59669C433C1;
        Tue,  4 Oct 2022 04:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664858982;
        bh=cYH3OaJPZqHaXKJR7nmcNhFlomqAJiw2jvkxABzOjEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rlUjUxGKzwHAZo6foiGvK856F0mzDo++jVJZ6oG0ftvoU3+aKYUwFTlRntDORQjtK
         oGQUYUVUc7hln9WGzNr8Cv/+9uh8bZRWclxmpMXQSkLbba1nN63Cc2nOfghfmHiNRs
         3PWXhOQWY0YtnQmPlJPhrF5p45Yd/XrjuMD/OcuHM0O/E8G3GGTrqtJ4QxvxvDcXFR
         glfKRrm/8Xy6tT2a+QWx+PwlHimqiozdMh0XTHICZb/AiaBxkytxIOWuIws2wdFV39
         X26dkp8g7/GgGUZzdPUUHjiQUL2Wvw/XgUW6KZ3Jt0tbvNK1HHBn5tNflN9le3kmcI
         ymJ9iFYFSYErw==
Date:   Mon, 3 Oct 2022 21:49:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Xu <dxu@dxuuu.xyz>, Martin KaFai Lau <martin.lau@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, bpf@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using 92168
Message-ID: <20221003214941.6f6ea10d@kernel.org>
In-Reply-To: <20221003190545.6b7c7aba@kernel.org>
References: <20221003190545.6b7c7aba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Oct 2022 19:05:45 -0700 Jakub Kicinski wrote:
> Hi Jiri,
> 
> I get the following warning after merging up all the trees:
> 
> vmlinux.o: warning: objtool: ___ksymtab+bpf_dispatcher_xdp_func+0x0: data relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0
> vmlinux.o: warning: objtool: bpf_dispatcher_xdp+0xa0: data relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0
> 
> $ gcc --version
> gcc (GCC) 8.5.0 20210514 (Red Hat 8.5.0-15)
> 
> 
> Is this known?

Also hit this:

WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using 92168
WARN: multiple IDs found for 'nf_conn': 92168, 121226 - using 92168
