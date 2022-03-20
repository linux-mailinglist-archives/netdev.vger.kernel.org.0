Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898304E1D38
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 18:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245741AbiCTRl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 13:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiCTRl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 13:41:58 -0400
X-Greylist: delayed 506 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 20 Mar 2022 10:40:35 PDT
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B879192373;
        Sun, 20 Mar 2022 10:40:34 -0700 (PDT)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4KM4Yx48lbz1qy4d;
        Sun, 20 Mar 2022 18:32:05 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4KM4Yw6JJxz1qqkC;
        Sun, 20 Mar 2022 18:32:04 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id AZNAXHq-zqdT; Sun, 20 Mar 2022 18:32:03 +0100 (CET)
X-Auth-Info: PRG5CVsyc2awA5undKWlsYbTr46vvzvy3CjZzJKLMMmL+/aS5lMla6dWJ55goAm+
Received: from igel.home (ppp-46-244-164-143.dynamic.mnet-online.de [46.244.164.143])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 20 Mar 2022 18:32:03 +0100 (CET)
Received: by igel.home (Postfix, from userid 1000)
        id 68B1B2C3A4A; Sun, 20 Mar 2022 18:32:03 +0100 (CET)
From:   Andreas Schwab <schwab@linux-m68k.org>
To:     John Crispin <john@phrozen.org>
Cc:     trix@redhat.com, toke@toke.dk, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: initialize arrays at compile time
References: <20220320152028.2263518-1-trix@redhat.com>
        <af6042d0-952f-f497-57e7-37fef45a1f76@phrozen.org>
X-Yow:  I'm using my X-RAY VISION to obtain a rare glimpse of the
 INNER WORKINGS of this POTATO!!
Date:   Sun, 20 Mar 2022 18:32:03 +0100
In-Reply-To: <af6042d0-952f-f497-57e7-37fef45a1f76@phrozen.org> (John
        Crispin's message of "Sun, 20 Mar 2022 17:48:31 +0100")
Message-ID: <87a6dko7ho.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mär 20 2022, John Crispin wrote:

> If I recall correctly { 0 } will only set the first element of the
> struct/array to 0 and leave random data in all others elements

An initializer always initializes the _whole_ object.

The subject is also wrong, all initializers are executed at run time
(automatic variables cannot be initialized at compile time).

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
