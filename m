Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830ED63B506
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 23:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiK1W5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 17:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiK1W5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 17:57:12 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9752A436
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 14:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=riUMz2JoO3Wk5wQE270/fOYDEjUtIRo/vnvujhBOz1A=; b=IW/JGQG9TWjEh4h85XQK6sqvet
        C8Cyl1CMwC6Zb+xo7yCyifc9IbjN0ulHo6seUOMudzknPkkuqwpW7RGebpRrIM7w8huFjsdqRNCvc
        towmL7awEKHOtLUEPR5UixURX4L2huiA+wXklEQUdB3gyThFcIjV0ks2Cjsv1vm2aEBc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ozn3g-003nmw-Em; Mon, 28 Nov 2022 23:57:04 +0100
Date:   Mon, 28 Nov 2022 23:57:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <shnelson@amd.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io
Subject: Re: [RFC PATCH net-next 10/19] pds_core: devlink params for enabling
 VIF support
Message-ID: <Y4U8wIXSM2kESQIr@lunn.ch>
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-11-snelson@pensando.io>
 <20221128102953.2a61e246@kernel.org>
 <f7457718-cff6-e5e1-242e-89b0e118ec3f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7457718-cff6-e5e1-242e-89b0e118ec3f@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 02:26:26PM -0800, Shannon Nelson wrote:
> On 11/28/22 10:29 AM, Jakub Kicinski wrote:
> > On Fri, 18 Nov 2022 14:56:47 -0800 Shannon Nelson wrote:
> > > +     DEVLINK_PARAM_DRIVER(PDSC_DEVLINK_PARAM_ID_LM,
> > > +                          "enable_lm",
> > > +                          DEVLINK_PARAM_TYPE_BOOL,
> > > +                          BIT(DEVLINK_PARAM_CMODE_RUNTIME),
> > > +                          pdsc_dl_enable_get,
> > > +                          pdsc_dl_enable_set,
> > > +                          pdsc_dl_enable_validate),
> > 
> > Terrible name, not vendor specific.
> 
> ... but useful for starting a conversation.
> 
> How about we add
> 	DEVLINK_PARAM_GENERIC_ID_ENABLE_LM,

I know we are running short of short acronyms and we have to recycle
them, rfc5513 and all, so could you actually use
DEVLINK_PARAM_GENERIC_ID_ENABLE_LIST_MANAGER making it clear your
Smart NIC is running majordomo and will soon replace vger.

      Andrew
