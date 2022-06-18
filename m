Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283E7550241
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383808AbiFRDBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbiFRDBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:01:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DD96C557;
        Fri, 17 Jun 2022 20:01:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6ACF61F43;
        Sat, 18 Jun 2022 03:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A40C3411B;
        Sat, 18 Jun 2022 03:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655521292;
        bh=esT+EY763V71Pumcl+zfF4U16AJdmGYDqb7VxSEiijQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ee4WQPbj6nKJmFoN7a7/a3ju4zh6yvTSggpuAen/cp/vDNq3ujkMy1oJwiZg/jKgM
         UyDcYDCkv+KYvsEvk3ebnUz8kLk6dYBhUYh9pcKPo3unZ2oBiu6IzEeXIWoh4rkW9e
         vDEwSTOKlxM6WWUeB1f9zk8MZejW6z+5qDfmRbBNa6rUGIz8aQiWpOmv2dnEfWdRSu
         yvZWN1zLb6oICuUk/7XrBb2D0ryjrHX8EatJoi4MkGQ7Gh9rWrdU915H2QY8UvJns7
         pLqVmpPkTnt4pLz4zwNERLzsGpKIQtUH2yJjCc2qlHgLmsoo4XdlSscg9qLydieeJD
         4Ktn5pa9Q8U7A==
Date:   Fri, 17 Jun 2022 20:01:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     HighW4y2H3ll <huzh@nyu.edu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Fix buffer overflow in
 hinic_devlink.c:hinic_flash_fw
Message-ID: <20220617200130.7ef96a66@kernel.org>
In-Reply-To: <20220617050101.37620-1-huzh@nyu.edu>
References: <20220617050101.37620-1-huzh@nyu.edu>
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

On Fri, 17 Jun 2022 01:01:02 -0400 HighW4y2H3ll wrote:
> Subject: [PATCH v2] Fix buffer overflow in hinic_devlink.c:hinic_flash_fw
> Date: Fri, 17 Jun 2022 01:01:02 -0400
> X-Mailer: git-send-email 2.35.1
> 
> Signed-off-by: zhenghao hu <huzh@nyu.edu>

Please describe in the commit message what the buffer overflow is, so
we don't have to reverse engineer your change.

Also please add a Fixes tag pointing at a commit which introduced the
bug.
