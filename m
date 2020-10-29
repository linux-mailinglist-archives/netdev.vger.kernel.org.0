Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E6029F23A
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 17:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgJ2Qvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 12:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727030AbgJ2QuB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 12:50:01 -0400
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BED820838;
        Thu, 29 Oct 2020 16:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603990193;
        bh=CHD/9gHRLoFDqb2i1aThqXvO5dexszm10TA9Qc+jbmE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p6zRD09JVMKQthKLJkGnpe5sTSQk+7oro/ammUWiQ/LmYw6CdhPw93Pu907oyHkJe
         RYnVCXghkrOl0UxnuCM4hHRV3lxx61wcSAs62htARNh8BM5eiHafpHEByoDmXl7UEf
         /iSEjnJfzB4c8pOyIF77Ce1lSjDo5DqNhQ8CCWt4=
Date:   Thu, 29 Oct 2020 17:49:42 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 5/5] net: sfp: add support for multigig
 RollBall transceivers
Message-ID: <20201029174942.6bdf10c4@kernel.org>
In-Reply-To: <20201029133800.GU1551@shell.armlinux.org.uk>
References: <20201028221427.22968-1-kabel@kernel.org>
        <20201028221427.22968-6-kabel@kernel.org>
        <20201029133800.GU1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 13:38:00 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> Any ideas why it takes 25 seconds for the module to initialise - the
> 88x3310 startup is pretty fast in itself. However, it never amazes me
> how broken SFP modules can be.

I don't know, but for the first 25 seconds the SFP returns 0xffff on
all reads. I think it is due to the internal MCU doing it's own stuff
with the PHY during that time.

Marek
