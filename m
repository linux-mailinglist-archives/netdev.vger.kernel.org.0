Return-Path: <netdev+bounces-2450-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12828701F97
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 22:54:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2740C281061
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 20:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC0CBE50;
	Sun, 14 May 2023 20:54:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B6729A0
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 20:54:16 +0000 (UTC)
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0EF55E7A;
	Sun, 14 May 2023 13:54:13 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 2215892009C; Sun, 14 May 2023 22:54:11 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 1361D92009B;
	Sun, 14 May 2023 21:54:11 +0100 (BST)
Date: Sun, 14 May 2023 21:54:10 +0100 (BST)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Bjorn Helgaas <helgaas@kernel.org>
cc: Bjorn Helgaas <bhelgaas@google.com>, 
    Mahesh J Salgaonkar <mahesh@linux.ibm.com>, 
    Oliver O'Halloran <oohall@gmail.com>, 
    Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
    Christophe Leroy <christophe.leroy@csgroup.eu>, 
    Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
    "David S. Miller" <davem@davemloft.net>, 
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
    Paolo Abeni <pabeni@redhat.com>, 
    Alex Williamson <alex.williamson@redhat.com>, 
    Lukas Wunner <lukas@wunner.de>, 
    Mika Westerberg <mika.westerberg@linux.intel.com>, 
    Stefan Roese <sr@denx.de>, Jim Wilson <wilson@tuliptree.org>, 
    David Abdurachmanov <david.abdurachmanov@gmail.com>, 
    =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, linux-pci@vger.kernel.org, 
    linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org, 
    netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 7/7] PCI: Work around PCIe link training failures
In-Reply-To: <alpine.DEB.2.21.2305071922310.54316@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2305142145320.11892@angie.orcam.me.uk>
References: <20230504222048.GA887151@bhelgaas> <alpine.DEB.2.21.2305071922310.54316@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, 7 May 2023, Maciej W. Rozycki wrote:

> > We're going to land this series this cycle, come hell or high water.
> 
>  Thank you for coming back to me and for your promise.  I'll strive to 
> address your concerns next weekend.
> 
>  Unfortunately a PDU in my remote lab has botched up and I've lost control
> over it (thankfully not one for the RISC-V machine affected by the patch 
> series, so I can still manage it for reboots, etc., but the botched PDU is 
> actually upstream), so depending on how situation develops I may have to 
> book air travel instead and spend the whole weekend getting things back to 
> normal operation at my lab.  That unit was not supposed to fail, not in 
> such a silly way anyway, sigh...

 Last Thu the situation with the PDU became critical, so I spent a better 
part of yesterday and today travelling and then all night long getting 
things sorted.  So it'll have to be next weekend when I get back to these 
patches.  I hope we can still make it regardless.

  Maciej

