Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0242C228919
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 21:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730324AbgGUT0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 15:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729171AbgGUT0c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 15:26:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD1DF20717;
        Tue, 21 Jul 2020 19:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595359592;
        bh=YT8JeCFeOfBANVQV85VKrt1V7cQfeJnHL3M/YVMcaBY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HBAUq2MjWs5SdW8ySOMC/z3bOZgoF7b3oza0jsCF75FOcMe3Dj/So9F+B4FftTxFV
         fxuGs0UxGDacAmfI/RHGFDwRtFOqpD+G7uNS4Fk25W4tflWaMQIvpxdetPB3iwr3D/
         F0vFkONMGEnqZz/bivm5N8++fDxiV5+vNRIM3DjQ=
Date:   Tue, 21 Jul 2020 12:26:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <akiyano@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: Re: [PATCH V3 net-next 0/8] ENA driver new features
Message-ID: <20200721122629.4849168b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
References: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 16:38:03 +0300 akiyano@amazon.com wrote:
> 1. Support for upcoming ENA devices
> 2. Avoid unnecessary IRQ unmasking in busy poll to reduce interrupt rate
> 3. Enabling device support for RSS function and key manipulation
> 4. Support for NIC-based traffic mirroring (SPAN port)
> 5. Additional PCI device ID
> 6. Cosmetic changes


Acked-by: Jakub Kicinski <kuba@kernel.org>
