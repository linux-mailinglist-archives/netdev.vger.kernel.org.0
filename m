Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956AE55245F
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 21:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239357AbiFTTFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 15:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235833AbiFTTFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 15:05:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1CA12AF0
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 12:05:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 384E1615DB
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 19:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47519C3411B;
        Mon, 20 Jun 2022 19:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655751915;
        bh=iYZeR+Ya7snVdwYo5nzju+nvwQXbzKqKwL64+L+RvuY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IESARd0GQLJ1GNDsffqjf4cau28eoICoRs7gQpoDE5h/dw8n68z7+ImiPwoRnbdWt
         pQjEamHZowYnX8+zpmDT3kqlxQwHkk0lih/YiDCz66hXhH8Y6YUFa2EH5p276sQqeZ
         i92p8VxL3zN9Co8e8Xom6qqyUatt5SalQlRrpuu8PDg34N+mY4YGtSOtzg/ZvDHrhJ
         NVTijSvYWBy9miSCHVndGwVR7r1sgRH2HxY+uiCtiMGqs41Pek4XcXP+QDLlRfe3uX
         UfLV9digt3g1ESvFyZkizY7bU1LxLcaA5XanBd52M5qZ9GxrJIumVuIW8tYOAIgRwg
         yI4KWgxHQzWBQ==
Date:   Mon, 20 Jun 2022 12:05:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jiawen Wu" <jiawenwu@trustnetic.com>
Cc:     "'Andrew Lunn'" <andrew@lunn.ch>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v6] net: txgbe: Add build support for txgbe
Message-ID: <20220620120514.64f3ca85@kernel.org>
In-Reply-To: <005001d8844b$d58f94c0$80aebe40$@trustnetic.com>
References: <20220616095308.470320-1-jiawenwu@trustnetic.com>
        <YquDYCltyKfEjA93@lunn.ch>
        <20220616132908.789b9be4@kernel.org>
        <005001d8844b$d58f94c0$80aebe40$@trustnetic.com>
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

On Mon, 20 Jun 2022 10:17:03 +0800 Jiawen Wu wrote:
> Thanks for your comments.
> If I don't make changes for this patch, is the next thing I should to do is
> wait for the patch to be merged?
> Can I go on to send the next part of the driver?

You got review comments the patch was set to 'Changes Requested' in
patchwork:
https://patchwork.kernel.org/project/netdevbpf/patch/20220616095308.470320-1-jiawenwu@trustnetic.com/

You need to address the feedback and post a v8.
