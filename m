Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0045760125F
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 17:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiJQPGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 11:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiJQPFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 11:05:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14B96CD3B
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 08:05:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7798F60F8C
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 15:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C023FC433D6
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 15:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666019050;
        bh=WxORZD3Z7uUrBRywnWYA2QyaiV8ARSZ+iyAnXDNIgcE=;
        h=Date:From:To:Subject:From;
        b=eBRy+2BooPOdP0yVOcZWdAGTU8JXd31bTG/4cin9Bg0o47sKIfy+0rcmAA504zHgt
         JxPfog5bwC0IFxuI4j0lmi7LERlVZ5jWEaWBlKjDqHav/okVY+MyEnFqA7Ij6ukSGJ
         I4AMaFjhJSDlQQb1u3BejsTsoiFX+9qENXAc+8ezQ6rB+JjsyepU2M67X5HC2V7ESH
         jAFPMGuA3sTVDe1HRnNkEw1cmptzPPwOX7C7H0h82bIrA9yZwObrR4Brb5DZSX/iZa
         y7thuWBYoePR6M9DETUI/qC7K/5ShitsiP3/uKPS7ZtFJlzV0oTsFWTwFVysReqBEl
         2yoGKchyyYFQw==
Date:   Mon, 17 Oct 2022 08:04:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: net-next is OPEN
Message-ID: <20221017080409.4e0f023c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

it's been a good two weeks, back to chorin'
