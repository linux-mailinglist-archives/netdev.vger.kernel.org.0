Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E9039AB0E
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 21:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhFCTup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 15:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFCTum (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 15:50:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 701E961361;
        Thu,  3 Jun 2021 19:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622749737;
        bh=VnDzWQzG7TYNgACf0mkYi5azW9YcI6L4zi7Vryt/j4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IvSRxJ+LXm7Z43EaLZ8Ex9/npfUbIf1WU0Kcb+girUiHtEeV6v5EL4c189TN63AY9
         Y6vxdqgl8S4ipeJ6/joRnhLdt4L7F2mQ065mA+WrPaSwQQZ4PRwuBKP0hI7p0hGCQJ
         HsJHGr7mU9KPFSQp1aPXqMsASCoIdgJJc4xIZmEsKb4d2gkh1p0+sUar+3XlwWIcpD
         t+G9TWEHruf06uFdeQCQLKFqite2Cfm7SaPzIuLyBIMVzGQRlXS7pvgihKGi668UUw
         XV7joZBm9hIUILhZQ7ufVAEj2tmyMmDBZkg/33lSO9JKLe+qQ09MymHcMi1X+2nxDa
         oxtZKb9HPFo4A==
Received: by pali.im (Postfix)
        id 0866E1229; Thu,  3 Jun 2021 21:48:53 +0200 (CEST)
Date:   Thu, 3 Jun 2021 21:48:53 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Igal Liberman <Igal.Liberman@freescale.com>,
        Shruti Kanetkar <Shruti@freescale.com>,
        Emil Medve <Emilian.Medve@freescale.com>,
        Scott Wood <oss@buserror.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Unsupported phy-connection-type sgmii-2500 in
 arch/powerpc/boot/dts/fsl/t1023rdb.dts
Message-ID: <20210603194853.ngz4jdso3kfncnj4@pali>
References: <20210603143453.if7hgifupx5k433b@pali>
 <YLjxX/XPDoRRIvYf@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YLjxX/XPDoRRIvYf@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 03 June 2021 17:12:31 Andrew Lunn wrote:
> On Thu, Jun 03, 2021 at 04:34:53PM +0200, Pali Rohár wrote:
> > Hello!
> > 
> > In commit 84e0f1c13806 ("powerpc/mpc85xx: Add MDIO bus muxing support to
> > the board device tree(s)") was added following DT property into DT node:
> > arch/powerpc/boot/dts/fsl/t1023rdb.dts fm1mac3: ethernet@e4000
> > 
> >     phy-connection-type = "sgmii-2500";
> > 
> > But currently kernel does not recognize this "sgmii-2500" phy mode. See
> > file include/linux/phy.h. In my opinion it should be "2500base-x" as
> > this is mode which operates at 2.5 Gbps.
> > 
> > I do not think that sgmii-2500 mode exist at all (correct me if I'm
> > wrong).
> 
> Kind of exist, unofficially. Some vendors run SGMII over clocked at
> 2500. But there is no standard for it, and it is unclear how inband
> signalling should work. Whenever i see code saying 2.5G SGMII, i
> always ask, are you sure, is it really 2500BaseX? Mostly it gets
> changed to 2500BaseX after review.

So this is question for authors of that commit 84e0f1c13806. But it
looks like I cannot send them emails because of following error:

<Minghuan.Lian@freescale.com>: connect to freescale.com[192.88.156.33]:25: Connection timed out

Do you have other way how to contact maintainers of that DTS file?
arch/powerpc/boot/dts/fsl/t1023rdb.dts

> PHY mode sgmii-2500 does not exist in mainline.

Yes, this is reason why I sent this email. In DTS is specified this mode
which does not exist.

> 	Andrew
> 
