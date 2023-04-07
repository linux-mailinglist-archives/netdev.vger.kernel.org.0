Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D246DA84C
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 06:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbjDGEkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 00:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjDGEj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 00:39:59 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DDB901C
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 21:39:58 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id E720F67373; Fri,  7 Apr 2023 06:39:53 +0200 (CEST)
Date:   Fri, 7 Apr 2023 06:39:53 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        shiraz.saleem@intel.com, emil.s.tantilov@intel.com,
        willemb@google.com, decot@google.com, joshua.a.hay@intel.com,
        Christoph Hellwig <hch@lst.de>, michael.orr@intel.com,
        anjali.singhai@intel.com
Subject: Re: [Intel-wired-lan] [PATCH net-next 00/15] Introduce IDPF driver
Message-ID: <20230407043953.GA5852@lst.de>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com> <ZCV6fZfuX5O8sRtA@nvidia.com> <20230330102505.6d3b88da@kernel.org> <ZCXVE9CuaMbY+Cdl@nvidia.com> <5d0439a6-8339-5bbd-c782-123a1aad71ed@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d0439a6-8339-5bbd-c782-123a1aad71ed@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FYI, thanks to Michael for the feedback.

> As explained in the Charter, Intel & Google are donating the current
> Vendor driver & its spec to the IDPF TC to serve as a starting point for
> an eventual vendor-agnostic Spec & Driver that will be the OASIS IDPF
> standard set.

Having both under the same name seems like a massive confusion.
