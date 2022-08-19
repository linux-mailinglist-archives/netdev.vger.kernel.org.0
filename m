Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25F059A8B3
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 00:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238516AbiHSWd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 18:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiHSWd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 18:33:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F23C2F3A9
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 15:33:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35CCEB8296B
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 22:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706D0C433D7;
        Fri, 19 Aug 2022 22:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660948432;
        bh=DEFl2nG7x6eQoIjCBqhhNmfAM8XA856gMSjkzrOzPI4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HGgEsGZ9Ai42LoKqqSxumJNqOeC+11HpQi/IHAqYU5wDGzuVvrsjXe/ieqxrtlawZ
         Bq1l7AwoLejGYlXSAiqYiftE9beAvQBpsifwHgAicCED5JBV0MAb3TN4LXgTS+8RC8
         KG9FxzHO6TuK3ImQBFeQY3K51NLO5jetOTymsjX8+GgMvYMjLICvWhTUknQM8gkbmK
         Ayin6ty8lkN4n4EsoW8rJZLT1Mi7hYNavVwLwRljXaB/2NIiKCb7rbgqdBjhS6j78k
         53GDIVkzBSQrVAkiDiSOmmDwcpxvRU79ceLA5XaxDaLB6ycVRblfdkhalEAPVfqNJt
         MKQlh/n5CLhnw==
Date:   Fri, 19 Aug 2022 15:33:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
Cc:     Ilpo =?UTF-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
        m.chetan.kumar@intel.com, Netdev <netdev@vger.kernel.org>,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        Haijun Liu <haijun.liu@mediatek.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
Subject: Re: [PATCH net-next 2/5] net: wwan: t7xx: Infrastructure for early
 port configuration
Message-ID: <20220819153351.228ea04e@kernel.org>
In-Reply-To: <4c5dbea0-52a9-1c3d-7547-00ea54c90550@linux.intel.com>
References: <20220816042340.2416941-1-m.chetan.kumar@intel.com>
        <5a74770-94d3-f690-4aa1-59cdbbb29339@linux.intel.com>
        <1ff95a2c-c648-aea2-be23-0d4bf8a9b3d7@linux.intel.com>
        <63bdb859-eda-5488-60b8-fc305ea39f31@linux.intel.com>
        <4c5dbea0-52a9-1c3d-7547-00ea54c90550@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 14:56:25 +0530 Kumar, M Chetan wrote:
> >> Prototype is added in header file. Patch4 is using this func.  
> > 
> > Thus, put those two changes (proto + static removal) into patch 4.  
> 
> Patch is merged.
> Please help to get it revert so that we could address review comments 
> and post v2 series.

Done! Normally I'd post the revert patch publicly but the build bot 
has been murdered by all the giant series from yesterday so what's 
the point :/
