Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13BB26EC312
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 01:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjDWXRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 19:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjDWXRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 19:17:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD18110E7;
        Sun, 23 Apr 2023 16:17:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ED1860F78;
        Sun, 23 Apr 2023 23:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA550C433D2;
        Sun, 23 Apr 2023 23:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682291872;
        bh=xuQ4mtqW4Z6yCezzgV1LrueZPapAx/BeGzihvHl+4/Q=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=KmSqYvxXR/hG1Kdf/5vAylxXIWgV+jwqARhVaeGqmdKxo+OxXKTxg/ON26GjDwzO+
         78QKqwHLywDGMKksBKxYbQwSjzz7YQCpnCaeKkQuZM3JCj+QzFC3xF8XKq4aX0RdzU
         /ZCT/8XGahGuPNniOngZD2BWEwKqyK1Lu1mjlghdzuA1g4cvcittLdBw7dr35XRUjs
         bdcurGM6FpqzbQoXPBh2fDDsvMVlF+6P0nJUYd/Z4s1sszrHihHY5Y6F8ZuThTaI6G
         PrrGl5UC+mF8VGuwn0cMm/JLxHMzlUAx4TpmlRob9yuNcIkFt3P5Xxo2Yw/JlwYIfb
         4cdPPVUdiaZiA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A0CBCAA9E7E; Mon, 24 Apr 2023 01:17:49 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Paul Mackerras <paulus@ozlabs.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH] MAINTAINERS: Remove PPP maintainer
In-Reply-To: <ZEW5CLw7MW4tPxml@cleo>
References: <ZEW5CLw7MW4tPxml@cleo>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 24 Apr 2023 01:17:49 +0200
Message-ID: <87bkjekx2a.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Mackerras <paulus@ozlabs.org> writes:

> Also, the paulus@samba.org address will probably stop working soon.

How about adding an entry for that in .mailmap, then, to avoid bounces
(if a script picks up that address from a commit where it still appears
or something like that)? :)

-Toke
