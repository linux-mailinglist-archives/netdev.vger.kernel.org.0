Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343BA58E851
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiHJIAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiHJH76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 03:59:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D51ED74DD3;
        Wed, 10 Aug 2022 00:59:57 -0700 (PDT)
Date:   Wed, 10 Aug 2022 09:59:54 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net 0/8] Netfilter fixes for net
Message-ID: <YvNleukoUWZlJdxU@salvia>
References: <20220809220532.130240-1-pablo@netfilter.org>
 <20220809212714.2cfca6c9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220809212714.2cfca6c9@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 09, 2022 at 09:27:14PM -0700, Jakub Kicinski wrote:
> On Wed, 10 Aug 2022 00:05:24 +0200 Pablo Neira Ayuso wrote:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD
> 
> That is not the tree you want me to pull from. Mumble, mumble.

Right, one of my computers was running an old version of the script.

Sorry about this.
