Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67DCE15B7D8
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 04:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbgBMDib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 22:38:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729432AbgBMDib (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 22:38:31 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6372D206D7;
        Thu, 13 Feb 2020 03:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581565110;
        bh=WOIdnLcjHE9OfEk1miKLqHPcmwIMxhbffGCIXBpXzQ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bUU8vahtOPQAhRLhdvAKTmGHo+nPiobcMyXYzbaMkMXdObI5K68RJKY5zAV2BJm0u
         btNXUTuTX9+xRE8jvru7Dap0kWjWDYn4K4lURDwt94vESoogo4GXVBxt+idBcQKb/b
         UlmYYkyWuRlCsiXLQiX1TNXGyF3TEdvZToZ+6sfU=
Date:   Wed, 12 Feb 2020 19:38:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Krude <johannes@krude.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, trivial@kernel.org
Subject: Re: [PATCH] bpf_prog_offload_info_fill: replace bitwise AND by
 logical AND
Message-ID: <20200212193829.00ddefc0@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200212193227.GA3769@phlox.h.transitiv.net>
References: <20200212193227.GA3769@phlox.h.transitiv.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Feb 2020 20:32:27 +0100, Johannes Krude wrote:
> This if guards whether user-space wants a copy of the offload-jited
> bytecode and whether this bytecode exists. By erroneously doing a bitwise
> AND instead of a logical AND on user- and kernel-space buffer-size can lead
> to no data being copied to user-space especially when user-space size is a
> power of two and bigger then the kernel-space buffer.
> 
> Signed-off-by: Johannes Krude <johannes@krude.de>

Thank you for the fix, in the future please provide a Fixes tag and
include the tree name in the PATCH tag, e.g. [PATCH bpf], or [PATCH net]
etc.

Fixes: fcfb126defda ("bpf: add new jited info fields in bpf_dev_offload and bpf_prog_info")

Acked-by: Jakub Kicinski <kuba@kernel.org>
