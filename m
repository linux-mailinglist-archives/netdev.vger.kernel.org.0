Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE2F60CA97
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbiJYLF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbiJYLFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:05:24 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C2DE7AB3D;
        Tue, 25 Oct 2022 04:05:12 -0700 (PDT)
Date:   Tue, 25 Oct 2022 13:05:08 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Michael Lilja <michael.lilja@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] Periodically flow expire from flow offload tables
Message-ID: <Y1fC5K0EalIYuB7Y@salvia>
References: <20221023171658.69761-1-michael.lilja@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221023171658.69761-1-michael.lilja@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Oct 23, 2022 at 07:16:58PM +0200, Michael Lilja wrote:
> When a flow is added to a flow table for offload SW/HW-offload
> the user has no means of controlling the flow once it has
> been offloaded. If a number of firewall rules has been made using
> time schedules then these rules doesn't apply for the already
> offloaded flows. Adding new firewall rules also doesn't affect
> already offloaded flows.
>
> This patch handle flow table retirement giving the user the option
> to at least periodically get the flow back into control of the
> firewall rules so already offloaded flows can be dropped or be
> pushed back to flow offload tables.
> 
> The flow retirement is disabled by default and can be set in seconds
> using sysctl -w net.netfilter.nf_flowtable_retire

How does your ruleset look like? Could you detail your usecase?

Thanks.
