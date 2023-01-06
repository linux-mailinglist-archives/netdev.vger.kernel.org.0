Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4BA65FB5E
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbjAFGUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 01:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbjAFGTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:19:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6F56EC81
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 22:18:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAAC661D11
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA132C433D2;
        Fri,  6 Jan 2023 06:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672985931;
        bh=J6tcdTW8RlkkI8TK/ozY45rXccAZ/rb60VFT3lXHhfU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u+RF5G5K1PXuNTndAAjLlrRhsfr1UnFq591O5Mm992gExZpi0SVGgWLrWbXIKf8rC
         d7ztDKy8m2yVBvIZ8atZZsqsxvw+gp9HX0okEbObZ7qDps0Bza//1VHjdK/kXZ7hw0
         8EauMQAeuUzNTU0szRO0CpMOlhSlm9zSHbLRZGewwYxZnAU9tLtdBla5gioF4mF7xA
         I2Ds/xlAZukY1b0def6RWoJ7uRJnBRLm9IhFwrisSSX+EjUJcQ3dbUww0DCcxUnkGP
         vljH3Z1RhLyrFI2Vsjk9BnX5sJhpY7mW+o6IJVvBIGcFDfqHI8Ic1CcIKfaG9G5jTR
         JKlooMeH3zlew==
Date:   Thu, 5 Jan 2023 22:18:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <netdev@vger.kernel.org>, <krzysztof.kozlowski@linaro.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <sameo@linux.intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
Subject: Re: [PATCH net] NFC: netlink: put device in nfc_genl_se_io()
Message-ID: <20230105221849.5000b8bf@kernel.org>
In-Reply-To: <20230105082738.671183-1-shaozhengchao@huawei.com>
References: <20230105082738.671183-1-shaozhengchao@huawei.com>
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

On Thu, 5 Jan 2023 16:27:38 +0800 Zhengchao Shao wrote:
> When nfc_genl_se_io() function is called, no matter it failed or succeed,
> it does not put device. Fix it.
> 
> Fixes: 5ce3f32b5264 ("NFC: netlink: SE API implementation")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Does not apply
