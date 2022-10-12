Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7CEA5FC8A6
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 17:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiJLPtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 11:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiJLPtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 11:49:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBE1F192A;
        Wed, 12 Oct 2022 08:49:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64FD4B8197E;
        Wed, 12 Oct 2022 15:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A551EC433D6;
        Wed, 12 Oct 2022 15:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665589751;
        bh=NcjKgrFoj6/svcnGH6enCbSnyaX3YZLDaClpLkpXnu4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bVYyA4Iqm03F9YsdG0hgU/2xQrWv474rDvLUm1ha8GojD9LAt+E4bHc4WPmewC4Zr
         WWF2quFbJbg3uH3n5UpY6IgV+zZMYIvrrmLyupd69SL74GD4rvajbTqLjlPj9+Hp+f
         L2LFVreuuev3UpolpCs7sQXMV5kMA6rq48PKzSmI0ZDGxLntEW6S130rNDyqIh6wWQ
         njSWXBqoYBV/twTsZeSAmgrKk7SaX+7tpyka21zpjQ872rFXTNUm92fSuM16QU9XMd
         paPnikop4jkrCKjuzb1KH0FbLQGhQ01ayf+NHIC7BwqF7s1RTuMAl+Z9gLHIWI94Cr
         llk0Q77bEJmCg==
Date:   Wed, 12 Oct 2022 08:49:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     leonro@nvidia.com, caihuoqing <caihuoqing@baidu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Qiao Ma <mqaio@linux.alibaba.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hinic: Update the range of MTU from 256 to 9600
Message-ID: <20221012084909.0e5bce48@kernel.org>
In-Reply-To: <20221012082945.10353-1-cai.huoqing@linux.dev>
References: <20221012082945.10353-1-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Oct 2022 16:29:40 +0800 Cai Huoqing wrote:
> Hinic hardware only support MTU from 256 to 9600, so set
> the max_mtu and min_mtu.

Sounds like a bug fix so please add a Fixes tag so that the patch gets
backported to stable releases.
