Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C9A6E5DA5
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 11:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbjDRJkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 05:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjDRJjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 05:39:54 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8208A78
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 02:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=k4i3/VaA+Uqg3PngwkoR8mExzq/SkzYx+0CbSwmJ2nw=;
        t=1681810768; x=1683020368; b=IHSIQnojISyMY4PRd0WjMXR7qcbr8zOW8xkF/8/9a3QRhAA
        REkIUSARgeuAo7jBH00wZU+tJUBZqEjFApRzZaeufpxkxRqMKx7YRC7MKacr37l62+dC3zAb5zIh9
        wh5VHFEEMG686Za0+QrwShbb0bXMUqpTsBkxlY3WzJZRSD9Pu26ygqUAhqsagJQ5XpM3uZsFt4N1A
        2x0ZLOPvmI3PivXMOJxaNky7S9PQHvbAWikWACmhEGFOs8P5qtISDWv2VHdwZwKcuMX5V+AT90x5B
        cz9GeFmfp2/81/1ZlXp/l1CH0v/FA1yivUNrhL5eZ0rJW6r0UwfN9jaNrB4IQLmw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1poho6-001ZJh-16;
        Tue, 18 Apr 2023 11:39:26 +0200
Message-ID: <cecbd933afefedf641be2e55540f2f501a7278de.camel@sipsolutions.net>
Subject: Re: [PATCH next-next v3 0/3] extend drop reasons
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Date:   Tue, 18 Apr 2023 11:39:25 +0200
In-Reply-To: <20230414192034.23d40371@kernel.org>
References: <20230414151227.348725-1-johannes@sipsolutions.net>
         <20230414182219.7d0dd0bd@kernel.org> <20230414192034.23d40371@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-04-14 at 19:20 -0700, Jakub Kicinski wrote:
> On Fri, 14 Apr 2023 18:22:19 -0700 Jakub Kicinski wrote:
> > FWIW:
> >=20
> > Acked-by: Jakub Kicinski <kuba@kernel.org>
>=20
> I take that back :)
>=20
> This:
>=20
> > +	/** @SKB_DROP_REASON_SUBSYS_MASK: subsystem mask in drop reasons,
> > +	 * see &enum skb_drop_reason_subsys
> > +	 */
>=20
> is not valid kdoc, confusingly.
> If it's longer than one line, the /** has to be on an otherwise empty lin=
e.

Meh.

> Run the new files thru ./scripts/kernel-doc -none, perhaps.

Yeah, I can even run the whole nipa thing, it just seemed obvious enough
and our automation isn't quite working yet so it's another manual
step... Sorry about that.

johannes


PS: you're not using the docker container I guess:
https://patchwork.hopto.org/static/nipa/739889/13211664/checkpatch/stderr
(I fixed that in the dockerfile I think?)
