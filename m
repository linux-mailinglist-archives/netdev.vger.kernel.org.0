Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7A35A339F
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 03:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345208AbiH0Bxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 21:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234514AbiH0Bxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 21:53:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9DAED010
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 18:53:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C3AAB8321F
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 01:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21CDC433D6;
        Sat, 27 Aug 2022 01:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661565209;
        bh=8Q53nO43fGk+5UH2j9hZnJ/gTNJfk8ECCm15iAb6PeY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Px+wRTwvG6G4TgCbEl8cNE7EIDNNNao2AAofzsYF4M0Ff/v2o0/HyDpKDbUVCaDjL
         n8CvwnvbdlD//cVhMxlNoUKEiaWNGqJs8OWYjYYtSZsTJmf6q7Rx26w7e8UK7o8iu5
         X3toH57zNw82oecuk4q5DIaChTXwPsNd4f60NKIr2rQj9V6eSl5gyOc8Eyp0bstJrg
         OD8UmGUmIoVNe58oDQUNw83xjChIxEIXVU9y9p8S74OSFe6CVfrMOXeOSdBIziim6R
         pbXLET0nVNzNiplVUEz2IGrtbmYza6Jx9iAQpa/bqfqbb3ZzLpfC6RhgGX7TE1SEMr
         cIyEimAxUysTw==
Date:   Fri, 26 Aug 2022 18:53:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH] net: virtio_net: fix notification coalescing comments
Message-ID: <20220826185328.12227497@kernel.org>
In-Reply-To: <20220823073947.14774-1-alvaro.karsz@solid-run.com>
References: <20220823073947.14774-1-alvaro.karsz@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Aug 2022 10:39:47 +0300 Alvaro Karsz wrote:
> Fix wording in comments for the notifications coalescing feature.
> 
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> ---
>  include/uapi/linux/virtio_net.h | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

Hi Michael, do we take this on or do you?
I think DaveM marked it as Not Applicable in our PW but I'm unclear 
on what the split is on virtio_net, so I thought I'd ask.
