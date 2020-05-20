Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6651DBA4E
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 18:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgETQyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 12:54:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgETQyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 12:54:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 646C52065F;
        Wed, 20 May 2020 16:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589993672;
        bh=sW1YjsDEdgahasiwX/6ulQntzoMqu94zT5P0AQ1b93M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g+mfeyxBT6qVplSznjxlhKbGkVuRvhFVAlz0Ynetdi8pQDRNWZEr3kl08kKMziZle
         bFlKNARlU21yGF8p0VsuazWrWLqzKiiSFxMpMnXxKYszfKVhC/V2D0qVvk7d1y88Zn
         GDFocjZwXfrCWY+XgeVJFKQ6TxSgAi+8/KGZpRn8=
Date:   Wed, 20 May 2020 09:54:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     fugang.duan@nxp.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        martin.fuzzey@flowbird.group, robh+dt@kernel.org,
        shawnguo@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net 1/4] net: ethernet: fec: move GPR register offset
 and bit into DT
Message-ID: <20200520095430.05cffcee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1589963516-26703-2-git-send-email-fugang.duan@nxp.com>
References: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
        <1589963516-26703-2-git-send-email-fugang.duan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 16:31:53 +0800 fugang.duan@nxp.com wrote:
> From: Fugang Duan <fugang.duan@nxp.com>
> 
> The commit da722186f654(net: fec: set GPR bit on suspend by DT
> configuration) set the GPR reigster offset and bit in driver for
> wake on lan feature.
> 
> But it introduces two issues here:
> - one SOC has two instances, they have different bit
> - different SOCs may have different offset and bit
> 
> So to support wake-on-lan feature on other i.MX platforms, it should
> configure the GPR reigster offset and bit from DT.
> 
> Fixes: da722186f654(net: fec: set GPR bit on suspend by DT configuration)
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>

Fixes tag: Fixes: da722186f654(net: fec: set GPR bit on suspend by DT configuration)
Has these problem(s):
	- missing space between the SHA1 and the subject
