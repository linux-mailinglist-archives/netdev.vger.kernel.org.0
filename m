Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717A56BDCAD
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 00:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjCPXIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 19:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCPXIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 19:08:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04E85A1BD;
        Thu, 16 Mar 2023 16:07:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75E2A62153;
        Thu, 16 Mar 2023 23:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690ACC433D2;
        Thu, 16 Mar 2023 23:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679008078;
        bh=6e6A0FbzKl/+Fq86eTjnzj+UME/oZNCvaRQw/cfwckM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c7KMFhUui2LJkJMd2C6N8J3eK/6RqkGaxiOYmKiFZajxd+vEaPSgoWlNCTrkb0KEK
         zg7akYAPW2MXHxN3lkAAaQB8wFMWR8MuYL6SbV9aBfa660Zj0hDtKn1CpkIh7wLpgw
         kbTnZZjQt5zzQYqSHl6pxrc4HSg2XgRh3J6m3oNnM7T1uOBb+h67qO/zLeNPtf80e+
         tfjiUWvZEwqMIRVFfFrfinyR0tZTqURy19MU9Ih4AywS8mBcJzlPEvhI4E2vxtGAKp
         JeOpKCgGxXP04BhgzRMTw5AkSnaFDlGlJk9m5g8iQ9PlPVkj0K3vil3s78QSWqQlr9
         JJKEgn2KRoVbw==
Date:   Thu, 16 Mar 2023 16:07:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, corbet@lwn.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] docs: networking: document NAPI
Message-ID: <20230316160757.52ea01b0@kernel.org>
In-Reply-To: <7ddfa9e1-c7a2-7a62-a2ba-eb2c93a3a2fa@gmail.com>
References: <20230315223044.471002-1-kuba@kernel.org>
        <20230315155202.2bba7e20@hermes.local>
        <20230315161142.48de9d98@kernel.org>
        <7ddfa9e1-c7a2-7a62-a2ba-eb2c93a3a2fa@gmail.com>
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

On Thu, 16 Mar 2023 15:59:49 -0700 Florian Fainelli wrote:
> True, though I would put a word in or two about level vs. edge triggered 
> anyway, if nothing else, explain essentially what Stephen just provided 
> ought to be a good starting point for driver writers to consider the 
> possible issue.

It's not a blocker for something close to the current document
going in, tho, right? More of a future extension (possibly done
by someone else...) ?
