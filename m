Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA864554242
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356985AbiFVF0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347664AbiFVF0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:26:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB9836307;
        Tue, 21 Jun 2022 22:26:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A8CFB81A9A;
        Wed, 22 Jun 2022 05:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF520C34114;
        Wed, 22 Jun 2022 05:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655875569;
        bh=7RxrNlagKfC3KdPjNXKV2smX0nbDuSbx3K+vuz8e3iE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FS/rZlcdNPNrC+OBRAS66/RbIfpSyXFf2oPZoN3KeCCKTDjV05WiZjGD/AXCtQdUp
         48S+Ew0KSvT08V3koT9NI0uBUF10yvUom1gBQyyirkoUxX8drwzZa8a8wRdCw2rK4B
         CwJ7o0IUtai3dKZ5MgW+L9097XiOJZeLDaRdcRQwAwgWMI+fqLgdygZMJ+Qco7DmKI
         kPPEIhN7P+3VT0agHWbUndQR2xYW8EXaywjUTkIFzYH1+tUfWcqDNkHKAUHymq5Q1T
         S8Ps5h7Sy0RnoUesBX0ZjPazPWPiQ3RzRCNxIqTV1W0LEK4lGa0AViRTHUaOvbIxyy
         k/OCRcXiBIRow==
Date:   Tue, 21 Jun 2022 22:26:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yu Zhe <yuzhe@nfschina.com>
Cc:     ap420073@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liqiong@nfschina.com
Subject: Re: [PATCH] amt: remove unnecessary (void*) conversions.
Message-ID: <20220621222607.75e66eec@kernel.org>
In-Reply-To: <20220621021648.2544-1-yuzhe@nfschina.com>
References: <20220621021648.2544-1-yuzhe@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jun 2022 10:16:48 +0800 Yu Zhe wrote:
> remove unnecessary void* type castings.
> 
> Signed-off-by: Yu Zhe <yuzhe@nfschina.com>

Taehee, ack?  Your call.
