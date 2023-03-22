Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524C06C3F40
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 01:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjCVAo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 20:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjCVAo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 20:44:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E26B2365F;
        Tue, 21 Mar 2023 17:44:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF395B81A3A;
        Wed, 22 Mar 2023 00:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BE7C433EF;
        Wed, 22 Mar 2023 00:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679445892;
        bh=dmONf9oAJL7CG+fsOh3ODEZ9B+5Qk0gXu4GNSV23oJM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iz1DHUUDbFJGo3EVrEQb64uT/3TZMjrryUOUlBPN8jWPPpiQ4IBquttrOJOmv4nKt
         JbMvciWVhS8KtHhhSihLr4n6niJUeM2qIPStuSMwM624F48MqSvRkujUtie/UGsDbS
         VY4q+fADCRW33L3q+qfuBXnVdr+5NYtmBZswmA5lCZB+qEB1jxBVKd+8L1WvNeM0yd
         gkr5wBrlKfCXvCS8SPqZwv0ulZawk3ddtylzxmD9Ggn2y0Xz/vx/CGGbCPqU+p1Cc+
         0ZHhqN1aruz0QU9orEK66xOGh9lg7L/Ax+hLdrsrM+Um+qdY0A/HS3miYBoPBSmiXR
         f53Apmx5X83Kw==
Date:   Tue, 21 Mar 2023 17:44:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Bagas Sanjaya <bagasdotme@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        corbet@lwn.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, pisa@cmp.felk.cvut.cz,
        mkl@pengutronix.de, linux-doc@vger.kernel.org, f.fainelli@gmail.com
Subject: Re: [PATCH net-next v2] docs: networking: document NAPI
Message-ID: <20230321174450.0bd8114f@kernel.org>
In-Reply-To: <20230321100522.474c3763@hermes.local>
References: <20230321050334.1036870-1-kuba@kernel.org>
        <20230321100522.474c3763@hermes.local>
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

On Tue, 21 Mar 2023 10:05:22 -0700 Stephen Hemminger wrote:
> Looks good overall. I used a grammar scanner to look for issues and
> it found lots of little things.

Thanks for that, I folded in all the grammar improvements.
I did not take the larger changes, they lose context / relations,
I prefer the current wording.
