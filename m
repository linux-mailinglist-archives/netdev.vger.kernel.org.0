Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E97ACA9D12
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 10:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731615AbfIEIeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 04:34:12 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:59174 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730659AbfIEIeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 04:34:12 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 618C625B753;
        Thu,  5 Sep 2019 18:34:10 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 490F2940AC6; Thu,  5 Sep 2019 10:34:08 +0200 (CEST)
Date:   Thu, 5 Sep 2019 10:34:08 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     David Miller <davem@davemloft.net>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
Subject: Re: [net-next 2/3] ravb: Remove undocumented processing
Message-ID: <20190905083407.bnx2l4lkqfek3qfc@verge.net.au>
References: <20190902080603.5636-1-horms+renesas@verge.net.au>
 <20190902080603.5636-3-horms+renesas@verge.net.au>
 <f54e244a-2d9d-7ba8-02fb-af5572b3a191@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f54e244a-2d9d-7ba8-02fb-af5572b3a191@cogentembedded.com>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 02, 2019 at 08:41:14PM +0300, Sergei Shtylyov wrote:
> On 09/02/2019 11:06 AM, Simon Horman wrote:
> 
> > From: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
> > 
> > This patch removes the use of the undocumented registers
> > CDCR, LCCR, CERCR, CEECR and the undocumented BOC bit of the CCC register.
> 
>    The driver has many more #define's marked as undocumented. It's not clear
> why you crammed the counters and the endianness bit in one patch. It clearly
> needs to be split -- one patch for the MAC counters and one patch for the
> AVB-DMAC bit.

Thanks for the suggestion, I will split the patch.

> > Current documentation for EtherAVB (ravb) describes the offset of
> > what the driver uses as the BOC bit as reserved and that only a value of
> > 0 should be written. Furthermore, the offsets used for the undocumented
> > registers are also considered reserved nd should not be written to.
> > 
> > After some internal investigation with Renesas it remains unclear
> > why this driver accesses these fields but regardless of what the historical
> > reasons are the current code is considered incorrect.
> > 
> > Signed-off-by: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
> > Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> [...]
> 
> MBR, Sergei
> 
