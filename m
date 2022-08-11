Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E215658F663
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 05:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbiHKD2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 23:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiHKD2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 23:28:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69577E00E;
        Wed, 10 Aug 2022 20:28:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CC576129E;
        Thu, 11 Aug 2022 03:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4DAC433C1;
        Thu, 11 Aug 2022 03:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660188526;
        bh=7ZcyDT71ThpRzB15Rd8LOtp9CKDfo8Oui9lkQfmlBI0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Kj3wr/QdzKj0RBGcXnYTGDk3zjpVLMsxn9RfqUE2HLfJgm+olo77mBws0hZG1Ku6f
         Cf6ND48Q52UAiSs9qjNpfZidnyr1nCAGNiQtO0FURL510++Rfb1OK/894VofgLggkr
         V/lADFMmPGoauUgQiOWJ0UeKZgBDNlQLJMAQEQ/eZQuNRy92qNONpQaBMYYpWMyX7t
         ViS3Jo5NK6aOsXwUKuDexbXI0WZwphq8kKph9A1fPzYWV36T7sOTIuU1AVvkbl1NJV
         6v36bQg6SkV78e94jZpQzXyLISQhxCyOuvvmTVFFXg5c42RzFcxWIY72YzEQmz0WbQ
         MqjU/vHLXHb6w==
Date:   Wed, 10 Aug 2022 20:28:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 00/10] net/smc: optimize the parallelism of
 SMC-R connections
Message-ID: <20220810202845.164eb470@kernel.org>
In-Reply-To: <cover.1660152975.git.alibuda@linux.alibaba.com>
References: <cover.1660152975.git.alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Aug 2022 01:47:31 +0800 D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> This patch set attempts to optimize the parallelism of SMC-R connections,
> mainly to reduce unnecessary blocking on locks, and to fix exceptions that
> occur after thoses optimization.

net-next is closed until Monday, please see the FAQ.

Also Al Viro complained about the SMC ULP:

https://lore.kernel.org/all/YutBc9aCQOvPPlWN@ZenIV/

I didn't see any responses, what the situation there?
