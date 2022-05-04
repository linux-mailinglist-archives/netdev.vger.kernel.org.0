Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA1351ACEF
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 20:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351649AbiEDSiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 14:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377101AbiEDSh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 14:37:59 -0400
Received: from smtp7.emailarray.com (smtp7.emailarray.com [65.39.216.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A283DE37
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 11:26:52 -0700 (PDT)
Received: (qmail 17621 invoked by uid 89); 4 May 2022 18:26:51 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 4 May 2022 18:26:51 -0000
Date:   Wed, 4 May 2022 11:26:48 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com
Subject: Re: [PATCH net-next] net: Make msg_zerocopy_alloc static
Message-ID: <20220504182648.vtozalqnvoso7kpq@bsd-mbp.dhcp.thefacebook.com>
References: <20220504170947.18773-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504170947.18773-1-dsahern@kernel.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 10:09:47AM -0700, David Ahern wrote:
> msg_zerocopy_alloc is only used by msg_zerocopy_realloc; remove the
> export and make static in skbuff.c
> 
> Signed-off-by: David Ahern <dsahern@kernel.org>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
