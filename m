Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3345C309368
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhA3JbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:31:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:35150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233553AbhA3DbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:31:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F65664DE3;
        Sat, 30 Jan 2021 03:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611977431;
        bh=9+uUvSjBWlB9+9VCQWxaQCXbsoEgWmRNsgIGNRHjCSw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g/CwsceJN6lHg7LS0LUocgufGGFWpmkRvvV8NEsSeKNKyZhJoUmxHZpld0/88sqYp
         +ZzzG629hwjsqyo3Z+jU2V7XUIBRD7u2ZPiDQPUSihMbfRiw6VNmrWXf1XflOZkiXn
         87oezuuJ+ZyGNRKr1nPPKSppDID02s5nmztJgJgbXwcWJ/WbbuPlIZsAdd3FDhkY3O
         6WsY8hhd6b8TvX2qkCNnkImQZLuKNZ+CliwoSOMtC2OIGyD/TO1aKpyEBTMMvPYEHO
         xK4Wimp1ASbNhf9h6TCDiXxEzK88Eoj3sL9R6poCWyREzgshXcIQyKXHD4WV/dZurT
         txLFuKn2mfqSw==
Date:   Fri, 29 Jan 2021 19:30:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robert Hancock <hancockrwd@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Patch for stable: iwlwifi: provide gso_type to GSO packets
Message-ID: <20210129193030.46ef3b17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADLC3L0vBXwLLdqKxox9E-K4dSH07ZhHZ5u_kaANb=16jon0zg@mail.gmail.com>
References: <CADLC3L0vBXwLLdqKxox9E-K4dSH07ZhHZ5u_kaANb=16jon0zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 20:41:11 -0600 Robert Hancock wrote:
> Figured I would poke someone to add this patch to the stable queue - I
> don't see it in
> https://patchwork.kernel.org/bundle/netdev/stable/?state=* right now.
> This patch is reported to fix a severe upload speed regression in many
> Intel wireless adapters existing since kernel 5.9, as described in
> https://bugzilla.kernel.org/show_bug.cgi?id=209913

We're actually experimenting with letting Greg take networking patches
into stable like he does for every other tree. If the patch doesn't
appear in the next stable release please poke stable@ directly.

> commit 81a86e1bd8e7060ebba1718b284d54f1238e9bf9
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Mon Jan 25 07:09:49 2021 -0800
> 
>     iwlwifi: provide gso_type to GSO packets
> 
>     net/core/tso.c got recent support for USO, and this broke iwlfifi
>     because the driver implemented a limited form of GSO.
> 
>     Providing ->gso_type allows for skb_is_gso_tcp() to provide
>     a correct result.
> 
>     Fixes: 3d5b459ba0e3 ("net: tso: add UDP segmentation support")
>     Signed-off-by: Eric Dumazet <edumazet@google.com>
>     Reported-by: Ben Greear <greearb@candelatech.com>
>     Tested-by: Ben Greear <greearb@candelatech.com>
>     Cc: Luca Coelho <luciano.coelho@intel.com>
>     Cc: Johannes Berg <johannes@sipsolutions.net>
>     Link: https://bugzilla.kernel.org/show_bug.cgi?id=209913
>     Link: https://lore.kernel.org/r/20210125150949.619309-1-eric.dumazet@gmail.com
>     Signed-off-by: Jakub Kicinski <kuba@kernel.org>

