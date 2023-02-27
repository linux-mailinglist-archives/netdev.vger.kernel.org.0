Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995866A4CEE
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 22:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjB0VQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 16:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjB0VQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 16:16:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02606241E5;
        Mon, 27 Feb 2023 13:16:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC83EB80DBA;
        Mon, 27 Feb 2023 21:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B62EC433D2;
        Mon, 27 Feb 2023 21:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677532573;
        bh=6gyj/mn4UDoHcIYvD5eHd7EdGHQnhnPiCoxbnGTv3lU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UlyBYOv+m56DvA1YpcZr8BTfUHr/ecs8AyHVNOPJzZ1IJULl/d2/seJtfV7mJyMIg
         DAqUXvaGUgleXlLhplE0FCaK+fZIpg/eGe4a8C40dlI8vubGCUoyb391Wh6I29WUk/
         sbt6CSuimQP/NuFXRergLSm8QqkC2K4uB29fv7woVF9MuSdR+3Qab8pUazWC7ooyZs
         QQ8m7Omsjo0KK9nx3lUQK+8HNSG+jy9qfZ44fHYO6ZL7fpc7Vub+QJqTVyIT51YRLh
         YukUkVPF0zLua+iTWwUJhHUedtPfjaeOln34kt4WwXEKn7OQnZFsQR1rph4E7/Lj/1
         wdJqVeLQzW3mA==
Date:   Mon, 27 Feb 2023 13:16:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-2023-02-27
Message-ID: <20230227131612.21bf0d23@kernel.org>
In-Reply-To: <20230227131053.BD779C433D2@smtp.kernel.org>
References: <20230227131053.BD779C433D2@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Feb 2023 13:10:53 +0000 (UTC) Kalle Valo wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.

Pulled, thanks!
