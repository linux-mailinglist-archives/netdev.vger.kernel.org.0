Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED9C6BA682
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 06:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjCOFJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 01:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjCOFJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 01:09:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFB2303D1;
        Tue, 14 Mar 2023 22:09:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE33D61AE1;
        Wed, 15 Mar 2023 05:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBAEC433EF;
        Wed, 15 Mar 2023 05:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678856966;
        bh=7p1RRx9+XkDkqvizYy0bDO5wuozBvMSp7CyYMO1H56M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SQVUyhCdLQ2YCdAQVPt1rxwEqkJiWgtZc3mySReH40HdOwD1Ee5OpgR9g8O9a2iin
         oiUDpnAptNWTQJBMWQ9XuFZbjFMdGAc/boJ7WdiHAamwE4tbLx0qrUQgNZfdaegqt6
         DS7NCF/W3rdHMyxyrGD67oNfRZbqZotsWKJdgDoyQxdl2GmCP6ai+/Esl2sW96dw9T
         KJH29KtiIS+XpT5IgxRTZ5jlErQPRpLuKhkD9hXSAmZwwNQ4+3pgsK9z3XZX34Bkae
         Ewg52wUON0DaFuD4vIkYW37g6ZU40k1iWHxuz/txORyTtLZqAotqDCynXdFm7pt2uu
         iKGBHGcOI7w0g==
Date:   Tue, 14 Mar 2023 22:09:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, stephen@networkplumber.org,
        simon.horman@corigine.com, sinquersw@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH v3 net-next 2/2] net: introduce budget_squeeze to help
 us tune rx behavior
Message-ID: <20230314220924.52dfb803@kernel.org>
In-Reply-To: <20230314131427.85135-3-kerneljasonxing@gmail.com>
References: <20230314131427.85135-1-kerneljasonxing@gmail.com>
        <20230314131427.85135-3-kerneljasonxing@gmail.com>
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

On Tue, 14 Mar 2023 21:14:27 +0800 Jason Xing wrote:
> When we encounter some performance issue and then get lost on how
> to tune the budget limit and time limit in net_rx_action() function,
> we can separately counting both of them to avoid the confusion.

More details please, we can't tell whether your solution makes sense 
if we don't know what your problem is.
