Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBD66EE65D
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 19:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbjDYRJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 13:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbjDYRJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 13:09:03 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B5DE71;
        Tue, 25 Apr 2023 10:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=Ey4edF/oKk0cDDvnWhurm/KjAw6rCB2vlfX/3HZ5Yvo=;
        t=1682442542; x=1683652142; b=Tg/97dFMkTTeh8ZnMnqtryEwhKU4w4Fis5SOxukX5kUSLOE
        X7aoxxyHwHROZ4dP1uR8sK5Ae4jZy2xfBja7lLTy/sG0ZG3mH0bLjFa1O6moE7vaHp8omNLP6DFTt
        VzBJVaOscUhcIERf5qpyXijfbyStHMNu7cd2CtYD4OHUZQPu154VpsH/8IHQFSwhda+kn04FLKHOX
        XTQIZlpRJsuPBXZ2eHXsJHuWKHZ7YTg5a53RXfnrMFdmZIPOce2KiFg1W4RDmnWf4IG1R7dspHsCA
        6oj87PQ/iXeiTqi6/5YjOc3jqPsdjJwLiaapKiCBaB0UxnE8NIInOaLDmvIFvTeg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1prM9r-008Hap-2T;
        Tue, 25 Apr 2023 19:08:51 +0200
Message-ID: <77cf7fa9de20be55d50f03ccbdd52e3c8682b2b3.camel@sipsolutions.net>
Subject: Re: pull-request: wireless-next-2023-04-21
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Tue, 25 Apr 2023 19:08:50 +0200
In-Reply-To: <20230425071848.6156c0a0@kernel.org>
References: <20230421104726.800BCC433D2@smtp.kernel.org>
         <20230421075404.63c04bca@kernel.org>
         <e31dae6daa6640859d12bf4c4fc41599@realtek.com> <87leigr06u.fsf@kernel.org>
         <20230425071848.6156c0a0@kernel.org>
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

On Tue, 2023-04-25 at 07:18 -0700, Jakub Kicinski wrote:
> On Tue, 25 Apr 2023 08:38:17 +0300 Kalle Valo wrote:
> > IIRC we discussed this back in initial rtw88 or rtw89 driver review (no=
t
> > sure which one). At the time I pushed for the current solution to have
> > the initvals in static variables just to avoid any backwards
> > compatibility issues. I agree that the initvals in .c files are ugly bu=
t
> > is it worth all the extra effort and complexity to move them outside th=
e
> > kernel? I'm starting to lean towards it's not worth all the extra work.
>=20
> I don't think it's that much extra work, the driver requires FW
> according to modinfo, anyway, so /lib/firmware is already required.

If the firmware is sufficiently unique to a device (which is likely) it
could even just be appended to that same file, assuming the file format
has any kind of container layout. But even that could be done fairly
easily.

johannes

