Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8AE5541FC
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344776AbiFVFFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348446AbiFVFFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:05:39 -0400
Received: from smtp8.emailarray.com (smtp8.emailarray.com [65.39.216.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D37435A90
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:05:38 -0700 (PDT)
Received: (qmail 82237 invoked by uid 89); 22 Jun 2022 05:05:36 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 22 Jun 2022 05:05:36 -0000
Date:   Tue, 21 Jun 2022 22:05:35 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>, Vadim Fedorenko <vadfed@fb.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] MAINTAINERS: Add a maintainer for OCP Time Card
Message-ID: <20220622050535.625rvflingtpg4li@bsd-mbp.dhcp.thefacebook.com>
References: <20220621233131.21240-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621233131.21240-1-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 02:31:31AM +0300, Vadim Fedorenko wrote:
> From: Vadim Fedorenko <vadfed@fb.com>
> 
> I've been contributing and reviewing patches for ptp_ocp driver for
> some time and I'm taking care of it's github mirror. On Jakub's
> suggestion, I would like to step forward and become a maintainer for
> this driver. This patch adds a dedicated entry to MAINTAINERS.
> 
> Signed-off-by: Vadim Fedorenko <vadfed@fb.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
