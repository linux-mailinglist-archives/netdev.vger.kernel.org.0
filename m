Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A4157098E
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 19:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiGKRyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 13:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiGKRyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 13:54:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C393245F;
        Mon, 11 Jul 2022 10:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2E12B80E4A;
        Mon, 11 Jul 2022 17:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518D9C34115;
        Mon, 11 Jul 2022 17:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657562076;
        bh=bfDpL4/4HVSdNr3hJZNx6A+csj4wVPDBMcOvqKJIdGA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nkcoaRiSChvpS6R1BJte8tDgTjMM4Q3GkMYdjve5kf5vOsa+x8T6RsfpH8if+cbwP
         2OdJU/U2lz7LfPBcPFH+0zh81/ptacUtRcZxbiSqnMoJVfHkpv9I1BFujo/KrEq2aT
         MqjFWAC54tPnUtKGtQtFMiF0Eo70hGtXEvtlYRIwOK4qpeOrUM/JYy5xRCdq7mXaQJ
         S/1IGQVu+Pq+p7gDLonhnvCSZOTMRmxrHYnYTFzyxKmWqgpeS1FoXmqS1bvjdntBSW
         2wT5jQr6W14dMuwMmc4iA+kt6G/uGlyrvOpEE9RnCW5uLDkovLGsWnPLjjsKQnNEFj
         v4IiHJRCw/uCw==
Date:   Mon, 11 Jul 2022 10:54:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [EXT] Re: [net-next PATCH v5 00/12] octeontx2: Exact Match
 Table.
Message-ID: <20220711105427.3f91cd86@kernel.org>
In-Reply-To: <MWHPR1801MB19181C17D9825E6BE412D1EDD3879@MWHPR1801MB1918.namprd18.prod.outlook.com>
References: <20220708044151.2972645-1-rkannoth@marvell.com>
        <165747732320.1773.1868461985348849288.git-patchwork-notify@kernel.org>
        <MWHPR1801MB19181C17D9825E6BE412D1EDD3879@MWHPR1801MB1918.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jul 2022 05:08:05 +0000 Ratheesh Kannoth wrote:
> Cloned bpf-next.git master today (7/11 IST) and could not find these
> patches (v5). Am I missing anything ?

I think pw-bot got confused and matched the v2 that just made its way
to the bpf-next tree against this series. There's an unfortunate
but necessary fuzziness in how the pw-bot matches patches and trees.

I'm applying the patches to net-next now.
