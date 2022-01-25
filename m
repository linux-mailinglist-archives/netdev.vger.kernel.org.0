Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1778849AA5E
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 05:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbiAYDhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 22:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2364394AbiAYCL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 21:11:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C404C055A8C;
        Mon, 24 Jan 2022 17:04:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27F296120C;
        Tue, 25 Jan 2022 01:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FC0C340E4;
        Tue, 25 Jan 2022 01:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643072674;
        bh=gcpXyLfkYSygyEsGgZMXZ6rnNH3VukgO7fzdq73krao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M/uagqPQ4Ar7lpB9xmcHkPoSXiawyvyUhfaldhGlK4T3twZ7hU4zWlB050Gjp1I5q
         T0XeRJN1ngYMlbQMzzCNYt/wA783ZPw0FEpMeMeO5ufrcoxULcQjISSehsEBU4dTPw
         +BFQsY3etapM84l0x78nKiRwE2RnaaZVBwHn2MNM1Q2Ersf1qOiETZVyfoUPPIKUDQ
         /JqBCWXrjJv77A2E3zN3/zyI/HgAUxUD7AyoVASnQLKIzuZK/o6p4K5wPq4TtY/WdD
         LJI6Bx1Dsy3DGlK5j8Ug/QmwWlR80+YizZmzFO8xteeFAbGpNH5iO7IgP7WnbLocO0
         S6GfS3MhCqXtw==
Date:   Mon, 24 Jan 2022 17:04:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, ast@kernel.org, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2022-01-24
Message-ID: <20220124170433.069eedc5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220124221235.18993-1-daniel@iogearbox.net>
References: <20220124221235.18993-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 23:12:35 +0100 Daniel Borkmann wrote:
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 80 non-merge commits during the last 14 day(s) which contain
> a total of 128 files changed, 4990 insertions(+), 895 deletions(-).

Pulled, thanks!
