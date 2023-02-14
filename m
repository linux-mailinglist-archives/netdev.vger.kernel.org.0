Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E596955E5
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 02:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjBNBYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 20:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjBNBYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 20:24:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94FA13DD3;
        Mon, 13 Feb 2023 17:24:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E6246123E;
        Tue, 14 Feb 2023 01:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D1CC433EF;
        Tue, 14 Feb 2023 01:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676337839;
        bh=4Mg73KO/6cnO9s5+bxHqJ1nhg+DkXONIRoBCiQYuFG0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S0lPTVdGcQq9UEpG0S0VSKk9ZppZ3KQwdSZj/Ms7UKIJW3dJxOXlL2P46ZpIjW5eZ
         ikOl8h6gjob9d0EPAepUN1T3JiQ7r69KQld79rn/ZowE7yfah0E5cWFTw1gIx/6rJ5
         1kUoDiLg0fXFY52HcFLZFTkvd1dq6HIc9esTkJJVOA8ivxBxg//DLb9EfrYnPGGuPk
         KZ/Wkem38AYw1nG3pJPskZpirWOAVwmcuWuRqjCikP2UYGtFuKeKn0ypMQYHoAHIbo
         H8RuR5uwS2oQoKMaRdLtJ98MpSbqAtS4KRpXFn6yu+HD6VwT3zNNF+GFtA07e4xDi5
         rvY8je6ksYrnw==
Date:   Mon, 13 Feb 2023 17:23:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, anthony.l.nguyen@intel.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, edumazet@google.com,
        pabeni@redhat.com, davem@davemloft.net, jesse.brandeburg@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH bpf-next] ice: update xdp_features with xdp multi-buff
Message-ID: <20230213172358.7df0f07c@kernel.org>
In-Reply-To: <b564473cdefc82bda9a3cecd3c15538a418e8ad2.1675941199.git.lorenzo@kernel.org>
References: <b564473cdefc82bda9a3cecd3c15538a418e8ad2.1675941199.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Feb 2023 12:17:25 +0100 Lorenzo Bianconi wrote:
> Now ice driver supports xdp multi-buffer so add it to xdp_features.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Let me take this one in directly the same as the other xdp_feature
follow ups.
