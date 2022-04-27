Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF505120A0
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243554AbiD0Q5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243537AbiD0Q5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:57:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D49C4286A8
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:53:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B867B8287C
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 16:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B937C385A9;
        Wed, 27 Apr 2022 16:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651078431;
        bh=sVWEPl2xtpzZAM8o3xqQh24Sq4iVsiK/b/iTcM/1IzA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BxKoVl1SSXDbkD5/sVv+GqGHMRyuWIOpEHXTQ76GGfLWsXhJgv+DUB1I6AWigqkgX
         RN93YYeZQqc3MaSvOaxJ5eSAj2MoqWdrIaf9YQ75+skk2b2VutP/wHzjprN1v9ymBe
         w12NKvFIMuTQqHZx9xKvGUCDOtM5fzZ636HbS+keikVABaix2EtwJXvv0vNpRiOfze
         i+GIg8VsNEyKAHwzLdxdMaHi10ZlXpW2mvJTeSFpfHbkwrTt/eaRbC/g7Pt2IVrnWA
         N0TmimNE8pBG5hllAmpLtPFIY4LZib6ZBE9Yv1aZTUhy4smPzDouxdidqGfJj5W242
         O1yJ3u7PcrHOw==
Date:   Wed, 27 Apr 2022 09:53:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH net-next 08/14] eth: bgnet: remove a copy of the
 NAPI_POLL_WEIGHT define
Message-ID: <20220427095350.73ffc15d@kernel.org>
In-Reply-To: <56654c2f-d144-5bcf-0d2c-db3f891169cb@gmail.com>
References: <20220427154111.529975-1-kuba@kernel.org>
        <20220427154111.529975-9-kuba@kernel.org>
        <56654c2f-d144-5bcf-0d2c-db3f891169cb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Apr 2022 09:09:36 -0700 Florian Fainelli wrote:
> Looks fine, however this is a new subject prefix, do you mind using:
> 
> net: bgmac: remove a copy of the NAPI_POLL_WEIGHT define

Ayy, sorry. benet, bgmac... I'll fix when applying.
