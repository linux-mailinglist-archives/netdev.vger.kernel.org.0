Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3E46652E3
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbjAKEis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjAKEiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:38:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E19F7640
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:38:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 547BC61A01
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 04:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDB0C433D2;
        Wed, 11 Jan 2023 04:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673411889;
        bh=m0QxS7p5R7MHqwe3h7H/l/mwpgIpGCN7DDx9W8slLlA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F1eLYp/9TtPDb4sC8J5YROK7S9xGe3gHLHD4oleiXt3dtgiVsMSiUOZYmgbrgeiNk
         ZhCD0+NBztjEOHwHoT3ID0Gi7YDVHih1JA/f0xXwccUoztgDXWL45pdQZ+bdhjrew4
         R0loayXxd5YJgNKopeP7R80ACQSLBKUROaeRs8YpAes3cF8clqiZLwpK30nSwgcVzX
         0YGvNLhY1AcqiVZHQ+AZhcmzjO8fHeM0qrzCBA8g6gbkFGAAw18+iNS+FK/VHxrPcd
         mldaGhGbo4m5wtOs4QcU4B/e4t8fE1mWdp29Vp3Hbn/le3mqOwmlhIj/hgxQ8KRLL1
         eEo0EazieMQUA==
Date:   Tue, 10 Jan 2023 20:38:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Bin Chen <bin.chen@corigine.com>,
        Xingfeng Hu <xingfeng.hu@corigine.com>
Subject: Re: [PATCH net-next 2/2] nfp: add DCB IEEE configuration process
Message-ID: <20230110203808.2952931d@kernel.org>
In-Reply-To: <20230110123542.46924-3-simon.horman@corigine.com>
References: <20230110123542.46924-1-simon.horman@corigine.com>
        <20230110123542.46924-3-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Jan 2023 13:35:42 +0100 Simon Horman wrote:
> Basic completion of DCB support, including ETS and other functions.
> Implemented DCB IEEE callbacks in order to add or remove DSCP to
> user priority mapping and added DCB IEEE bandwidth percentage checks.

Can you say something about the use case? Some example configurations?

> /* Copyright (C) 2020 Netronome Systems, Inc. */
> /* Copyright (C) 2021 Corigine, Inc. */

Please sanitize the copyright.

Please squash the two patches. The first one is just noise.
