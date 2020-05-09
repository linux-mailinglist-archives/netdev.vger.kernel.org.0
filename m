Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625301CC4D8
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 23:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbgEIV6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 17:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728408AbgEIV6I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 17:58:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1159320A8B;
        Sat,  9 May 2020 21:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589061488;
        bh=8LDwYge0vi4f67R9PaFiUhi9lpFstDMiQuOLGmpth7k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K2+i6h0Qfml79Q9GynUDuEHqxkFRC42Z/v4aibYZA8p+JTUZ+9dxA+4oAZ3Ec2477
         MZMt2m2FmiLtUmRripbB0L640+1e5RedlLKQ+vSpGzloTIU0UHMsSMK15HJ4FJCopm
         0uhWtMvUV6IWBjE4pzIntuYKps9WjI8r19kBahBA=
Date:   Sat, 9 May 2020 14:58:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Stefan Chulski <stefanc@marvell.com>
Subject: Re: [PATCH net] mvpp2: enable rxhash only on the first port
Message-ID: <20200509145806.3e82a710@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200509202355.GL1551@shell.armlinux.org.uk>
References: <20200509141546.5750-1-mcroce@redhat.com>
        <20200509202355.GL1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 May 2020 21:23:55 +0100 Russell King - ARM Linux admin wrote:
> I seem to have discovered the cause of the problem in the old thread,
> so I suggest we wait and see whether anyone offers up a proper
> solution to this regression before we rush to completely disable
> this feature.
> 
> I would suggest with a high degress of confidence based on my
> research that prior to the offending commit (895586d5dc32), rx
> hashing was working fine, distributing interrupts across the cores.

Ack, dropping this from patchwork for now. Thanks for the guidance.
