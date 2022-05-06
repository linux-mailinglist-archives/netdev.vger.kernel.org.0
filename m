Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BE051E1C6
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384665AbiEFXHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 19:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343967AbiEFXHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 19:07:14 -0400
Received: from smtp3.emailarray.com (smtp3.emailarray.com [65.39.216.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C723A6D959
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 16:03:29 -0700 (PDT)
Received: (qmail 40904 invoked by uid 89); 6 May 2022 23:03:28 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 6 May 2022 23:03:28 -0000
Date:   Fri, 6 May 2022 16:03:27 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org,
        mlichvar@redhat.com, willemb@google.com, kafai@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 6/6] tsnep: Add free running cycle counter
 support
Message-ID: <20220506230327.6csbkzsxilpo5adn@bsd-mbp.dhcp.thefacebook.com>
References: <20220506200142.3329-1-gerhard@engleder-embedded.com>
 <20220506200142.3329-7-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506200142.3329-7-gerhard@engleder-embedded.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 10:01:42PM +0200, Gerhard Engleder wrote:
> The TSN endpoint Ethernet MAC supports a free running counter
> additionally to its clock. This free running counter can be read and
> hardware timestamps are supported. As the name implies, this counter
> cannot be set and its frequency cannot be adjusted.
> 
> Add free running cycle counter support based on this free running
> counter to physical clock. This also requires hardware time stamps
> based on that free running counter.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
