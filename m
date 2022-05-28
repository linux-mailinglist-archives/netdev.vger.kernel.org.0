Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35EC53696E
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 02:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355269AbiE1AjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 20:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiE1AjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 20:39:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E69B496B3;
        Fri, 27 May 2022 17:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61691B825E7;
        Sat, 28 May 2022 00:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C1DC385A9;
        Sat, 28 May 2022 00:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653698357;
        bh=8kvWjLS5nLEsyvb9/kvzb99/2a/PJ7zI0saL5NfzYUI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WniJ/Q+vFJF5P62ha9Slb96mIhdog9bpxFNAYC9bSxM88NO8iwfxzkhtYJjEjtLuf
         kd5RrcwThGqW+WoM6lJNyySRexA08gRtmHT/arQddz/af/OLaOZDuBFoZiHlXzLUYU
         ohi4KL2Ftq76m1G6yDFMf/6Rh1ckoCro3LiBFGS35OnOiw+7/AL0KZBJlMNj/GxDL2
         imuw2HXKuDj9MldfaqntYEa7xNxqhLvYJyYcZ9PMtNwOee5sBZhst4XwT78p0Y0Cvn
         RB55Io5w6INiT6ASWC5VmrazKgESFYqaQV+8Jni20c51j+0JboP1Itwr3JFENmZh1e
         mGmL0Ov4UNHBQ==
Date:   Fri, 27 May 2022 17:39:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shijith Thotton <sthotton@marvell.com>
Cc:     Arnaud Ebalard <arno@natisbad.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Boris Brezillon <bbrezillon@kernel.org>,
        <linux-crypto@vger.kernel.org>, <jerinj@marvell.com>,
        <sgoutham@marvell.com>, Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:MARVELL OCTEONTX2 RVU ADMIN FUNCTION DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] octeontx2-af: fix operand size in bitwise operation
Message-ID: <20220527173915.1c30cdb7@kernel.org>
In-Reply-To: <6baefc0e5cddb99df98b6a96a15fbd0328b12bda.1653637964.git.sthotton@marvell.com>
References: <6baefc0e5cddb99df98b6a96a15fbd0328b12bda.1653637964.git.sthotton@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 May 2022 13:29:28 +0530 Shijith Thotton wrote:
> Made size of operands same in bitwise operations.
> 
> The patch fixes the klocwork issue, operands in a bitwise operation
> have different size at line 375 and 483.
> 
> Signed-off-by: Shijith Thotton <sthotton@marvell.com>

# Form letter - net-next is closed

We have already sent the networking pull request for 5.19
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.19-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
