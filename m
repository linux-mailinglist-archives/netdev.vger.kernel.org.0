Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFA565C805
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 21:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbjACUYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 15:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjACUYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 15:24:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECF613CD3
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 12:24:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89FF8614A8
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 20:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0A4C433D2;
        Tue,  3 Jan 2023 20:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672777469;
        bh=4jrvQb8T9vtBB3ApyGX+/BkBrhMGLV4Qvw0mMpj8R08=;
        h=Date:From:To:Cc:Subject:From;
        b=M0X4PsJvhcsVPHoXIJp8My9gd1HWWyOVd0TECds8WA1YFDXA9Ln4OZmYRxuVYIVd6
         sL+dJLLlGm8WjPu2U0FMy8CJF7RuKScrWWZ92iXi89y5mMP3U3dcxuHmgQXl59HDto
         yiUvFJTPpvOsWOXliZM+JJ/+y84nWYfSnHy0vyC34+eEWtPl6FeN3knpCmdmPI3wZZ
         duvm1lybPOuJm1UT2I2/KqkAb9xqZrCpL2lkIrpfyrQmQCelKlLsRvrtH/Z6ufzFkn
         OHpdHQULmNmUs9WCVEtYwqQhZmrZs7NgWo4Ddq2sq8gFdixbha18yQlMAS5Hjh8yha
         a5YZXmrGVLK+w==
Date:   Tue, 3 Jan 2023 12:24:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>
Subject: [ANN] net-next is OPEN
Message-ID: <20230103122427.363189d7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

net-next is OPEN, we're back to regularly scheduled programming.
(Please allow 24h for the sign to be flipped.)

net PR with fixes will come out on Thu.

Happy new year!
