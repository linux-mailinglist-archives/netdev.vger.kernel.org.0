Return-Path: <netdev+bounces-759-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43FD96F9AE2
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 20:33:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07EFD1C214CE
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 18:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B11DC8460;
	Sun,  7 May 2023 18:33:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C2A523F
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 18:33:21 +0000 (UTC)
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4A306E82;
	Sun,  7 May 2023 11:33:19 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id A527C92009C; Sun,  7 May 2023 20:33:16 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 96E4F92009B;
	Sun,  7 May 2023 19:33:16 +0100 (BST)
Date: Sun, 7 May 2023 19:33:16 +0100 (BST)
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
In-Reply-To: <20230504222048.GA887151@bhelgaas>
Message-ID: <alpine.DEB.2.21.2305071922310.54316@angie.orcam.me.uk>
References: <20230504222048.GA887151@bhelgaas>
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

On Thu, 4 May 2023, Bjorn Helgaas wrote:

> On Thu, Apr 06, 2023 at 01:21:31AM +0100, Maciej W. Rozycki wrote:
> > Attempt to handle cases such as with a downstream port of the ASMedia 
> > ASM2824 PCIe switch where link training never completes and the link 
> > continues switching between speeds indefinitely with the data link layer 
> > never reaching the active state.
> 
> We're going to land this series this cycle, come hell or high water.

 Thank you for coming back to me and for your promise.  I'll strive to 
address your concerns next weekend.

 Unfortunately a PDU in my remote lab has botched up and I've lost control
over it (thankfully not one for the RISC-V machine affected by the patch 
series, so I can still manage it for reboots, etc., but the botched PDU is 
actually upstream), so depending on how situation develops I may have to 
book air travel instead and spend the whole weekend getting things back to 
normal operation at my lab.  That unit was not supposed to fail, not in 
such a silly way anyway, sigh...

  Maciej

