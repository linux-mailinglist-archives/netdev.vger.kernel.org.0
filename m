Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8B0234CF5
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 23:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgGaVZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 17:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbgGaVZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 17:25:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECE9C061574;
        Fri, 31 Jul 2020 14:25:46 -0700 (PDT)
Received: from localhost (50-47-102-2.evrt.wa.frontiernet.net [50.47.102.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F34111E45903;
        Fri, 31 Jul 2020 14:08:57 -0700 (PDT)
Date:   Fri, 31 Jul 2020 14:25:38 -0700 (PDT)
Message-Id: <20200731.142538.868196979893920242.davem@davemloft.net>
To:     ioanaruxandra.stancioi@gmail.com
Cc:     david.lebrun@uclouvain.be, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, elver@google.com, glider@google.com,
        stancioi@google.com
Subject: Re: [PATCH v2] seg6_iptunnel: Refactor seg6_lwt_headroom out of
 uapi header
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200731074032.293456-1-ioanaruxandra.stancioi@gmail.com>
References: <20200731074032.293456-1-ioanaruxandra.stancioi@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Jul 2020 14:08:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana-Ruxandra Stancioi <ioanaruxandra.stancioi@gmail.com>
Date: Fri, 31 Jul 2020 07:40:32 +0000

> --- a/net/ipv6/seg6_iptunnel.c
> +++ b/net/ipv6/seg6_iptunnel.c
> @@ -27,6 +27,23 @@
>  #include <net/seg6_hmac.h>
>  #endif
>  
> +static inline size_t seg6_lwt_headroom(struct seg6_iptunnel_encap *tuninfo)
> +{

Please remove the inline tag when you move the function here, we do
not use the inline keyword in foo.c files.

Thank you.
