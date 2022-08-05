Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7475158B0B5
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 22:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241511AbiHEUE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 16:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241135AbiHEUE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 16:04:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CD13342A
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 13:04:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 391B5B829F2
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 20:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC21FC433D7;
        Fri,  5 Aug 2022 20:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659729864;
        bh=eIbf4hMKzhkUhsCuo2LJ6Hfscrz4auQAixvOR6lYvdQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WELji+P1YDhjFNpv1/lV+8G5Hx8IDvmMCm0fO2BdS3DiKJuwoSFzFDd8SMHz7jWHw
         +ioM911NrTESvyx2HvuPmDQgRdL0kEpEdDQ9Lb2srDPxx4koYM++MfcAe6EBMQ7O1/
         1tonUG76WuTo8Uq69Zrzu0m2uMU7YzXZgvW+I2D2MYAowN8mn43WgHzv/SsRvCe3L8
         yfe9cMW7P8GrWPq/JAZngOoYEBeDk2hebbr+VxrXoT3/5j9AsxOOvOVeSRyr+c4dQi
         SAFoSktb6xJXFPRPcf1ZJohSrtXqTwZowqU+EszvWvXjutSScMVCBs66gY0dIcUsmH
         AQeuu4wVFfOXQ==
Date:   Fri, 5 Aug 2022 13:04:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cezar Bulinaru <cbulinaru@gmail.com>
Cc:     davem@davemloft.net, willemb@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH v5 net] selftests: add few test cases for tap driver
Message-ID: <20220805130423.687552da@kernel.org>
In-Reply-To: <20220803062816.3989-1-cbulinaru@gmail.com>
References: <20220803062816.3989-1-cbulinaru@gmail.com>
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

On Wed,  3 Aug 2022 02:28:16 -0400 Cezar Bulinaru wrote:
> Few test cases related to the fix for 924a9bc362a5:
> "net: check if protocol extracted by virtio_net_hdr_set_proto is correct"
> 
> Need test for the case when a non-standard packet (GSO without NEEDS_CSUM)
> sent to the tap device causes a BUG check in the tap driver.
> 
> Signed-off-by: Cezar Bulinaru <cbulinaru@gmail.com>

FWIW looks like the pw-bot missed this one, it's 2e64fe4624d1
("selftests: add few test cases for tap driver") in net. 
Thank you!
