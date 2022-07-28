Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38F3583740
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 05:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbiG1DCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 23:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiG1DCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 23:02:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A7754AC6;
        Wed, 27 Jul 2022 20:02:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 405FBB821CE;
        Thu, 28 Jul 2022 03:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2610C433D6;
        Thu, 28 Jul 2022 03:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658977363;
        bh=XwRJ1dFB53N4ry3mAiywmtVGp8m8odHvbf1KbCZu52c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uKugulAKxdQxOuccvluTBZRqSS/SZFpFsldymHrY70Z2BMgFwDGe/X3iPj6ZFQgGE
         sxW3nmd20GrWVURdELLXvKSh7QznoZZwavQp1PoNN03tRS4eheYNesuDXbauNJh18h
         5f03Kcwd/eab2mDgd+W2B8utjppPGb7UgQFjCzlKCwY7tDv/ofoG/gtE7IpRSXecXD
         BD0kjyEKVLh0lgMwtC+4P0kU3dVEWCbeVgG1sY9HqJ/G6ndbTarLv30SbTDPrtv3v/
         DPg8ieal8eWUzc7mahDq4OAoCY+xyTAG5a4ilVAy1P8LsLn6jp28EF+dBcJhx2LZwx
         ATJr9QHTB5Yxw==
Date:   Wed, 27 Jul 2022 20:02:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     RuffaloLavoisier <ruffalolavoisier@gmail.com>
Cc:     Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/amt.c : fix typo
Message-ID: <20220727200241.703361c4@kernel.org>
In-Reply-To: <20220727165640.132955-1-RuffaloLavoisier@gmail.com>
References: <20220727165640.132955-1-RuffaloLavoisier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 01:56:40 +0900 RuffaloLavoisier wrote:
> Subject: [PATCH] drivers/net/amt.c : fix typo

Please take a look at subject lines of changes to this code:

git log --oneline --  drivers/net/amt.c

and use a similar prefix rather than spelling out the full file path.
Please also mention in the subject that that typo is in a comment.

> Correct spelling on non-existent

s/on/of/
