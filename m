Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B205282BC
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 12:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbiEPK7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 06:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiEPK7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 06:59:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 438452B1BC;
        Mon, 16 May 2022 03:59:18 -0700 (PDT)
Date:   Mon, 16 May 2022 12:59:15 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf 1/4] netfilter: flowtable: fix excessive hw offload
 attempts after failure
Message-ID: <YoIug8uAJTidiGw9@salvia>
References: <20220509122616.65449-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220509122616.65449-1-nbd@nbd.name>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Series applied to nf.git
