Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A09E95E69BA
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 19:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbiIVRhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 13:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbiIVRhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 13:37:17 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E33EF8C28
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 10:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7UEFosOPRfmsvHJOaH+4ito6MmAUDszfZkTEo3Pto50=; b=bDlysktnvawtdL8bDRdNtfTYnJ
        uuKLjNiQNpU1q+nmqEtO3IanlXj2sM8NOGioQmcy2+60hsRdMcFQX3GC1jKjndOiHWYcQJTL8/NAA
        /gfBn1JVdeS9ynON0gnBfyE81Z8BOtMwzYHGDHAmtT86eZMUEuPgXuWH42qZjbAqLhoA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obQ8K-00HYWG-AR; Thu, 22 Sep 2022 19:37:08 +0200
Date:   Thu, 22 Sep 2022 19:37:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Diana Wang <na.wang@corigine.com>,
        Peng Zhang <peng.zhang@corigine.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: driver uABI review list? (was: Re: [PATCH/RFC net-next 0/3] nfp:
 support VF multi-queues configuration)
Message-ID: <YyydRHGFm/M6rSP5@lunn.ch>
References: <20220920151419.76050-1-simon.horman@corigine.com>
 <20220921063448.5b0dd32b@kernel.org>
 <YyyHg/lvzXHKNPe9@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyyHg/lvzXHKNPe9@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 07:04:19PM +0300, Leon Romanovsky wrote:
> On Wed, Sep 21, 2022 at 06:34:48AM -0700, Jakub Kicinski wrote:
> > On Tue, 20 Sep 2022 16:14:16 +0100 Simon Horman wrote:
> > > this short series adds the max_vf_queue generic devlink device parameter,
> > > the intention of this is to allow configuration of the number of queues
> > > associated with VFs, and facilitates having VFs with different queue
> > > counts.
> 
> <...>
> 
> > Would it be helpful for participation if we had a separate mailing 
> > list for discussing driver uAPI introduction which would hopefully 
> > be lower traffic?
> 
> Please don't. It will cause to an opposite situation where UAPI
> discussions will be hidden from most people. IMHO, every net vendor
> should be registered to netdev mailing list and read, review and
> participate.

Good in theory, but how often do you really see it happen?

How many vendor developers really do review other vendors drivers
patches. It tends to be vendor neutral reviewers who do reviews across
multiple vendors. I wish there was more cross vendor review, it would
prevent having to repeat the same review comments again and again.
There is probably also a lot of good ideas in some drivers which
should be spread to other drivers. But if you don't look outside your
silo, you are blind to them.

However, i do agree, although netdev is not perfect, i think it is
better than another list which will get even more ignored.

      Andrew
