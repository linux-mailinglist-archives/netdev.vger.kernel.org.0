Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 815E5D1D2A
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 02:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732446AbfJJAK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 20:10:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:56020 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731145AbfJJAK7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 20:10:59 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id x9A0AioC023487;
        Wed, 9 Oct 2019 19:10:45 -0500
Message-ID: <991382b92be6b78e596b089d2c3677358afa52fc.camel@kernel.crashing.org>
Subject: Re: [PATCH 1/3] dt-bindings: net: ftgmac100: Document AST2600
 compatible
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Andrew Jeffery <andrew@aj.id.au>, netdev <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joel Stanley <joel@jms.id.au>
Date:   Thu, 10 Oct 2019 11:10:44 +1100
In-Reply-To: <4998960d-6125-4402-9905-869653a84e52@www.fastmail.com>
References: <20191008115143.14149-1-andrew@aj.id.au>
         <20191008115143.14149-2-andrew@aj.id.au>
         <75d915aec936be64ea5ebd63402efd90bb1c29d9.camel@kernel.crashing.org>
         <6f70580a-4b4b-45e0-8899-8a74f9587002@www.fastmail.com>
         <4998960d-6125-4402-9905-869653a84e52@www.fastmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-10-09 at 15:25 +1030, Andrew Jeffery wrote:
> 
> On Wed, 9 Oct 2019, at 15:19, Andrew Jeffery wrote:
> > 
> > 
> > On Wed, 9 Oct 2019, at 15:08, Benjamin Herrenschmidt wrote:
> > > On Tue, 2019-10-08 at 22:21 +1030, Andrew Jeffery wrote:
> > > > The AST2600 contains an FTGMAC100-compatible MAC, although it
> > > > no-
> > > > longer
> > > > contains an MDIO controller.
> > > 
> > > How do you talk to the PHY then ?
> > 
> > There are still MDIO controllers, they're just not in the MAC IP on
> > the 2600.
> 
> Sorry, on reflection that description is a little ambiguous in its
> use of 'it'. I'll
> fix that in v2 as well. Does this read better?
> 
> "The AST2600 contains an FTGMAC100-compatible MAC, although the MAC
> no-longer contains an MDIO controller."

That's fine. Or to be pendantic, say the MDIO controller has been moved
of the MAC unit into its own separate block or something along those
lines so people like me don't get anxious :)

Cheers,
Ben.


