Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6D94B6358
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbiBOGUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:20:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiBOGUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:20:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BAB11D7AD;
        Mon, 14 Feb 2022 22:20:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3904614F9;
        Tue, 15 Feb 2022 06:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D28C340EC;
        Tue, 15 Feb 2022 06:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644906042;
        bh=h1/xuj33lBeCqMBbKoIaBsOtevsxEy1crRSkrqybK/A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MCiHgsBD/yqq251oFMZGaa2ggXeTw76tIcPtGpat0oO9DmnKJFBtZLm+7CR1NTgMj
         OkwR7dFs0TbkbRI47JPAcunCAP86JAbxjvxtOsU1kSHz8S6m1C8KuOUuVPl7dmK2iM
         Kr+QDrpTPmvLubffXH4bVttvaxDym6zfLVuS1KCR+FcaHulvlO67M0DxcvKkKBoquh
         bbchgKzzya8et+Dha3hXAsLOzpwTd9hfoNIy9bW+fyS2aFTsCe3HTs0NomvzPOYnNB
         kcyDN1J+6LgJm6FitW3FF9k83Gtq0aLUWjLAfSBKBkDc6CxIbV/nOM3r+rf6PwguMb
         Vo9nAqw+vVLYA==
From:   Kalle Valo <kvalo@kernel.org>
To:     davidcomponentone@gmail.com
Cc:     toke@toke.dk, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] ath9k: use swap() to make code cleaner
References: <a2400dd73f6ea8672bb6e50124cc3041c0c43d6d.1644838854.git.yang.guang5@zte.com.cn>
Date:   Tue, 15 Feb 2022 08:20:37 +0200
In-Reply-To: <a2400dd73f6ea8672bb6e50124cc3041c0c43d6d.1644838854.git.yang.guang5@zte.com.cn>
        (davidcomponentone's message of "Tue, 15 Feb 2022 08:52:29 +0800")
Message-ID: <87sfsk1wi2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

davidcomponentone@gmail.com writes:

> From: Yang Guang <yang.guang5@zte.com.cn>
>
> Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
> opencoding it.

Liki Jiri mentioned in the ath5k patch, shouldn't you include that file?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
