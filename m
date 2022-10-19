Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29CE603B3A
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 10:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJSIPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 04:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiJSIPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 04:15:13 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBDD1EEFC
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 01:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=yR+V5tl1a/1XrH9Z80u+ruqlrhxUHieiv6CRsdSzcm0=;
        t=1666167313; x=1667376913; b=PbfF3irsX4KLo0hNUhL86kzlRN95zc7Dlq9UEwMJtwtubG/
        W2rFIUsP9MkHjsccUxbNN0nxAhffplE4rqu2apjhcPjfDJkmRnrAbHk8Zncw+y+ebyRoSZldgze2j
        Iln52pyeNi06smsefi4zvwmf2xStcOeUjr2XQjGyZfiCdwSJETE3HmnBw3D3R5ZkiPJmjTD/SmGfh
        O97WlBSHPqknET1gyffKWnpFL6WCzoltXB1buaZrSEV0P+YoJ9SwgGYyLYNQ5bWDMFCe1QUT1kY+z
        pUxKFrPI6hpWOKOSk+jB9+NGkva0xHWTeR0v9m+kYwhDt6d5l7wS1VE7b0OTOT3g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ol4EF-00B1bA-01;
        Wed, 19 Oct 2022 10:15:07 +0200
Message-ID: <a23c47631957c3ba3aaa87bc325553da04f99a0c.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 12/13] genetlink: allow families to use split
 ops directly
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de
Date:   Wed, 19 Oct 2022 10:15:05 +0200
In-Reply-To: <20221018230728.1039524-13-kuba@kernel.org>
References: <20221018230728.1039524-1-kuba@kernel.org>
         <20221018230728.1039524-13-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-10-18 at 16:07 -0700, Jakub Kicinski wrote:
> Let families to hook in the new split ops.
>=20
> They are more flexible and should note be much larger than

"note" -> "not"

> full ops. Each split op is 40B while full op is 48B.
> Devlink for example has 54 dos and 19 dumps, 2 of the dumps
> do not have a do -> 56 full commands =3D 2688B.
> Split ops would have taken 2920B, so 9% more space while
> allowing individual per/post doit and per-type policies.

You mean "Full ops would have [...] while split ops allow individual
[...]" or so?

johannes
