Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71F92890B8
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390397AbgJISYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:24:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390392AbgJISYy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 14:24:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DF3D22284;
        Fri,  9 Oct 2020 18:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602267893;
        bh=3gzFofUqvvuEvMRqSqivHVmFqIoTnziY9ubwe/C3228=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bVC8c59n0iudoHofaZB/OcH4nM7ZKfF0JpaDCNZfARx1qHcqRW564v2G3fcWlG3hI
         gy8JsIEJ5LqdLB35CRhgYk2GlBdEswQShLKjo/EL+9M8DJf2ptQVfjl/3uVZFUj6uA
         dqBGxvJg1RBDzG9jww9YEiFDnxa6f9uJqry/3BHE=
Date:   Fri, 9 Oct 2020 11:24:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, john.fastabend@gmail.com, yhs@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH bpf-next v2 1/6] bpf: improve bpf_redirect_neigh helper
 description
Message-ID: <20201009112451.3ce7a6b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8fcc44a98c7600492c5f1fc1e79fccdcf3bfe4d2.1602252399.git.daniel@iogearbox.net>
References: <cover.1602252399.git.daniel@iogearbox.net>
        <8fcc44a98c7600492c5f1fc1e79fccdcf3bfe4d2.1602252399.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Oct 2020 16:10:10 +0200 Daniel Borkmann wrote:
> + * 		get the	address of the next hop and then relies on the neighbor

FWIW if you have to respin there is a tab in the middle of this line

> + * 		get the	address of the next hop and then relies on the neighbor

Also copied here.
