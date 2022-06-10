Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4424D5469C1
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349268AbiFJPrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349338AbiFJPrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:47:17 -0400
Received: from smtp8.emailarray.com (smtp8.emailarray.com [65.39.216.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2431E0AFC
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:46:49 -0700 (PDT)
Received: (qmail 23031 invoked by uid 89); 10 Jun 2022 15:46:47 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 10 Jun 2022 15:46:47 -0000
Date:   Fri, 10 Jun 2022 08:46:45 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next v1 1/5] ptp_ocp: use dev_err_probe()
Message-ID: <20220610154645.ujvjvrdqvjwvvwoq@bsd-mbp.dhcp.thefacebook.com>
References: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
 <20220608120358.81147-2-andriy.shevchenko@linux.intel.com>
 <20220609224523.78b6a6e6@kernel.org>
 <YqMmZBEsCv+f19se@smile.fi.intel.com>
 <20220610083918.65f3baeb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610083918.65f3baeb@kernel.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 08:39:18AM -0700, Jakub Kicinski wrote:
> On Fri, 10 Jun 2022 14:09:24 +0300 Andy Shevchenko wrote:
> > I have just checked that if you drop this patch the rest will be still
> > applicable. If you have no objections, can you apply patches 2-5 then?
> 
> It's tradition in netdev to ask people to repost. But looks completely
> safe for me to drop patch 1, so applied 2-5. Don't tell anyone I did this.

I see what you did there.  :)
-- 
Jonathan
