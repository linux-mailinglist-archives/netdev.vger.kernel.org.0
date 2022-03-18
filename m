Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC644DDF22
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239251AbiCRQfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239250AbiCRQez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:34:55 -0400
Received: from smtp4.emailarray.com (smtp4.emailarray.com [65.39.216.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA35E232D20
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:33:34 -0700 (PDT)
Received: (qmail 73806 invoked by uid 89); 18 Mar 2022 16:33:32 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 18 Mar 2022 16:33:32 -0000
Date:   Fri, 18 Mar 2022 09:33:31 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 net-next] ptp: ocp: use snprintf() in ptp_ocp_verify()
Message-ID: <20220318163331.yabbgis2u57vp3cu@bsd-mbp.dhcp.thefacebook.com>
References: <20220318074723.GA6617@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318074723.GA6617@kili>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 10:47:23AM +0300, Dan Carpenter wrote:
> This code is fine, but it's easier to review if we use snprintf()
> instead of sprintf().
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
