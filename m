Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E296A61A068
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 19:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiKDS6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 14:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiKDS6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 14:58:38 -0400
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC3863A1
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 11:58:33 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 1613 invoked from network); 4 Nov 2022 19:58:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1667588310; bh=SJPHk8FmWhb5cun3BVSxV/Y24lLTBzmzkpLLqHm+Ml4=;
          h=From:To:Cc:Subject;
          b=pq9veQjHpT9kKYTgX3j9+lTaFhIRr2ozRMoMo3WfdclB+VKwsxggUaA3T0SOUYFrl
           ZnnDeI0t6KtHwLCABdUbqNZLKafXFSBMdJtxrbkybFWjXUf5MnDOxzKPLLlKPLeVpI
           VsDj9PVzSN69Wc8lIXu5XvRh3W2ri3SuFYJT08Yw=
Received: from 89-64-15-29.dynamic.chello.pl (HELO localhost) (stf_xl@wp.pl@[89.64.15.29])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <colin.i.king@gmail.com>; 4 Nov 2022 19:58:29 +0100
Date:   Fri, 4 Nov 2022 19:58:29 +0100
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlegacy: remove redundant variable len
Message-ID: <20221104185829.GA204626@wp.pl>
References: <20221104135036.225628-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104135036.225628-1-colin.i.king@gmail.com>
X-WP-MailID: d61e314174c95f4e2b013d8de70cd0b2
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [sXP0]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 01:50:36PM +0000, Colin Ian King wrote:
> Variable len is being assigned and modified but it is never
> used. The variable is redundant and can be removed.
> 
> Cleans up clang scan build warning:
> warning: variable 'len' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
