Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF41B6ACA6B
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjCFRaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjCFR3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:29:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C5664849
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 09:29:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0765B80FE9
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 17:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A1FC433D2;
        Mon,  6 Mar 2023 17:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678123720;
        bh=pcLlV+siUZF/uJzHSPXRSu5/zdDdPLdmUZj2Nj3PTT8=;
        h=Date:From:To:Cc:Subject:From;
        b=L2YhKNBAid0O9kXZo4W93vuB8JrpQTLGg1Qm9Yuj/gUy/OOMKvG4RIozNj1kA/oBh
         cvJrqlqTXKsLl7KdOUrbtu9en1J5DRQ7+SjNw1n0UaEaU8Ytw5eN07uI7siUjdgHeD
         k19IZ6iiHsDQJLg4kUb8RdRTdk0byCxQV6oDXA2KegYgBn5JsmMJlicgdNMvHyqdXN
         0tIku+UgVuyvkQakXp272bzVoEkJ8Sf7y4oWLbAXQ4T8mKeOWJRT5A81ChONpc2raC
         +zo+RGCBlfgTNyUBczycToLjVUQwGNp/FSmcz2Wc9wq8yz34BRhfFyWTwtzv9RoZRO
         ed3p70fEjznyQ==
Date:   Mon, 6 Mar 2023 09:28:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [ANN] net-next is OPEN
Message-ID: <20230306092839.3668ec94@kernel.org>
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

Hi,

hope everyone enjoyed the lower-patch-volume days.
Back to work now! :)
