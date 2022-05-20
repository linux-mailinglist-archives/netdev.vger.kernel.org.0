Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3753652E44C
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 07:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345554AbiETFUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 01:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345565AbiETFUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 01:20:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A8FDEA2;
        Thu, 19 May 2022 22:20:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19349B82284;
        Fri, 20 May 2022 05:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830A5C385A9;
        Fri, 20 May 2022 05:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653024045;
        bh=QJiubypnOugW2LWFSMDSWtUO8LuydGdAMAKASRYoeaQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W76Zviaoo1OFn3UwVSvGvmr3oY8rSubrNxk6DsF2FFk5GJwRFvLLiqiJ7NOZExx0F
         hZoWp7CYEQNQtsHYerqBsA5wSGMZgelmJBmWIZS6xcMUunl5BVSHUEra3+0SOKMxPJ
         +jIFb3lme8eOqsT8ddUFtEK1NoRNHR6Q6dQAGzfUSoyfFU1lM0zsfrA3ViU9QfR9tU
         GMWrUdmnrxrAhy+ALWGwI2t0Efi0Nfd+ObX9Le5yMnnsVWFz4dOvwma8f/CPKHU57X
         1+su1eR7qtSvMwbc+OwBJN5Q1+5N7KFO6BLvrAeY8AvniVuSACDYtJWbTEFvxrLnI4
         2QNMEe3QQhtFQ==
Date:   Thu, 19 May 2022 22:20:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20220519222044.1106dbd7@kernel.org>
In-Reply-To: <20220520145957.1ec50e44@canb.auug.org.au>
References: <20220520145957.1ec50e44@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 May 2022 14:59:57 +1000 Stephen Rothwell wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

FWIW just merged the fix, if you pull again you'll get this and a fix
for the netfilter warning about ctnetlink_dump_one_entry().
