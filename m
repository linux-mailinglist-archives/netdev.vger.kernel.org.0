Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACAF538650
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 18:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbiE3Qsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 12:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235406AbiE3Qso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 12:48:44 -0400
Received: from smtp3.emailarray.com (smtp3.emailarray.com [65.39.216.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725CE26573
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 09:48:42 -0700 (PDT)
Received: (qmail 77057 invoked by uid 89); 30 May 2022 16:48:41 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 30 May 2022 16:48:41 -0000
Date:   Mon, 30 May 2022 09:48:39 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, kernel-team@fb.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [PATCH net-next v5 0/2] Broadcom PTP PHY support
Message-ID: <20220530164839.3ptms5ieq6y44mf5@bsd-mbp.dhcp.thefacebook.com>
References: <20220518223935.2312426-1-jonathan.lemon@gmail.com>
 <20220528032712.GA26100@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220528032712.GA26100@hoboy.vegasvil.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 27, 2022 at 08:27:12PM -0700, Richard Cochran wrote:
> On Wed, May 18, 2022 at 03:39:33PM -0700, Jonathan Lemon wrote:
> > This adds PTP support for the Broadcom PHY BCM54210E (and the
> > specific variant BCM54213PE that the rpi-5.15 branch uses).
> 
> I'm interested in this series.  Can you please include me on CC?

Sure thing!  (I thought I had already, if not, it was an unintentional
oversight.)
-- 
Jonathan
