Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744982F1D16
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389874AbhAKRtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:49:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbhAKRtr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 12:49:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B77F920738;
        Mon, 11 Jan 2021 17:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610387347;
        bh=RXlynIWewckpvWYTwr2hFaEDcdwkOLMcnxES4p02tnw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r1xENf6tN2lTHlrYCxCjQbBVdCfPsPjcRJ5aYvIA5ZPBSish0TzBpZ3bhfhIU68qM
         7iWREkc74RI/TnY75Y5OFbgHcLPp6V9AG7dIllUSO1S4l0sxJE0AWIrxXFMUFqc5HF
         IcKdcCK40oriZ2F73+pJB4CCA3xMh5dtPFPublINXg2uWP26OFvyw3BiVyPB/KwL8A
         KiRM5EXdvy3wApc4Ii/gaSAXl/6TaCENOOOvqCD1XDGyY4OAE06zECIIe6FlwTfAuB
         ismAGm9lKoPzo5JGS1oYoMTPh+QXV6Al5nouWbvUm8LHX0ssw4lPti8yJ6EqJkQmkO
         gWyziRND6ckyA==
Date:   Mon, 11 Jan 2021 18:49:02 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com
Subject: Re: [PATCH net-next v14 2/6] net: phy: Add 5GBASER interface mode
Message-ID: <20210111184902.67003f2c@kernel.org>
In-Reply-To: <20210111164803.GY1551@shell.armlinux.org.uk>
References: <20210111012156.27799-1-kabel@kernel.org>
        <20210111012156.27799-3-kabel@kernel.org>
        <20210111164803.GY1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 16:48:03 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> Please document this in Documentation/networking/phy.rst under the
> "PHY interface modes" section. Thanks.

Should this documentation come in a separate patch? Or can it be
embedded in this one?
