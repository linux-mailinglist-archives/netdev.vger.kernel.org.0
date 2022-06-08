Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E82A543F11
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 00:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbiFHWUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 18:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiFHWUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 18:20:49 -0400
Received: from smtp7.emailarray.com (smtp7.emailarray.com [65.39.216.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05F5E4
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 15:20:45 -0700 (PDT)
Received: (qmail 87584 invoked by uid 89); 8 Jun 2022 22:20:43 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 8 Jun 2022 22:20:43 -0000
Date:   Wed, 8 Jun 2022 15:20:41 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next v1 1/5] ptp_ocp: use dev_err_probe()
Message-ID: <20220608222041.a63mn2g4m4l572nq@bsd-mbp.dhcp.thefacebook.com>
References: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
 <20220608120358.81147-2-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608120358.81147-2-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 08, 2022 at 03:03:54PM +0300, Andy Shevchenko wrote:
> Simplify the error path in ->probe() and unify message format a bit
> by using dev_err_probe().

Line length.
-- 
Jonathan
