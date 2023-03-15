Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A516BA9B4
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbjCOHrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbjCOHr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:47:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844476287B
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:46:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22CFA61B51
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EE0C433EF;
        Wed, 15 Mar 2023 07:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678866406;
        bh=KlhxqZAaoKqxnmf9QAp3ifH/+DCZ13heodeX4P3qVBQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Aw83fwL/tCbfH0DLS5xYiHriVDhcfyQn3vDTqq4MjQm3MfLBIRi5Bg4HFaBIxUast
         GKoxjbQAvn7IQU9ZBEXyigep52sJUy2Ms55285ysAuUBkvmvMCP2FBHyYdKuT2G6NG
         3Ay8yM6qYe1aOF+fs0Nsm14kZ0dnO+Ul24FDdWSxbLvskpnrA9EqkeVWwGhWZyHZGV
         JuxA4tKd/wYj9K9L7a5XGgTJqmsOKMyU4Yu0Mekyjhgs0bsD8v7vN9mGZ7kbVG5Zqi
         WCSCO3vLUbwj91BWqaOF0Q2BAfePRtypKRBIIi138CineBSlBSUmOSfKiudD/ffgvR
         Pcw7D9SwW4n+A==
Date:   Wed, 15 Mar 2023 00:46:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>
Subject: Re: [PATCH iproute2 1/2] Revert "tc: m_action: fix parsing of
 TCA_EXT_WARN_MSG"
Message-ID: <20230315004645.2420c581@kernel.org>
In-Reply-To: <20230314070449.1533298-1-liuhangbin@gmail.com>
References: <20230314065802.1532741-1-liuhangbin@gmail.com>
        <20230314070449.1533298-1-liuhangbin@gmail.com>
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

On Tue, 14 Mar 2023 15:04:49 +0800 Hangbin Liu wrote:
> This reverts commit 70b9ebae63ce7e6f9911bdfbcf47a6d18f24159a.
> 
> The TCA_EXT_WARN_MSG is not sit within the TCA_ACT_TAB hierarchy. It's
> belong to the TCA_MAX namespace. I will fix the issue in another patch.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Double check the posting format if it's not just a slip up:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#co-posting-changes-to-user-space-components
