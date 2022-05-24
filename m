Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4469C533413
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 01:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242778AbiEXXqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 19:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242847AbiEXXqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 19:46:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9073363BC6;
        Tue, 24 May 2022 16:45:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DC2B6181D;
        Tue, 24 May 2022 23:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57964C34116;
        Tue, 24 May 2022 23:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653435957;
        bh=byHQabgQKp9TBTU8NO0iKwDveZDidiAcsR52qhBQFwo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GEyct5OW9p3VE1LAHVcD1W1SSc8b4IC7tA4y2TfvmFXZBAGHDNyTvLxh/FYPmZDSY
         BHVXH00xU9YOoNDeP+CX0Cf7/KbEK3gXV00JeLRdBXgUHqSc08CK6pJ9Abz4XHYZzp
         9qfKEUo+YzyyW9MzpZF4jCyOTwY8GB2/uJtpVFhFDgLtAnUClC3ScPFP0WL3/Z+UiR
         qLV63jVat/YdsK7qKMctOVPD4dQyOapBaZp8rWeRH8APzlNByeUIwNnnI9+RSZLq4g
         ESMYAo2qT03aefzMGNQfS+PApvQ2vh+s3175+TfM3VI7ucpJMgQ3oYDxfoSAJdbFea
         qallKaIe6/N8w==
Date:   Tue, 24 May 2022 16:45:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: macb: change return type for
 gem_ptp_set_one_step_sync()
Message-ID: <20220524164556.5ff041d3@kernel.org>
In-Reply-To: <20220524121951.1036697-1-claudiu.beznea@microchip.com>
References: <20220524121951.1036697-1-claudiu.beznea@microchip.com>
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

On Tue, 24 May 2022 15:19:51 +0300 Claudiu Beznea wrote:
> gem_ptp_set_one_step_sync() always returns zero thus change its return
> type to void.
> 
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

# Form letter - net-next is closed

We have already sent the networking pull request for 5.19
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.19-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
