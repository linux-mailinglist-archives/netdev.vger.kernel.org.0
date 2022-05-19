Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2E652CB57
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 06:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbiESE5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 00:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbiESE53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 00:57:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452F684A2C
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 21:57:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BED1B8218E
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 04:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E7EC385B8;
        Thu, 19 May 2022 04:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652936245;
        bh=Gz8poSexFTfxj+21bXVMQaBVdKSv2LqL8rs7znBbVaM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pYY5LQDL12mN4a5ISPZGdjEKEyCBzXjedgrhB3lyPZ2uPdUF7A1T4qEWoyA3KgCkO
         e5C9ihJRoowD9PL3KbRq8zWgB9nA7FQqimfehPgBNIbQIpoTYIIq3DtVuI6amP318w
         ikQMBn92PyHsTP4YqxJa3Upgmnq8M+Q7WfTxrA70irnORpByxs6KiVZay7Z0XqMHHw
         f98jYiHwJozScaZAIA49FpfSp/ZiIptPQu/vuFZCZ69kgxJtOdDXBQVjpUaqixeur8
         eSIoNPMlFu8l0GVrY8g5z3SqzNfi5yhprsJV5S5/pplVl5pecLN1BD3PRsOT5ASiq2
         qEyxpYwuJIq4w==
Date:   Wed, 18 May 2022 21:57:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next 3/3] ice: add write functionality for GNSS TTY
Message-ID: <20220518215723.28383e8e@kernel.org>
In-Reply-To: <20220517211935.1949447-4-anthony.l.nguyen@intel.com>
References: <20220517211935.1949447-1-anthony.l.nguyen@intel.com>
        <20220517211935.1949447-4-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 14:19:35 -0700 Tony Nguyen wrote:
> From: Karol Kolacinski <karol.kolacinski@intel.com>
> 
> Add the possibility to write raw bytes to the GNSS module through the
> first TTY device. This allows user to configure the module using the
> publicly available u-blox UBX protocol (version 29) commands.
> 
> Create a second read-only TTY device.

Can you say more about how the TTY devices are discovered, and why there
are two of them? Would be great if that info was present under
Documentation/
