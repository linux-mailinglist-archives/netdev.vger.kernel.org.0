Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954416BF7CF
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 05:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjCREwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 00:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjCREwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 00:52:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A204DBD0
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 21:52:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2D3A6068E
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 04:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8D4C433EF;
        Sat, 18 Mar 2023 04:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679115149;
        bh=E72n6PaRuyO/6nbFK5Qk/7oP3L08DkRj7Zo4HvvN9KY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bQ8CmJramRwhEtvWypjCNHImpTEiGyuE46fj3zgsjxJP6jbP5oMa/JYKkG+D1LRZ5
         WIaWmvuJx6fT2KEhkfUT2o3AGfcI3HPycSXepCbtjn008sr3CW/N4y4oNHdSPkggVr
         oxM/oVhBmbgBx1WrGVahLon5q6slQjSV6eoA5pnxi8BVJYVyr6q6GqO+oXi6V/5yr8
         XYYLQAXj/PCMYgFyy99QdUaWJAE8EdySn3PBUf7t3VP7ZWYc6Ba3ELx2JA/Uzv7WlB
         speYrLfGgFLnbJBVBhtsPRHmD3+2WbjEwRJaKW/6fie7AZICumegkAgdCxBiwuS5nj
         Q40qpFp5DSZaQ==
Date:   Fri, 17 Mar 2023 21:52:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, donald.hunter@redhat.com
Subject: Re: [PATCH net-next v1 2/2] netlink: specs: add partial
 specification for openvswitch
Message-ID: <20230317215228.68ad300a@kernel.org>
In-Reply-To: <20230316120142.94268-3-donald.hunter@gmail.com>
References: <20230316120142.94268-1-donald.hunter@gmail.com>
        <20230316120142.94268-3-donald.hunter@gmail.com>
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

On Thu, 16 Mar 2023 12:01:42 +0000 Donald Hunter wrote:
> +user-header: ovs_header

Let's place this attr inside 'operations'?

also s/_/-/ everywhere, we try to use - as a separator in the spec, 
the C codegen replaces it with underscores
