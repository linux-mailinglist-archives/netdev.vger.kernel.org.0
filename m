Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D466BA623
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 05:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjCOEYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 00:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjCOEYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 00:24:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3E836453
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 21:24:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45D5D61AA5
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FD1C433D2;
        Wed, 15 Mar 2023 04:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678854268;
        bh=9NXadeyaK4+4S0dBehuPU4KPMI0qYl5JdBBvUaYPQKk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AyLjc+TOrkpZsytxM4v/HeWWwj5BA8OG49tQoRvluHz8H/+U5hJNF+nX3T7JtvEXf
         4hjkZUsRwdghpvdPe5sa7oW0pXbsNPBrnDgisG+kCX4PWWUJtdPT7fhsWwOZiYsNQY
         McQDABfPTzEgqvpU3FUsITK4BlFFgkilcbM4sIccCZK+d+AULMSkQutUzBvVTuTiaN
         RPaW6ZQafXf4oOFJ+CFyQUuiumGLRxpc3ePORx+CjDmrSE+HhFPgDbElWDfmKkc6AA
         P9jh7fjYJYB4ECeeSSgsQZzc1UGLb598qDI5NGXhOHqKvw/U7JU14WhB2di2TeCjen
         odhuADzDt0HDQ==
Date:   Tue, 14 Mar 2023 21:24:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next] ethtool: add netlink support for rss set
Message-ID: <20230314212427.123be0ee@kernel.org>
In-Reply-To: <IA1PR11MB62665C2D537234726DAF87D9E4BE9@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20230309220544.177248-1-sudheer.mogilappagari@intel.com>
        <20230309232126.7067af28@kernel.org>
        <IA1PR11MB62665336B2FE611635CC61A3E4B99@IA1PR11MB6266.namprd11.prod.outlook.com>
        <20230313155302.73ca491d@kernel.org>
        <1710d769-4f11-22d7-938d-eda0133a2d62@gmail.com>
        <IA1PR11MB62665C2D537234726DAF87D9E4BE9@IA1PR11MB6266.namprd11.prod.outlook.com>
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

On Tue, 14 Mar 2023 23:51:00 +0000 Mogilappagari, Sudheer wrote:
> How to get devname to be WILDCARD_DEVNAME ?

Isn't it just \* ?

$ ethtool \*
