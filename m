Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1328A560F5B
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 04:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbiF3Cx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 22:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiF3Cx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 22:53:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EDF1F2F1;
        Wed, 29 Jun 2022 19:53:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C638561FF2;
        Thu, 30 Jun 2022 02:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24BAC34114;
        Thu, 30 Jun 2022 02:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656557607;
        bh=FKYMWKkjwPW4iSO4MU7KrL76icrNy9l9+eY9hs2xb/g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L8BNkpqmv4b/VApWABcs2pgfoPeCbekOchyoro3vyNg+huc1Nq+BJbmAI3+RH59tl
         wVOBjnWLpjuiExR2TazQPIhgRy9Nr7Sqb3ckAky4lCmwONrjFiwQnlgO8GBqx7gpVi
         65QuTocrJ36A799Jjztg6022/NpPTnoxp/IF6HkYc8icCETM+jwEPt2/7LDS+0VFGr
         d9dgUZdKFG020eupa0U4/NgQOXv2kdlpsC+qQvQVCDt/EVdQo3Y7aS2h+iJz3LJydA
         Hw+MsTHYO1lUqhsEzsqEhcivcrkYuiFidpHHTjLIdQChPpAodtx8jCeNxzPzJ6Mr/F
         QRmL9afzn6Ymg==
Date:   Wed, 29 Jun 2022 19:53:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        shenjian15@huawei.com, lipeng321@huawei.com,
        zhangjiaran@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hisilicon/hns3/hns3vf:fix repeated words in comments
Message-ID: <20220629195325.49d54d88@kernel.org>
In-Reply-To: <20220629131330.16812-1-yuanjilin@cdjrlc.com>
References: <20220629131330.16812-1-yuanjilin@cdjrlc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jun 2022 21:13:30 +0800 Jilin Yuan wrote:
> Subject: [PATCH] hisilicon/hns3/hns3vf:fix repeated words in comments

Going forward please make sure there is a space after the ':'
