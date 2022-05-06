Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D35B51DFAB
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 21:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390984AbiEFTfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 15:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236285AbiEFTfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 15:35:17 -0400
Received: from smtp3.emailarray.com (smtp3.emailarray.com [65.39.216.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FD16E8C6
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 12:31:33 -0700 (PDT)
Received: (qmail 62125 invoked by uid 89); 6 May 2022 19:31:27 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 6 May 2022 19:31:27 -0000
Date:   Fri, 6 May 2022 12:31:26 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com, andrew@lunn.ch,
        hkallweit1@gmail.com, richardcochran@gmail.com, lasse@timebeat.app,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next v3 1/3] net: phy: broadcom: Add Broadcom PTP
 hooks to bcm-phy-lib
Message-ID: <20220506193126.obkbch4ln6w3qnb4@bsd-mbp.dhcp.thefacebook.com>
References: <20220504224356.1128644-1-jonathan.lemon@gmail.com>
 <20220504224356.1128644-2-jonathan.lemon@gmail.com>
 <ed3c3eec-a79d-0d8a-09ad-4a2c6c5507eb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed3c3eec-a79d-0d8a-09ad-4a2c6c5507eb@gmail.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 10:17:29AM -0700, Florian Fainelli wrote:
> On 5/4/22 15:43, Jonathan Lemon wrote:
> > Add the public bcm_ptp_probe() and bcm_ptp_config_init() functions
> > to the bcm-phy library.  The PTP functions are contained in a separate
> > file for clarity, and also to simplify the PTP clock dependencies.
> > 
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> 
> This could really be squashed into the next patch since you do not introduce
> the ability to build that code until patch #3.
> 
> I would also re-order patches #2 and #3 thus making it ultimately a 2 patch
> series only.

Okay, squash #1 and #2 into one patch, then swap ordering so the main
patch comes first.

Will repost in a bit.
-- 
Jonathan
