Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2490D49FDB9
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 17:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349658AbiA1QLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 11:11:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51902 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239183AbiA1QLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 11:11:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93CAE61EED;
        Fri, 28 Jan 2022 16:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFFAC340E0;
        Fri, 28 Jan 2022 16:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643386296;
        bh=2xkH+1LgGol6+y7sPa8zttF8hI+fLxq5zVrB9XQOefs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lHHBqAb/2Z7ccloUIAG6e+FJZ1C/2YyzDNKNTpa02d9QD+DjSsw4dqpn5iHba9hXD
         EApdoBdaeIM1UOnbTs5cOuK0eu2VUdHuHvPPfnZJo/QpdGlGyHWiZ1uwDMGbPtgBZe
         +Y+vOlbuFveSdNqtcQAn/ymKWYFb4emEaoQQ513MrVUxM/3R1d/HSkozP+05oHVoZV
         eKIcf858e5ILQmGQcsdxlRiGKYfJ+euNwWCYMxPVcFxIQ4hJJsCSkVfnPreY/hvdT/
         vFEehNq/6G1x5JOkz2xRTmVmZT2GhyKrlisCcUU1Jb+DHqM9z1U+RcFDgElnk4Bw1k
         rdre5tdIovTlA==
Date:   Fri, 28 Jan 2022 08:11:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Akhmat Karakotov <hmukos@yandex-team.ru>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        eric.dumazet@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, tom@herbertland.com,
        zeil@yandex-team.ru, mitradir@yandex-team.ru
Subject: Re: [PATCH net-next v3 1/4] txhash: Make rethinking txhash behavior
 configurable via sysctl
Message-ID: <20220128081134.12023513@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220128151602.2748-2-hmukos@yandex-team.ru>
References: <20220128151602.2748-1-hmukos@yandex-team.ru>
        <20220128151602.2748-2-hmukos@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jan 2022 18:15:59 +0300 Akhmat Karakotov wrote:
> Add a per ns sysctl that controls the txhash rethink behavior,
> sk_rethink_txhash. When enabled, the same behavior is retained, when
> disabled, rethink is not performed. Sysctl is enabled by default.

The new knob needs to be documented in
Documentation/admin-guide/sysctl/net.rst.

The series also does not apply cleanly to net-next, could you rebase?

Thanks!
