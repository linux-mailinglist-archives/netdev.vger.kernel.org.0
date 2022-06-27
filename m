Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11C155D210
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238512AbiF0Plt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 11:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238503AbiF0Plp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 11:41:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C581A049;
        Mon, 27 Jun 2022 08:41:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AF98BCE1B71;
        Mon, 27 Jun 2022 15:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE4FC3411D;
        Mon, 27 Jun 2022 15:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656344501;
        bh=aiwnae3RpvaoNHCXh1x025cNVic3O5YgH/JbQXDcqyk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HYMFvVWoNMbZUkhVg15LtO3y9BDYgIswDZYdFrpMdh4hKo+6ljeQ/H3/r3eQzx3q4
         Pbe/huWRhSTlkvfZT06qoHfk43KazvPVU5AGlL+ejEEpf8OqQZn6issz+qaGue3NAS
         AYEtStU7T1xXdlK8SnGiH8uYZgQK2MOMYft37SfThhN5gM8fRIC5hVLuBdZZRmPw6b
         WEsA3CN+ORIwlpoCQfn38hT0bPkZGUog06+JJ5gt1SJEePy6/UyUn6LjOfdTvUPOHe
         XmoS81q2E1aLLaJgqvRJHNjT/jfX6a+KwqDBvQdjK6n1wBtut1M2HAOZOTlk5Jv4Qk
         /2fXcz/Cnyteg==
Date:   Mon, 27 Jun 2022 08:41:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] usbnet: fix memory leak in error case
Message-ID: <20220627084131.6f80c62e@kernel.org>
In-Reply-To: <20220627131626.31376-1-oneukum@suse.com>
References: <20220627131626.31376-1-oneukum@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jun 2022 15:16:26 +0200 Oliver Neukum wrote:
> usbnet_write_cmd_async() mixed up which buffers
> need to be freed in which error case.

When reposting with a corrected netdev address please add a Fixes tag as
well.
