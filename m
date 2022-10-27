Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D0760EEB4
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbiJ0Dgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234436AbiJ0DgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:36:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA3A558F1
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 20:36:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0131B8246E
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 03:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15CBC433C1;
        Thu, 27 Oct 2022 03:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666841780;
        bh=8LnKmAcaXa6l+3mGv/F7wayibnMgEZ7Dn9ymoSDTwdg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eKRdIoUXx6LSlYe2gnCP3XEDSPMrGT+fhG3xL/r5fncGvAEvlu7gkc+wSp768Jcan
         9Za3Ft2ld4TuC6L6yHJhdUlVW5xrQSeRnrIh9YeuvI/SX+nRgqMRg4B2ZZVficNR0H
         pGejEND8C+bJGCNmmKu1exclSZYSlzxD6RAOXidu1JjLcQSWCthzJRyz/YD5SYW2PQ
         +U4ZpQZSSbZkm5L+OScei6CC23WF0sYG1SOcjMdqhsXwXgOat7HRZHxnl4yLMScod1
         D5WsbFK3smEjMiUy1IPOvvPBvC/rTGQXfAb4u6mgrruT3gtXBq4qIYhqIbEjpYHftD
         PHzTA3BfHBoMg==
Date:   Wed, 26 Oct 2022 20:36:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <dsa@cumulusnetworks.com>, <jiri@mellanox.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
Subject: Re: [PATCH net,v3 1/2] netdevsim: fix memory leak in
 nsim_drv_probe() when nsim_dev_resources_register() failed
Message-ID: <20221026203618.7cd2ffde@kernel.org>
In-Reply-To: <20221026014642.116261-2-shaozhengchao@huawei.com>
References: <20221026014642.116261-1-shaozhengchao@huawei.com>
        <20221026014642.116261-2-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Oct 2022 09:46:41 +0800 Zhengchao Shao wrote:
> If some items in nsim_dev_resources_register() fail, memory leak will
> occur. The following is the memory leak information.

Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
