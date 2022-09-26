Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A025EB192
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiIZTtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiIZTtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:49:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5CE491E4;
        Mon, 26 Sep 2022 12:49:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B622E61245;
        Mon, 26 Sep 2022 19:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D305CC433D7;
        Mon, 26 Sep 2022 19:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664221762;
        bh=e6QO4HH4+8yZ3ePxV7VG/fowDTzQXATJ5aLoPgc/lJU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T+AgzlU4yVmjF8yZ5ubxXoqyVCkFjykIF43vB0z5ozK4E0GRPcUjhItmpyHjpS72H
         Zg8cjoQwc/wYPtjJjWBbP+rwxORI5WfDl7b5ITq5s+/8IA7/HbdnY3MNV5sAcjmRQQ
         nBoCGJQgMLQFTDl7THZfT8fdkpu30RhfOMeUmpwDRDUVGI9QbpL2S6tSTy9kxkdHq0
         dRLdtWKDKyPwUrFbXcX/iv9CLmIsY++vrDzlp1xYon1xvW8X7KpzQd/NGxMLScTyY+
         MUjBajcYmbPHTM5oDMp+ApnwB13d3NMsczYNicoXf1LH1P4yUnriRFeb9JRUI2iMn9
         0qeHJ2k3ovW7A==
Date:   Mon, 26 Sep 2022 12:49:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>, yhs@fb.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2] headers: Remove some left-over license text
Message-ID: <20220926124921.0079c8f9@kernel.org>
In-Reply-To: <88410cddd31197ea26840d7dd71612bece8c6acf.1663871981.git.christophe.jaillet@wanadoo.fr>
References: <88410cddd31197ea26840d7dd71612bece8c6acf.1663871981.git.christophe.jaillet@wanadoo.fr>
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

On Thu, 22 Sep 2022 20:41:40 +0200 Christophe JAILLET wrote:
> Remove some left-over from commit e2be04c7f995 ("License cleanup: add SPDX
> license identifier to uapi header files with a license")
> 
> When the SPDX-License-Identifier tag has been added, the corresponding
> license text has not been removed.

Jiri, Jamal, would you mind acking this?
