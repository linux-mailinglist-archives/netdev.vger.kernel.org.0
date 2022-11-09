Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC6862215A
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 02:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiKIB3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 20:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiKIB3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 20:29:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B845E9F2
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 17:29:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44713B81CD5
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 01:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CD9C433C1;
        Wed,  9 Nov 2022 01:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667957347;
        bh=QZdaQxeLOM1qX+lvFYqCEIHQ7ipEBog8EXwnuFv2r5c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dFSyPe2RTAPtvCrDahz/YADcF+qmIEHf4aWfqsFhiD86Lynt1vk0i/+a0PxOCfKId
         Scro3AIvmAPJla+lCX1RbXJhMa0Mh7k52p6mHjR5d1dVnIrbNxoggQZD9555nNyGKL
         H4QIVY7v1j4t6t4KzWSTriuZFDFH0IvrfDkZT5w0SjMAvN25Vej8It4YA8qQJ5MNPQ
         sS4f50zYAXF7ICIISrdNefZLsWcaNwuijKtH1dbGWrDKb+RKeL95fSnXwn18d99+NQ
         UngKFDlgkIj5sD35FCkLaZ/mnE+KqhWVn95+6aUce3nuNE6RkFeaYaGnGGknAYuPzz
         SJBZpEVS1chrA==
Date:   Tue, 8 Nov 2022 17:29:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <netdev@vger.kernel.org>, <jdmason@kudzu.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jeffrey.t.kirsher@intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
Subject: Re: [PATCH net] ethernet: s2io: disable napi when start nic failed
 in s2io_card_up()
Message-ID: <20221108172905.139a962d@kernel.org>
In-Reply-To: <20221108005952.73685-1-shaozhengchao@huawei.com>
References: <20221108005952.73685-1-shaozhengchao@huawei.com>
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

On Tue, 8 Nov 2022 08:59:52 +0800 Zhengchao Shao wrote:
> Fixes: 86387e1ac4fc ("s2io/vxge: Move the Exar drivers")

Again, unlikely to be the culprit.
