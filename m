Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963303E8005
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 19:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhHJRpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 13:45:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235001AbhHJRoJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 13:44:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01AFE610CC;
        Tue, 10 Aug 2021 17:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628617164;
        bh=EHscfU8COFwfa07sm38z7urI2cktkd51Sohde9Wa1tE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JzMVRwTC4Hd+5gmZaXSzeno4j7OTlOJlQbi2itxS0SKz+hSgV2KO4mFwlkPxL9/Bq
         jh2sDR58CT2gJuqFOXHCzsS9RF+EV7Bgcpsx097mkEaB58Vt7/T4zxqwC8Ustz9Ndt
         K+JSUWCrSh74ceSJoYsUbjQK1PCUKu+OrRpsqdaVqhQXba8LREh/Em1Bol/e01YsMh
         sEbIiO8lp/dh/BcWm+6yLO9qANp8tCYvgLBzLiBHF8G0RHoR+f+9ifhTFfTo57tq6c
         cmGk9yxwtdwXmaSc1wVUUYOXpYMIoDFg+sw/5HAlheg1PmPbtyrgqfr9yGR31CqhHD
         zgtVzKEH+EODQ==
Date:   Tue, 10 Aug 2021 10:39:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, andrii.nakryiko@gmail.com, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2021-08-10
Message-ID: <20210810103923.2699d281@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210810144025.22814-1-daniel@iogearbox.net>
References: <20210810144025.22814-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Aug 2021 16:40:25 +0200 Daniel Borkmann wrote:
> 1) Fix missing bpf_read_lock_trace() context for BPF loader progs, from Yonghong Song.
> 
> 2) Fix corner case where BPF prog retrieves wrong local storage, also from Yonghong Song.
> 
> 3) Restrict availability of BPF write_user helper behind lockdown, from Daniel Borkmann.
> 
> 4) Fix multiple kernel-doc warnings in BPF core, from Randy Dunlap.

Pulled, thanks!
