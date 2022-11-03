Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAAF617517
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 04:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiKCDgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 23:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiKCDgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 23:36:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB6613F4F;
        Wed,  2 Nov 2022 20:36:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 861E6B82626;
        Thu,  3 Nov 2022 03:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2277C433C1;
        Thu,  3 Nov 2022 03:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667446602;
        bh=e7EbzEinPvkWjCwc6yOCuvFWIQhbUHVjGJB7D8FeO8Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rUEGUJFzBBvyVITZJD36TTlJ4lKlWzaoyY/m6OFVUgS0keZwj8S2x1ngP9zCzXPUU
         3bHAUxJcRpmXWWqSkNxu9YfN5Uqi/1q5KKW7oYsI17q3FU/eYw0FXHUqChmm8EZYn0
         ZnydapVaOHnP8uVY/DFqtDqSVvxMhauyW315mOEiKxTmNBWG88SwtXdAjxbJRqcRFU
         PqvA+SmyWBSFHgQMGoa2hEAOqX+8fqbMRtGdGVHq6K8+sZ7rQWWS2nK9aOyYG8L8J/
         OHIFtEaRfryjHyG+tYPrXcj6TRxknZKfT30eqlqDxDqNlT7jA0hBxLYgtrfhKwjC/C
         TfbK8vUIQknnw==
Date:   Wed, 2 Nov 2022 20:36:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        SeongJae Park <sj@kernel.org>,
        Peter Chen <peter.chen@kernel.org>,
        Bin Chen <bin.chen@corigine.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] net: hinic: Convert the cmd code from
 decimal to hex to be more readable
Message-ID: <20221102203640.1bda5d74@kernel.org>
In-Reply-To: <20221101060358.7837-1-cai.huoqing@linux.dev>
References: <20221101060358.7837-1-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Nov 2022 14:03:38 +0800 Cai Huoqing wrote:
> The print cmd code is in hex, so using hex cmd code intead of
> decimal is easy to check the value with print info.

You're still removing empty lines making this patch much harder 
to review. Once again - it should be a pure conversion to dec -> hex.
Don't make any other changes.
