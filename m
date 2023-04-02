Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9BB76D383D
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 16:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjDBOKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 10:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjDBOKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 10:10:13 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF61D10B
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 07:10:11 -0700 (PDT)
Received: (Authenticated sender: robin@jarry.cc)
        by mail.gandi.net (Postfix) with ESMTPSA id 292BE60002
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 14:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jarry.cc; s=gm1;
        t=1680444610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=g4hJeRgub+yt5WwcGKmRqxTny3ZYntG1Uj1ilTHu3gM=;
        b=GCWFzn7MBL2k13iU60jDTBc0OLjm17UzREb2oa81ODPcNrw0Lf67vfEhcvwokVpXoL6VPR
        zuOG4TGWFzh9ZCXph7nYt3dJTDaqkJ6ifNYVS9q7+JIoPuLyNzaReqpyU+gUA8uTg/65ex
        n6Thg5I4vPynW90TL3ScVq2F/5Gp9i+u82O1nu2LjHd3VijkYY1Fkwom+U4+rq+/JYo67j
        tNAg7gWWRqM+zOpV5E5owMYFeTb6mmrPz+JxbAei+oljM5nubU/xj755u9P7ckQ4whnb6I
        4clII5KhhNJIREqxBlua750YKxoB2MN/V9eITt4p+PYCAYWWQc8PBk6L7fHdkA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 02 Apr 2023 16:10:09 +0200
Subject: netgraph: a tool to visualize linux network config
From:   "Robin Jarry" <robin@jarry.cc>
To:     <netdev@vger.kernel.org>
Message-Id: <CRMBCW54HIFH.1HPI5MO7CRBK4@ringo>
X-Mailer: aerc/0.14.0-142-g5dde23f8aa67-dirty
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi folks,

I was looking for a way to visualize the networking config but didn't
find anything. I wrote a simple python script that parses the JSON
output of iproute2 commands and generates a graphviz dot graph:

https://git.sr.ht/~rjarry/linux-tools#netgraph

The SVG output contains extra info in the tooltips:

http://files.diabeteman.com/netgraph-example.svg

It only supports a small number of interfaces for now but adding special
cases for ipip, gre, sit, etc. should be fairly simple.

Let me know what you think.

Cheers,

--=20
Robin
