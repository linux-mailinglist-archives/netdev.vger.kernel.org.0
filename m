Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE97511914
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbiD0Nw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 09:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236704AbiD0Nw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 09:52:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0DE4F527DC;
        Wed, 27 Apr 2022 06:49:40 -0700 (PDT)
Date:   Wed, 27 Apr 2022 15:49:36 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Oz Shlomo <ozsh@nvidia.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Blakey <paulb@nvidia.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: conn: fix udp offload timeout sysctl
Message-ID: <YmlJ8Oa1mjwUHpfl@salvia>
References: <1651057740-12713-1-git-send-email-volodymyr.mytnyk@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1651057740-12713-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 02:09:00PM +0300, Volodymyr Mytnyk wrote:
> `nf_flowtable_udp_timeout` sysctl option is available only
> if CONFIG_NFT_FLOW_OFFLOAD enabled. But infra for this flow
> offload UDP timeout was added under CONFIG_NF_FLOW_TABLE
> config option. So, if you have CONFIG_NFT_FLOW_OFFLOAD
> disabled and CONFIG_NF_FLOW_TABLE enabled, the
> `nf_flowtable_udp_timeout` is not present in sysfs.
> Please note, that TCP flow offload timeout sysctl option
> is present even CONFIG_NFT_FLOW_OFFLOAD is disabled.
> 
> I suppose it was a typo in commit that adds UDP flow offload
> timeout and CONFIG_NF_FLOW_TABLE should be used instead.

Applied, thanks
