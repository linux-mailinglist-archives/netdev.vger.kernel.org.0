Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E7760C282
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 06:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiJYEM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 00:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbiJYEMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 00:12:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D2012FF83
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 21:12:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA2C3B81250
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8B9C433D6;
        Tue, 25 Oct 2022 04:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666671171;
        bh=1+lE8MZUdkT+bjTFb2L6TUVWS7+UrPAzkt2KbF5UOts=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UtxB4ukoHtKFq8Tb/8rg25i/di7pet/fPa8WasXWsUznWdk4Ug+t+jQUCGi7nbdF/
         trAaXQnDkvaPjdiO8q3O1aLH3TdolCB+jIv4c2Dj9k4toTyiTWT++UYJt2wVczwsa2
         eNQhZ5Zw+09I3leRmP8uZ4IFf0lpPWJBtUIehXXLPcaMF/xll9mmw9uAZuGsPA7PFc
         ZV0KYf8uBIn55LivDiPXUVMsXXcXqZ8mrmlIN5y7W/gsZLKF4vuZk/2T6aFuwiLugw
         43M77R96MeIwSZq1GzgrEDj5yoKxCUerCsJn14YH7i6k93cC6x8CJQE7U3KEdGwZNL
         9fdKkkjQvxb7g==
Date:   Mon, 24 Oct 2022 21:12:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/2] net: natsemi: xtsonic: use pr_err()
Message-ID: <20221024211250.2807f137@kernel.org>
In-Reply-To: <20221025031236.1031330-2-yangyingliang@huawei.com>
References: <20221025031236.1031330-1-yangyingliang@huawei.com>
        <20221025031236.1031330-2-yangyingliang@huawei.com>
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

On Tue, 25 Oct 2022 11:12:36 +0800 Yang Yingliang wrote:
> Use pr_err() instead of printk(KERN_ERR ...).

To what gain?  Please don't pointlessly futz with old code.
