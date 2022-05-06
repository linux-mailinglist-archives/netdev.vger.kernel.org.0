Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BB651E1E4
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444897AbiEFXGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 19:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444895AbiEFXGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 19:06:21 -0400
Received: from smtp3.emailarray.com (smtp3.emailarray.com [65.39.216.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453C750463
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 16:02:37 -0700 (PDT)
Received: (qmail 40033 invoked by uid 89); 6 May 2022 23:02:35 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 6 May 2022 23:02:35 -0000
Date:   Fri, 6 May 2022 16:02:34 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org,
        mlichvar@redhat.com, willemb@google.com, kafai@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 4/6] ptp: Support late timestamp determination
Message-ID: <20220506230234.ig3qru6qbqxgfvjm@bsd-mbp.dhcp.thefacebook.com>
References: <20220506200142.3329-1-gerhard@engleder-embedded.com>
 <20220506200142.3329-5-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506200142.3329-5-gerhard@engleder-embedded.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 10:01:40PM +0200, Gerhard Engleder wrote:
> If a physical clock supports a free running cycle counter, then
> timestamps shall be based on this time too. For TX it is known in
> advance before the transmission if a timestamp based on the free running
> cycle counter is needed. For RX it is impossible to know which timestamp
> is needed before the packet is received and assigned to a socket.
> 
> Support late timestamp determination by a network device. Therefore, an
> address/cookie is stored within the new netdev_data field of struct
> skb_shared_hwtstamps. This address/cookie is provided to a new network
> device function called ndo_get_tstamp(), which returns a timestamp based
> on the normal/adjustable time or based on the free running cycle
> counter. If function is not supported, then timestamp handling is not
> changed.
> 
> This mechanism is intended for RX, but TX use is also possible.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
