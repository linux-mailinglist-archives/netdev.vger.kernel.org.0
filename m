Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63636ED0D6
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 17:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbjDXO74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 10:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbjDXO7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 10:59:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5706CEA
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 07:59:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E376A60B90
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 14:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F768C433D2
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 14:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682348393;
        bh=3FSYc0Go+Ohobxu8MgDC4QJICtoRI+qroYd+aXzwK8I=;
        h=Date:From:To:Subject:From;
        b=syfOQ608FJR/+Mr/G3wQWv9EEcM5uP6FZHucMFNKm8QeAoQIBwklBtKJzAKGGQFYu
         +zKpxytlAHwCInm0y2oMzFpnuUWM1XgnpTIWko0MRoAi/N8x2Tmrg5qn8JmHMRu/pV
         cpx7XJg68opW1K9lJ7dL3IJ0XaDLodsOq6GO8rD0zFMqFfu6IhGlew1rhunU1mdMvR
         VD8gplEmCzAdny3O//jm+FZoATKEFNYnPVStxI1bT+CvMQMezNoXRaHympy6zl26WC
         DPTLvZ4Ed9rEVRJTuxjwsqHDYZc09vB2zVI6KsB/B5xmNWXXv0z+eXhbPS11n9yJFs
         GYx8M/EK/Iftw==
Date:   Mon, 24 Apr 2023 07:59:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [ANN] net-next is closed
Message-ID: <20230424075952.0805a8a1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Linus released final v6.3 so as is tradition we'll going to slow down
for two weeks and close net-next for new patches/features/refactorings.
We may pull a couple of straggler PRs and if all goes well submit
net-next to Linus some time on Wed. I'll send out the development stats
once the PR is out.

I was hoping that we'd migrate the netdev mailing list to a different
server during this merge window (good old vger stack to LF servers).
Which should hopefully cause no disruptions and improve our email
delivery time and sensitivity to various oddness. But it's not
confirmed. We'll keep you posted...
