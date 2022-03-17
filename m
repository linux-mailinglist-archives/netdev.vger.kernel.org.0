Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D994DCC01
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 18:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236756AbiCQRGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 13:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiCQRGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 13:06:11 -0400
Received: from smtp1.emailarray.com (smtp1.emailarray.com [65.39.216.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A4E19EC7D
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 10:04:53 -0700 (PDT)
Received: (qmail 1343 invoked by uid 89); 17 Mar 2022 17:04:52 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 17 Mar 2022 17:04:52 -0000
Date:   Thu, 17 Mar 2022 10:04:49 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] ptp: ocp: fix sprintf overflow in
 ptp_ocp_verify()
Message-ID: <20220317170449.qxcf4yi4rzlgbwzu@bsd-mbp.dhcp.thefacebook.com>
References: <20220317075957.GF25237@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317075957.GF25237@kili>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 10:59:57AM +0300, Dan Carpenter wrote:
> The "chan" value comes from the user via sysfs.  A large like UINT_MAX
> could overflow the buffer by three bytes.  Make the buffer larger and
> use snprintf() instead of sprintf().
> 
> Fixes: 1aa66a3a135a ("ptp: ocp: Program the signal generators via PTP_CLK_REQ_PEROUT")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

This needs to be respun to catch up with the last patch.
-- 
Jonathan
