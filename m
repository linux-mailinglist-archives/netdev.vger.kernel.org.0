Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C68615B8A
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 05:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiKBElJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 00:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKBElH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 00:41:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA111F9EA;
        Tue,  1 Nov 2022 21:41:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF2F8B82076;
        Wed,  2 Nov 2022 04:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3AEC433D6;
        Wed,  2 Nov 2022 04:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667364060;
        bh=2YFUn2JSHEIJC8rttfornK0CiHOqI7uarCx8amIS/TQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s8qKyM2RSP6cBMiSVfbwAoFjqhGaNjKxT5DSDVPYkuxKktOU1bPnjVIIb20mtnZLl
         0oFE3SvEldxG/wYW3QZb2LkKyUMN1uzBSrGaRHo4Hp3in5Z9e8WEAZ//Priuv8IGMv
         e/baPBY0s9G/b22eqCxtW7BXhQymgy6IqWHH/z4lc8KltUob5C1NY6cCEebPCvGWHw
         ENwxmXFOmCWqz2o3pFNrjg6dv0I9Fm/I0Py68RWX50QN8+ZQx4C+gEZVK4guElTmW3
         dvFqpiDFsNflLBFKwk7HWZFp3JyNFwxjUCNdteGuxVa3Q+dUOisp6QZk16f6bjB/3u
         qmEVX8615rTEg==
Date:   Tue, 1 Nov 2022 21:40:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Qiao Ma <mqaio@linux.alibaba.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: hinic: Add support for configuration of
 rx-vlan-filter by ethtool
Message-ID: <20221101214059.464a1d42@kernel.org>
In-Reply-To: <20221031074715.44224-1-cai.huoqing@linux.dev>
References: <20221031074715.44224-1-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Oct 2022 15:47:03 +0800 Cai Huoqing wrote:
> When ethtool config rx-vlan-filter: 'ethtool -K ethx rx-vlan-filter on/off'
> to turn on/off the vlan filter, the driver will send control command to firmware,
> then set to hardware in this patch.

This patch depends on a definition added in your other set.
Please repost once that gets merged, otherwise it doesn't build.
