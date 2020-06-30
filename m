Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7619720FCEA
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgF3Toz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:44:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbgF3Toy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 15:44:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33A7B206B6;
        Tue, 30 Jun 2020 19:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593546294;
        bh=bpuJ6UMXAMGc3vUyMkJ7NfpC0hvTDaW0vnpU2z0titI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nRUpa/ym7Lul4zkL2NBSduFkdvVYXMjpdspkc+Nv0qBj/48NKVXEyE1j3Bpt2q0hk
         YJrvUCAsPsrtBXPOuDBVHnnv7qhOonLf6mOYMrRmfBnvhMpNL4vqTcnYJoqdJaAz8A
         GcbekrsxTmsMmTI4MXu+RSpQNqxLBmEg2qXfmUgc=
Date:   Tue, 30 Jun 2020 12:44:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 00/14] sfc: prerequisites for EF100 driver,
 part 2
Message-ID: <20200630124452.62a11783@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
References: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jun 2020 13:00:18 +0100 Edward Cree wrote:
> Continuing on from [1], this series further prepares the sfc codebase
>  for the introduction of the EF100 driver.
> 
> [1]: https://lore.kernel.org/netdev/20200629.173812.1532344417590172093.davem@davemloft.net/T/

Acked-by: Jakub Kicinski <kuba@kernel.org>
