Return-Path: <netdev+bounces-12173-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10719736874
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 11:54:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC8161C20BB1
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 09:54:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E61A9FC00;
	Tue, 20 Jun 2023 09:54:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C8DF9EA
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 09:54:15 +0000 (UTC)
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE3E42115;
	Tue, 20 Jun 2023 02:54:05 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id BC22792009C; Tue, 20 Jun 2023 11:54:04 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id B4F1492009B;
	Tue, 20 Jun 2023 10:54:04 +0100 (BST)
Date: Tue, 20 Jun 2023 10:54:04 +0100 (BST)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Bjorn Helgaas <helgaas@kernel.org>
cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, 
    Eric Dumazet <edumazet@google.com>, Oliver O'Halloran <oohall@gmail.com>, 
    Stefan Roese <sr@denx.de>, Leon Romanovsky <leon@kernel.org>, 
    linux-rdma@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, 
    Paolo Abeni <pabeni@redhat.com>, Jim Wilson <wilson@tuliptree.org>, 
    Nicholas Piggin <npiggin@gmail.com>, 
    Alex Williamson <alex.williamson@redhat.com>, 
    Bjorn Helgaas <bhelgaas@google.com>, 
    Mika Westerberg <mika.westerberg@linux.intel.com>, 
    David Abdurachmanov <david.abdurachmanov@gmail.com>, 
    linuxppc-dev@lists.ozlabs.org, Mahesh J Salgaonkar <mahesh@linux.ibm.com>, 
    "David S. Miller" <davem@davemloft.net>, Lukas Wunner <lukas@wunner.de>, 
    netdev@vger.kernel.org, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
    Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH v9 00/14] pci: Work around ASMedia ASM2824 PCIe link
 training failures
In-Reply-To: <20230616202900.GA1540115@bhelgaas>
Message-ID: <alpine.DEB.2.21.2306201040200.14084@angie.orcam.me.uk>
References: <20230616202900.GA1540115@bhelgaas>
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

On Fri, 16 Jun 2023, Bjorn Helgaas wrote:

> I agree that as I rearranged it, the workaround doesn't apply in all
> cases simultaneously.  Maybe not ideal, but maybe not terrible either.
> Looking at it again, maybe it would have made more sense to move the
> pcie_wait_for_link_delay() change to the last patch along with the
> pci_dev_wait() change.  I dunno.

 I think the order of the changes is not important enough to justify 
spending a lot of time and mental effort on it.  You decided, so be it.  
Thank you for your effort made with this review.

 With this series out of the way I have now posted a small clean-up for 
SBR code duplication between PCI core and an InfiniBand driver I came 
across in the course of working on this series.  See 
<https://lore.kernel.org/r/alpine.DEB.2.21.2306200153110.14084@angie.orcam.me.uk/>.

 Please have a look at your convenience.

  Maciej

