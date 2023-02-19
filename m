Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70CC69C203
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 19:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbjBSSxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 13:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjBSSxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 13:53:05 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 05046149A9;
        Sun, 19 Feb 2023 10:52:32 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id D739892009C; Sun, 19 Feb 2023 19:52:21 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id CFF5892009B;
        Sun, 19 Feb 2023 18:52:21 +0000 (GMT)
Date:   Sun, 19 Feb 2023 18:52:21 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
        Oliver O'Halloran <oohall@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lukas Wunner <lukas@wunner.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Stefan Roese <sr@denx.de>, Jim Wilson <wilson@tuliptree.org>,
        David Abdurachmanov <david.abdurachmanov@gmail.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PING][PATCH v6 0/7] pci: Work around ASMedia ASM2824 PCIe link
 training failures
In-Reply-To: <alpine.DEB.2.21.2302022022230.45310@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2302191849230.25434@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2302022022230.45310@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 5 Feb 2023, Maciej W. Rozycki wrote:

>  This is v6 of the change to work around a PCIe link training phenomenon 
> where a pair of devices both capable of operating at a link speed above 
> 2.5GT/s seems unable to negotiate the link speed and continues training 
> indefinitely with the Link Training bit switching on and off repeatedly 
> and the data link layer never reaching the active state.

 Ping for: 
<https://lore.kernel.org/linux-pci/alpine.DEB.2.21.2302022022230.45310@angie.orcam.me.uk/>.

  Maciej
