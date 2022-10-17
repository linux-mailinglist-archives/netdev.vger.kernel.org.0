Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C004F6015E6
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 20:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiJQSEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 14:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiJQSEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 14:04:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064057437C
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 11:04:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DD3EB818EC
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 18:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF533C433C1
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 18:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666029841;
        bh=GNuPPz9nzBpuuvVvg08VtgruDyE9gjgsmip84Hk64BM=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=L6XLduA2pTtQyVVWXlHFOBF3vdPZjns2dxDRhVJd9N7FwPIZcwJOQ4xCp4/tUchdG
         qPmV7Ig83hNeSTeTuIhHI5HzNQ3eAJAA/Q2+Crt1C0HhnbczznyExKBwrsBds7uF4R
         C3xLSdaTZlfVuiENwaPoDkud9L5QBE6I/3UUS2EZOtS3WAphZsId31bMXoFHfB+408
         0k/LuFU/E28/nMqCfemus4UPnY7I6GDlsCqYVZR7opIB+6iUK1kOzRelP52vCjkBN+
         AppYK6TBBgj41Vna5ssk+0cQvwsz7R0eUdUE7kZjVqBsRk5WfAKRX0uLuVjh12Np37
         Prtpgf7yQ2nrQ==
Date:   Mon, 17 Oct 2022 11:03:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Subject: Re: netdev development stats for 6.1?
Message-ID: <20221017110359.6fa9fb93@kernel.org>
In-Reply-To: <20221004212721.069dd189@kernel.org>
References: <20221004212721.069dd189@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Oct 2022 21:27:21 -0700 Jakub Kicinski wrote:
> That said feedback is very welcome, public or private.

Thanks a lot to all those who shared their thoughts, I had been mulling
over all the good points that had been made. It's not an easy problem.
I reckon next time around I'll share the script and perhaps more folks
can try their hand at extracting the information?
