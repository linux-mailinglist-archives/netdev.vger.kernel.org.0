Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91ED96CF31C
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 21:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbjC2TYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 15:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbjC2TYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 15:24:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2C3125
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 12:24:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27043B82420
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 19:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8B9C4339B;
        Wed, 29 Mar 2023 19:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680117863;
        bh=1re4Q5568WMPEjtXfKNyfYjoxvK32C4ppODRRoQOEw4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nbjmvhn4gqIfQH2qBWpbk250xiKHJFBtaYh5LUTGKtIGrbONj5fe5tmmYGoMEeR5g
         3RmSo7/mgZpeuPqGopbWa7pvsr9Ug2Uq1cUpOTdEJ2wu0cS68G+bwARcKB+UzJOrU6
         1rbNNRH5SVfHwn5JxhjRoZd5R1RUq6WuQ/CeG4a+i3rx9s5uG2Wq0+K7cIZNEfhJ/v
         WcvFOzz8j0yoOAyFGWjEvLRnm+W41hUpZZx+2FXbhGHcxvLM8l7XJSmQb7AHMeUaG5
         yd8rf8zJuHp7sCX7CYn7pWX+iqRZJK7cyMdIl4yCFuP8nS31hEYLhmRWubp4+6zMxA
         8GVC33CAI0qfw==
Date:   Wed, 29 Mar 2023 12:24:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Louis Peens <louis.peens@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>
Subject: Re: [PATCH net-next 2/2] nfp: separate the port's upper state with
 lower phy state
Message-ID: <20230329122422.52f305f5@kernel.org>
In-Reply-To: <20230329144548.66708-3-louis.peens@corigine.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
        <20230329144548.66708-3-louis.peens@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 16:45:48 +0200 Louis Peens wrote:
> For nic application firmware, enable the ports' phy state at the
> beginning. And by default its state doesn't change in pace with
> the upper state, unless the ethtool private flag "link_state_detach"
> is turned off by:
> 
>  ethtool --set-private-flags <netdev> link_state_detach off
> 
> With this separation, we're able to keep the VF state up while
> bringing down the PF.

This commit message is very confusing. Please rewrite it.
