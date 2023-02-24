Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D016A144F
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 01:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjBXA3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 19:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBXA3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 19:29:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F578695
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 16:29:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3E30617CF
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 00:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20AEC433D2;
        Fri, 24 Feb 2023 00:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677198550;
        bh=ZKXNYZvG9s8Bc0dHuERti0T5nUtHHzNcWALxCrSE5jI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SIROqfKja77aCZh291FE/R8D0S9EEbKRVVXRDk9l7bXDJDS1wa1QAyZ59usjV/7at
         GkLRjreOACUFpwUVq/l7bNTZmxsB16zlQKHsUmYB9EmqtxHnB9JsFzf/ogK9mf5V9Q
         Oykeyf7Zn86pxvcrefffcOC79crxZBZm3Xjbz4sMfRmUTsc+eUfum8S3DnQ3vJZX1H
         hiUSl0VSJYMJ15wC0eR1vsKKbt8sXYGY5mKc8fc2HhSiLyoXEh2vBEdeCZa1LdIe2K
         ZKnao3eidwmDSF4PoCuN7w+AGGMqekdlr4z1naqojDl1ctMYvAjhky8mO5OsosiJKV
         +bw/JQHIC0KLw==
Date:   Thu, 23 Feb 2023 16:29:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next V2 0/4] mlx5 technical debt of hairpin params
Message-ID: <20230223162908.5203d787@kernel.org>
In-Reply-To: <20230222230202.523667-1-saeed@kernel.org>
References: <20230222230202.523667-1-saeed@kernel.org>
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

On Wed, 22 Feb 2023 15:01:58 -0800 Saeed Mahameed wrote:
> Sorry for the late submission, I know we are on merge window, and in case you
> don't plan to submit further pull requests to liuns, then maybe it's a good
> idea to take only the first patch (revert debugfs) and push it through your
> next net PR.

SG, let me do that.
