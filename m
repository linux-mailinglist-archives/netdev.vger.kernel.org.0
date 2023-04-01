Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79BCC6D2E08
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 06:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbjDAEIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 00:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjDAEII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 00:08:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D879F1A963;
        Fri, 31 Mar 2023 21:08:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5FFAB83351;
        Sat,  1 Apr 2023 04:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC67AC433EF;
        Sat,  1 Apr 2023 04:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680322082;
        bh=mWLsJLLjP6Eoqm+yaZoozYUFiJRpPmTtDchffr52rqY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=icwU41XPxMq9mLqQqSCPHTuWTV7Xt6wwrcylXqXX+0KVTpzTxw5TMBXZwHlvgcdqQ
         oBcsP8ihCbP6hUO8OkICOkz6p4qaqUYiywzmGuazH3aYJqBQOwLhKaKd2v92Rd2G7n
         Yqxqj21TUJqntyslWbaWBZsn0pEApsK8AEZL84pSc23ktHp1LnG/IcUiHQ4kHGYbB/
         kA1XhhffJB4f2IN7CZ6DgoOKGKUIqg/jOkVuy+nuBywouLHGWNtLuuuCDYajrtg08t
         LUBFHp4/XZrXwOzBDSMDoTcDUXdsmZ19GIX4bWoF8ld8qzYNMgRziTXQa26YGLdk3j
         PlVrxO5mCVqFQ==
Date:   Fri, 31 Mar 2023 21:08:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 1/6] netlink: Reverse the patch which removed
 filtering
Message-ID: <20230331210800.41b85b2d@kernel.org>
In-Reply-To: <20230331235528.1106675-2-anjali.k.kulkarni@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
        <20230331235528.1106675-2-anjali.k.kulkarni@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 16:55:23 -0700 Anjali Kulkarni wrote:
> To use filtering at the connector & cn_proc layers, we need to enable
> filtering in the netlink layer. This reverses the patch which removed
> netlink filtering.
> 
> Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
