Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EE94958A0
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 04:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbiAUDqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 22:46:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49700 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbiAUDqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 22:46:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30B42B81ED3;
        Fri, 21 Jan 2022 03:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4C8C340E1;
        Fri, 21 Jan 2022 03:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642736776;
        bh=/SrJvAaNpNb/s+KiB9GJfur39sK083tmIid3c+5q0Vs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yg54iRJRlaucqQWBrWUadksFgFBxUZt0J0Lp98UbsN75fBEYn3dY5MLHYk2iE++4N
         LlJ5rFKiYOvTp3GzH3Dp+rY/NJ4L8rl8e8pstx/ThYOUirzNaK1gscWjfmM/qN9ZQc
         YlQRKdS/vMruvEBLaC52JSFZ2J1/jkoEcG7szqnpUaf28X7iFNrxK7zhsWOPXbRZJV
         a8eAcp7nCJ/4gOILg5hQv7qu4Zcpw4Mu0Gcd1ISeEjvJ4AkUzQwE44MoR437k/mxul
         mqV2L2XMtyWWQ+O94pgbBA1OOapqcP7+CBODd2Sb/GxztwJ/GVWY3AZLnulSuSmfWn
         juXxzcQD3MLYA==
Date:   Thu, 20 Jan 2022 19:46:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     ycaibb <ycaibb@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] ipv4: fix lock leaks
Message-ID: <20220120194614.379f5f30@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220121031108.4813-1-ycaibb@gmail.com>
References: <20220121031108.4813-1-ycaibb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Jan 2022 11:11:08 +0800 ycaibb wrote:
> From: Ryan Cai <ycaibb@gmail.com>
> 
> In methods listening_get_first and listening_get_first in tcp_ipv4.c,
> there are lock leaks when seq_sk_match returns true.

This is on purpose, please read the code carefully and try to test 
your patches.
