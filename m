Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB09685EA6
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 05:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjBAE6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 23:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjBAE6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 23:58:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F89F34015
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 20:58:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFA7BB82035
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 04:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387F9C433EF;
        Wed,  1 Feb 2023 04:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675227495;
        bh=ioUAGe7N0faKIUNxBewk4hArzyMNJZT6s1/Z1Q7beEQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZHOUAvKoX/5+WSaCiyrVVFAn+6Qnx2tp0ZC0I9p4N0VKKKz8ICyDZPw+ipRvwlyKe
         SkbLc1K6+VUlMeQyXHpoYY3U2tBHBX14T4yjSMw6wxPIDu+xwgDlZIW4uWDXVvMwLH
         watjxF0LmyIO7woEL6fr93/fMdkDiEn3DN8mEFhB9JpaTzdRSJ9d8BJn86JepRv9uE
         KRTOnqIM4w3JSGVbJkVbSiPDSUTSWZXxsiTuKaxlZkMfcd8jaouUNSx9mQvLRpp0dn
         NWO435whno9XWwtcLw/MvLGc7OmvAgPL6oz2Eq/dN8dD3l5rquEpu62WBXBNf6bL9S
         5th7jnDYaZfJg==
Date:   Tue, 31 Jan 2023 20:58:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geoff Levand <geoff@infradead.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        John 'Warthog9' Hawley <warthog9@kernel.org>
Subject: Re: [PATCH net v3 0/2] ps3_gelic_net: DMA related fixes
Message-ID: <20230131205814.7acdd758@kernel.org>
In-Reply-To: <cover.1675042362.git.geoff@infradead.org>
References: <cover.1675042362.git.geoff@infradead.org>
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

On Mon, 30 Jan 2023 01:37:54 +0000 Geoff Levand wrote:
> v3: Cleaned up patches as requested.

These did not make it to the list, again.

Once again - please make sure that the patches are minimal.
You're adding unnecessary debug prints and reshuffling code,
which is not acceptable for a fix.
