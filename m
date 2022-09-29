Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C58F5EEB38
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 03:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbiI2Btk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 21:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234517AbiI2BtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 21:49:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFB2121647
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 18:49:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77F37B822E1
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 01:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50B5C433D6
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 01:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664416139;
        bh=K2bMRM5k07zzhRVYtb+ZVzEPMWlLP2c8HdDXa/v1BhU=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=MZwPkaLfDjRUAH5xkwrzjoJpyzqVp7uOlruFZfDdEQrFkqh4aJxwXJGTBFnEsImbm
         uZPkph+GVtngMbRv7GjgWYUrjsyiv+/X8wo56c9tNxm2zpCdyIGlCC55AYtuHo0ltO
         xf+U8lMxRpeYg4qTzqWfY9Mkn7FgqnflAH9FtohO/sK+KPbTJ8sRl3Dtk/jumHiwWx
         ImoXBZKQRdR2XBll88XDTRxbixcASUprQiYrGOCstbv5e55I/qG5oCWeR8Cp5eQEot
         BvciKKCLtz4Pyb2OMprSJzSGz4rIUhfafguvaqLw9DehhDRPtnIpc/oU13VWzmOwCj
         7TLr31xA4S7wg==
Date:   Wed, 28 Sep 2022 18:48:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Subject: Re: [PATCH net] genetlink: reject use of nlmsg_flags for new
 commands
Message-ID: <20220928184857.7d43dd34@kernel.org>
In-Reply-To: <20220928183515.1063481-1-kuba@kernel.org>
References: <20220928183515.1063481-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 11:35:15 -0700 Jakub Kicinski wrote:
>  [PATCH net] genetlink: reject use of nlmsg_flags for new commands

I managed to mis-type the subject, should have been net-next,
obviously. I'll resend tomorrow.
