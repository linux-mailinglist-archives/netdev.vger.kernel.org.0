Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4BA57D1E6
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiGUQs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiGUQs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:48:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85F288138
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 09:48:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD6CBB825E0
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 16:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1ADC3411E;
        Thu, 21 Jul 2022 16:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658422105;
        bh=lJZIasa+C818aUnaTtPdRV4gbToaAsco0zsn9jiQb50=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QYyHxbfsjv097ddCeQjz0vN5VuOsN1dd8aG7s+RXbGSdSRqAoJssEqROBUseJvBir
         /VVM/1kb4P9GQ9y6YjhZ9t/B5CtOXpBDHvnrF5DAwLyIiymFZGzvbH9MQNXA/35alq
         cWxd3qwk8A211mTfttU942hReV8nVLLoYxiFCPrhHinwGXv7U7oUcU84OIPizsGso8
         /L9iw1D8ujqu8va4DDOoy+4Hz0VKvoKzCRdklDirDKOqTqUzDv+OfAyYTaYmVbFvUz
         KxUtBpNUm1gQQdOn33TyYXZ0KTbPdb0H1gzdUf5+lXeLq4zFBg8RWNV4eghmWl9muo
         wwxmgbAIrF3aQ==
Date:   Thu, 21 Jul 2022 09:48:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Message-ID: <20220721094824.6a5c7f5c@kernel.org>
In-Reply-To: <20220720183433.2070122-2-jacob.e.keller@intel.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
        <20220720183433.2070122-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jul 2022 11:34:32 -0700 Jacob Keller wrote:
> Users use the devlink flash interface to request a device driver program or
> update the device flash chip. In some cases, a user (or script) may want to
> verify that a given flash update command is supported without actually
> committing to immediately updating the device. For example, a system
> administrator may want to validate that a particular flash binary image
> will be accepted by the device, or simply validate a command before finally
> committing to it.

Also

include/net/devlink.h:627: warning: Function parameter or member 'dry_run' not described in 'devlink_flash_update_params'
