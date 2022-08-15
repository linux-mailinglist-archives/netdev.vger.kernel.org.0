Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A733593426
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 19:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbiHORom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 13:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiHORoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 13:44:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD20227FE8
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 10:44:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 829F1B80EDB
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 17:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8E1C433D6;
        Mon, 15 Aug 2022 17:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660585476;
        bh=vwLI/44uJ6CinX0eBzmGpQPYB1GMAa3oP4gh80I84SQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=umoZZrLl+p2sEMZ+/x7gbXQwnGI5vWAetERw1/jTap4ShVBehn+uksk0uBzwkcPw/
         uZgOwyGExFwOBfbr3NNxLggwlbvSkYzXWXCjhZF6GNFAtoSUaUdHdAI3dA5T0oNjqX
         TblNTDjqpLycMzx1BxGkGDEk4AIoKBHEXca+QCaWc1aHC64rxq4WX5C8QRCXb9nT8G
         qFUP0XI/7SbXM9CH8psN3T/UrDCH84yLrRmyda9Dsr0FHs/2CuS3L2T+Uzwpcu03Vx
         hbQtlOq3kJVmRhHC6AaxJZX73RYAAjJ02nm5nnEPojBHLybLdPlOGrl+QavW+J+ISN
         EfVHKxZerU9ZQ==
Date:   Mon, 15 Aug 2022 10:44:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuznet@ms2.inr.ac.ru, cascardo@canonical.com,
        linux-distros@vs.openwall.org, security@kernel.org,
        stephen@networkplumber.org, dsahern@gmail.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH net 1/1] net_sched: cls_route: disallow handle of 0
Message-ID: <20220815104434.052a53b4@kernel.org>
In-Reply-To: <20220814112758.3088655-1-jhs@mojatatu.com>
References: <20220814112758.3088655-1-jhs@mojatatu.com>
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

On Sun, 14 Aug 2022 11:27:58 +0000 Jamal Hadi Salim wrote:
> Follows up on:
> https://lore.kernel.org/all/20220809170518.164662-1-cascardo@canonical.com/
> 
> handle of 0 implies from/to of universe realm which is not very
> sensible.

Heh, I was gonna say, but then you acked the other fix :)
