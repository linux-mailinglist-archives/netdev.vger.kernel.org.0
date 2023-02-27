Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7926A4BD0
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjB0T7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjB0T7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:59:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0084116313
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 11:59:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 906F960F2C
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 19:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2FEC4339C;
        Mon, 27 Feb 2023 19:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677527940;
        bh=LKB+3gy7XGrVHXDPPp4Jl/A9LMNMBY8A/wNokKGkav0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lt7HKZoORyUqt2/OHKH5Y4qOQC45uYJrNQ0eplmciC0t+46iixJgOARJ+q/LTc6b4
         Ll9W03qJhSx6ZFG1JZ/9Z2tp3ksyiO9LYnz065EL8atPtuONMUaG9nyyW7BM6B2kxj
         o5IGHWY2U67QRI+2JyHlsQbEhAM6ji66Q/745TJaBUAdZypHcyxTACjCP2DLwQ/vJw
         ggPJ7sE1mDuIESyTD9h+IJ0bHAti0kAMmpZZXBEJp6w8sL6XL1BJD1ay6sJe/44+E0
         xbtiXGpe3xjr6/+c7iqrU89XYC4FqRU/Np3Dlo8ffcTCWTVbfyLdaB9GzTc753LX7s
         4qnNjBx+v1LOw==
Date:   Mon, 27 Feb 2023 11:58:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH net 1/1] ice: remove unnecessary CONFIG_ICE_GNSS
Message-ID: <20230227115858.72c0ecd9@kernel.org>
In-Reply-To: <20230224213241.4025978-1-anthony.l.nguyen@intel.com>
References: <20230224213241.4025978-1-anthony.l.nguyen@intel.com>
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

On Fri, 24 Feb 2023 13:32:41 -0800 Tony Nguyen wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> CONFIG_ICE_GNSS was added by commit c7ef8221ca7d ("ice: use GNSS subsystem
> instead of TTY") as a way to allow the ice driver to optionally support
> GNSS features without forcing a dependency on CONFIG_GNSS.
> 
> The original implementation of that commit at [1] used IS_REACHABLE. This
> was rejected by Olek at [2] with the suggested implementation of
> CONFIG_ICE_GNSS.
> 
> Eventually after merging, Linus reported a .config which had
> CONFIG_ICE_GNSS = y when both GNSS = n and ICE = n. This confused him and
> he felt that the config option was not useful, and commented about it at
> [3].

Applied, thanks!
