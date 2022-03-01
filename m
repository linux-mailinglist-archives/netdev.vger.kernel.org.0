Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3644C8C51
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 14:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbiCANNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 08:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbiCANNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 08:13:31 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D24AC240B4
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 05:12:50 -0800 (PST)
Received: from [192.168.1.214] (dynamic-089-012-174-087.89.12.pool.telefonica.de [89.12.174.87])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9832E20B7178;
        Tue,  1 Mar 2022 05:12:49 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9832E20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1646140370;
        bh=YzfQ1kFKohbndtZ2Oekn23n750dVmkPlvhNMEma+5aI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=lR6VbERnAFW2v4Ki+4yFCqD8gSazxo/7SjG5/G8ykAQiMRjVUXEGQTXz7dUAwSODF
         XEk/c3Vql2TvyDmAyuOzmn/aDGFb6+Q8+mtfy8FA+honB/MJZm7RU0hrnpEPoJU5wy
         nc0rvLOF33v6iL8FfQgVXf5q3CG8bCM/WFq8BohE=
Subject: Re: [PATCH 2/2] Revert "xfrm: state and policy should fail if
 XFRMA_IF_ID 0"
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eyal Birger <eyal.birger@gmail.com>
References: <447cf566-8b6e-80d2-b20d-c20ccd89bdb9@linux.microsoft.com>
 <924f1394-5fd4-590a-16b4-fb4d60185972@linux.microsoft.com>
 <20220228224332.0cca8d99@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   =?UTF-8?B?S2FpIEzDvGtl?= <kailueke@linux.microsoft.com>
Message-ID: <0d449d5b-e169-cd9f-0731-9a45b25da3cb@linux.microsoft.com>
Date:   Tue, 1 Mar 2022 14:12:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20220228224332.0cca8d99@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
> What's the story here? You posted your patches twice and they look
> white space damaged (tabs replaced by spaces).
yeah, sorry for the spam, now I've set up git send-email and hope it
works ;)
> Does commit 6d0d95a1c2b0
> ("xfrm: fix the if_id check in changelink") which is in net/master now
> solve the issue for you?

I don't think it solves the regression that the kernel now fails
syscalls that use id 0. I reported this to the LTS kernel list and was
told to send it here since it is a regression.

Regards,
Kai

