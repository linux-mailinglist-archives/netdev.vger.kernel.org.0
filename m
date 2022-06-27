Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C615755C15B
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238018AbiF0TYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 15:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237249AbiF0TYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 15:24:03 -0400
Received: from smtp3.emailarray.com (smtp3.emailarray.com [65.39.216.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537F264F9
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:24:02 -0700 (PDT)
Received: (qmail 19566 invoked by uid 89); 27 Jun 2022 19:23:56 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 27 Jun 2022 19:23:56 -0000
Date:   Mon, 27 Jun 2022 12:23:54 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>, Vadim Fedorenko <vadfed@fb.com>,
        Aya Levin <ayal@nvidia.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v1 3/3] ptp_ocp: implement DPLL ops
Message-ID: <20220627192354.pyy2lcyy4aiz6s4l@bsd-mbp.dhcp.thefacebook.com>
References: <20220623005717.31040-1-vfedorenko@novek.ru>
 <20220623005717.31040-4-vfedorenko@novek.ru>
 <20220623182813.safjhwvu67i4vu3b@bsd-mbp.dhcp.thefacebook.com>
 <80568c10-2d73-2a68-aed6-a553ae2410f8@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80568c10-2d73-2a68-aed6-a553ae2410f8@novek.ru>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 26, 2022 at 08:27:17PM +0100, Vadim Fedorenko wrote:
> On 23.06.2022 19:28, Jonathan Lemon wrote:
> > On Thu, Jun 23, 2022 at 03:57:17AM +0300, Vadim Fedorenko wrote:
> > > From: Vadim Fedorenko <vadfed@fb.com>
> > > 
> > > +static int ptp_ocp_dpll_get_status(struct dpll_device *dpll)
> > > +{
> > > +	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
> > > +	int sync;
> > > +
> > > +	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
> > > +	return sync;
> > > +}
> > 
> > Please match existing code style.
> > 
> 
> Didn't get this point. The same code is used through out the driver.
> Could you please explain?

Match existing function definition style.
-- 
Jonathan
