Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC0F5FDD3D
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJMPdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiJMPdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:33:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7335289CED;
        Thu, 13 Oct 2022 08:32:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B070B81E4F;
        Thu, 13 Oct 2022 15:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98BBC433C1;
        Thu, 13 Oct 2022 15:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665675175;
        bh=N9dtBbeid/AQkUHbcP83wLXIrRijx2HgAI5RS58u7Cc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SYtt1KflZxR9wMpCim04SVkSYQdU0WbQGen1/vsts/jOhflWO4cD4XlDPoLWt+d5k
         C9Ms6/bGMWjRa6eB7faz3vyV4lABgRepl9hKcJ2NHUXG9zMfreoP0dgpCbvSPUN8gg
         drJgBqf9VDZfRQwl12rUbnLE7ZSZwiVYv9JN8UZHcy3zM3k6U7Bs5TgWIElXdm2PXk
         nleg4EG1IOV+QAHl24XKrFF4bYWPfW8VVKMfBzTrnuo1oJbcGLLPR7DLniHN00ivqh
         qQ9dtpb49rtx92k8nI8Po9frN+zErp69dB6IFg++BQ94JMwzTrXJ2LEuprgbKjqKDt
         Adwx/+2vlYIdg==
Date:   Thu, 13 Oct 2022 08:32:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-2022-10-13
Message-ID: <20221013083254.5d302a5e@kernel.org>
In-Reply-To: <20221013100522.46346-1-johannes@sipsolutions.net>
References: <20221013100522.46346-1-johannes@sipsolutions.net>
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

On Thu, 13 Oct 2022 12:04:51 +0200 Johannes Berg wrote:
> Please pull and let me know if there's any problem.

Since you asked if there are any problems... :)

net/wireless/scan.c:1677:61: warning: incorrect type in argument 2 (different address spaces)
net/wireless/scan.c:1677:61:    expected struct cfg80211_bss_ies const *new_ies
net/wireless/scan.c:1677:61:    got struct cfg80211_bss_ies const [noderef] __rcu *beacon_ies
