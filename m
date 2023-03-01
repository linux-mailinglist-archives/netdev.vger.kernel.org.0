Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61F16A723A
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 18:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjCARmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 12:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjCARmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 12:42:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0727D41092
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 09:42:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB5B1B810B2
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 17:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202EBC433EF;
        Wed,  1 Mar 2023 17:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677692527;
        bh=zTIM24EO39IAtDZPZaCJn8MO4DMhqI5a7Sk2qKhw1pk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xk2Q8acGmc0+nGsN0nASodKhvYAlEvE3inEXQdVAo3lmI/pmL9NnU+AvfnADWq9qC
         TUbOJCn2zwC00wzfL8KpyM+bm3pMqSnvX7gbxLgG5Av7AV8nXJLs1kbmUD8Si5QJ5q
         8FDUElb2laXJpmVhqsmi78MjiJFnPYryrJUTP02msT9M9PnZQ+nvAP6H8mSlwF3J9j
         IFl0Ny2LUqI5hbV32JfMSkhCU4ozVv1ke11fv0dkhguJXInUD8BvkLW8b3s5Y0LYxr
         xsD+cvDrhMIRnnLIAl+7gG+Ih8XMTwzn0K5WwhlzM2Lnim7Q8MfE5++kWV5UvNCu1O
         TgJZcfPXKIyXg==
Date:   Wed, 1 Mar 2023 09:42:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     ismail bouzaiene <ismailbouzaiene@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        "edumazet@google.com" <edumazet@google.com>, pabeni@redhat.com,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] net : fix adding same ip rule multiple times
Message-ID: <20230301094206.6a624a51@kernel.org>
In-Reply-To: <CAPagGtuJQO5dj=qd96kWFWLfcX8Pt0m9B9J8xiFGPNUfEnPLkA@mail.gmail.com>
References: <CAPagGtuJQO5dj=qd96kWFWLfcX8Pt0m9B9J8xiFGPNUfEnPLkA@mail.gmail.com>
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

On Wed, 1 Mar 2023 14:50:15 +0100 ismail bouzaiene wrote:
> Hello,
> 
> In case we try to add the same ip rule multiple times, the kernel will
> reject the addition using the call rule_exits().

This is not the correct way of posting a patch, please take a look at
this (second result on Google BTW):

http://nickdesaulniers.github.io/blog/2017/05/16/submitting-your-first-patch-to-the-linux-kernel-and-responding-to-feedback/

Please also read:

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
and
https://www.kernel.org/doc/html/latest/process/submitting-patches.html
