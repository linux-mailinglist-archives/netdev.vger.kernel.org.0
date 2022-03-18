Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDB04DDD23
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 16:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238260AbiCRPke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 11:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238248AbiCRPkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 11:40:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DDB3F8A1;
        Fri, 18 Mar 2022 08:39:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9905E60E0A;
        Fri, 18 Mar 2022 15:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DC4C340E8;
        Fri, 18 Mar 2022 15:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647617954;
        bh=R8ebpoqjNhXu1rNFBgcZHsertzVaDf5gOdcyrtK6Bxg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=DvCdj0pfHPJr8oVMLRZmVbsuj/dtOhL1LaynNXxmzbJsT6qZUQJtX2wuOjKV7dneD
         hGOvRJd3o+6RR9UDGdHM+OPxK+TsBBW3aZH6He7ayYVAZjOwUDieFNcj2tULt7CclH
         HOqQyuNHRG3uNgj42k3e0qtOcKMfbr+w1hGPwMfuffKzxd9n6Vna83gbZT42tz4ya8
         f4iFw+wsxbztJJsP59rXqzxu2gdrIGdlQPdo50m9lfX3UMASGjr3rsP3PgO+8tMXW8
         guKymKAHWoMMBpw8QNwlD56HyYiw4ZF7sdKH/MwGy0gF9gqnZzEwSzJt+sdWBqbu3M
         YrJ3dTcz5c9GA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 03/30] ath6kl: fix typos in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220314115354.144023-4-Julia.Lawall@inria.fr>
References: <20220314115354.144023-4-Julia.Lawall@inria.fr>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164761795038.655.6145250258303604942.kvalo@kernel.org>
Date:   Fri, 18 Mar 2022 15:39:12 +0000 (UTC)
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Julia Lawall <Julia.Lawall@inria.fr> wrote:

> Various spelling mistakes in comments.
> Detected with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

b7d174479c8a ath6kl: fix typos in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220314115354.144023-4-Julia.Lawall@inria.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

