Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A585541FF
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355050AbiFVFHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347664AbiFVFHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:07:05 -0400
Received: from smtp2.emailarray.com (smtp.emailarray.com [69.28.212.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87AA35A9F
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:07:04 -0700 (PDT)
Received: (qmail 97673 invoked by uid 89); 22 Jun 2022 05:07:03 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 22 Jun 2022 05:07:03 -0000
Date:   Tue, 21 Jun 2022 22:07:01 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next] raw: remove unused variables from
 raw6_icmp_error()
Message-ID: <20220622050701.s2apng5fgxpvp6tf@bsd-mbp.dhcp.thefacebook.com>
References: <20220622032303.159394-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622032303.159394-1-edumazet@google.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 03:23:03AM +0000, Eric Dumazet wrote:
> saddr and daddr are set but not used.
> 
> Fixes: ba44f8182ec2 ("raw: use more conventional iterators")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
