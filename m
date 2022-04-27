Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E4F512023
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240470AbiD0P4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240310AbiD0P4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:56:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D871761603;
        Wed, 27 Apr 2022 08:53:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78C65B8268B;
        Wed, 27 Apr 2022 15:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EF1C385A7;
        Wed, 27 Apr 2022 15:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074796;
        bh=BDKIiD9beLvivRREVaE3Jra+TQ7wcfAfvUf5BKdrx3o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NHZyxSV/PaMA6rFvtES5a6sKGOE4AI8nLSEjo963Ibxx7jhUrqcLlqNka2LbJ6XhA
         8I69YdXN0WgssO8TlfSK7ybno6G4kRu4P3FiJLBZenBbjzoVBO2I1n6/viRieo0LOF
         cRbTbIYtDwf+ZL/2231H/b6VpoUaVjrq2RRIweUM39D4gQc2i73qVsVElYbRp2OcOe
         +2vtHk3/QeVEqmRILhNtyqaOFZCsSv90uC11SZmWyebWWOU/5vj+2zdt5JdYSYZS06
         DPpwFeolOJmZwRw+22shZX12v/hpReLVNUjrD0z39prNJiue7/M02raWxh2CVi9HLJ
         cbBJMSz+CWC9A==
Date:   Wed, 27 Apr 2022 08:53:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "chi.minghao@zte.com.cn" <chi.minghao@zte.com.cn>,
        "toke@redhat.com" <toke@redhat.com>,
        "chenhao288@hisilicon.com" <chenhao288@hisilicon.com>,
        "moyufeng@huawei.com" <moyufeng@huawei.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH net-next 03/14] eth: cpsw: remove a copy of the
 NAPI_POLL_WEIGHT define
Message-ID: <20220427085314.326be7d0@kernel.org>
In-Reply-To: <20220427154702.fbpxfjp4h7ey5ea2@skbuf>
References: <20220427154111.529975-1-kuba@kernel.org>
        <20220427154111.529975-4-kuba@kernel.org>
        <20220427154702.fbpxfjp4h7ey5ea2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Apr 2022 15:47:03 +0000 Vladimir Oltean wrote:
> On Wed, Apr 27, 2022 at 08:41:00AM -0700, Jakub Kicinski wrote:
> > Defining local versions of NAPI_POLL_WEIGHT with the same
> > values in the drivers just makes refactoring harder.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> > CC: grygorii.strashko@ti.com
> > CC: chi.minghao@zte.com.cn
> > CC: vladimir.oltean@nxp.com  
> 
> Fine with me (I mean, I don't even know why I'm copied on cpsw changes).

get_maintainer, I didn't bother filtering this time

> Why is the weight even an argument to netif_napi_add() anyway?

Right, not sure, see the cover letter.
