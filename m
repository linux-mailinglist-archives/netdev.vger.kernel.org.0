Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD60A6D8BA2
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 02:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbjDFAVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 20:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbjDFAVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 20:21:08 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0135E6598;
        Wed,  5 Apr 2023 17:21:02 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 8960792009C; Thu,  6 Apr 2023 02:20:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 8201792009B;
        Thu,  6 Apr 2023 01:20:59 +0100 (BST)
Date:   Thu, 6 Apr 2023 01:20:59 +0100 (BST)
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
Subject: [PATCH v8 0/7] pci: Work around ASMedia ASM2824 PCIe link training
 failures
Message-ID: <alpine.DEB.2.21.2304060100160.13659@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=0.0 required=5.0 tests=HDRS_LCASE,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

 This is v8 of the change to work around a PCIe link training phenomenon 
where a pair of devices both capable of operating at a link speed above 
2.5GT/s seems unable to negotiate the link speed and continues training 
indefinitely with the Link Training bit switching on and off repeatedly 
and the data link layer never reaching the active state.

 This version adds a Reviewed-by: tag by Lukas Wunner accidentally missed 
from 6/7 in v7 and reorders said change to the front of the series.

 Last two iterations: 
<https://lore.kernel.org/r/alpine.DEB.2.21.2304042200040.37565@angie.orcam.me.uk/>
<https://lore.kernel.org/r/alpine.DEB.2.21.2302022022230.45310@angie.orcam.me.uk/>.

  Maciej
