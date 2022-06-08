Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 174BF542908
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 10:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiFHIOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 04:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbiFHIM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 04:12:26 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 311852D3B11;
        Wed,  8 Jun 2022 00:41:17 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 2587YfRW007669;
        Wed, 8 Jun 2022 09:34:41 +0200
Date:   Wed, 8 Jun 2022 09:34:41 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Moshe Kol <moshe.kol@mail.huji.ac.il>
Cc:     kernel test robot <oliver.sang@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com, ying.huang@intel.com,
        feng.tang@intel.com, zhengjun.xing@linux.intel.com,
        fengwei.yin@intel.com
Subject: Re: [tcp] e926147618: stress-ng.icmp-flood.ops_per_sec -8.7%
 regression
Message-ID: <20220608073441.GE7547@1wt.eu>
References: <20220608060802.GA22428@xsang-OptiPlex-9020>
 <20220608064822.GC7547@1wt.eu>
 <CACi_AuAr70bDB79zg9aAF1rD7e1qGgFwCGCAPYtS-zCp_zA0iw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACi_AuAr70bDB79zg9aAF1rD7e1qGgFwCGCAPYtS-zCp_zA0iw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 08, 2022 at 10:26:12AM +0300, Moshe Kol wrote:
> Hmm, How is the ICMP flood stress test related to TCP connections?

To me it's not directly related, unless the test pre-establishes many
connections, or is affected in a way or another by a larger memory
allocation of this part.

Willy
