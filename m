Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB1351097D
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 22:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245668AbiDZUIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 16:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241568AbiDZUIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 16:08:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFC8156E11;
        Tue, 26 Apr 2022 13:05:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3A5661B24;
        Tue, 26 Apr 2022 20:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B57BC385A0;
        Tue, 26 Apr 2022 20:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651003527;
        bh=QWgul7HAB1RcDGdmXdnICZZRpH60irXzWM9/XdJ5fwA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QPds3CSf+Z7dsxqXbOs7fJ46K7Th0dd+1zhD5ngQ16n4orKG6TB7ShXVinLmzpWkA
         fhO1+/yYLDCsdANre//TIXf2ik/bsocj0iuHF8SmJR4W6cT/gCyjMQ1CyjsP5aeBPd
         lqWevR2B12AhoKhe6noGZ1rz/6jbIf5fy4t0Kf9OneTmy2Jk5XV/JYFfqAO5kg9C+3
         yf5T8u//fqad5b4VOhYDYz/rYeZrqy/F2IAh2qCL13X9K+mhbDW+7SPO1jytPC9vvm
         nYVDSCbT6UKhDtsr9wGMzdxdEkEYE6BxDNYiMgwh5H7jImmtELi4r+AYjISFZLT5lG
         1TI9blZkYJxZA==
Date:   Tue, 26 Apr 2022 13:05:26 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: Remove useless kfree
Message-ID: <20220426200526.erhfmwlm62vaz7jc@sx1>
References: <1650607713-23409-1-git-send-email-baihaowen@meizu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1650607713-23409-1-git-send-email-baihaowen@meizu.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22 Apr 14:08, Haowen Bai wrote:
>After alloc fail, we do not need to kfree.
>
>Signed-off-by: Haowen Bai <baihaowen@meizu.com>
applied to net-next-mlx5, thanks!


