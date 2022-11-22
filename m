Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3C0634536
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 21:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbiKVUJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 15:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbiKVUJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 15:09:38 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE39FAB0EA
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 12:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cZAXYdgN4BksCn9n8En8JQsom3SEB58PaiUft/DYgKo=; b=JWjd7JEAIJtSy+Hpi62YJV+4Qm
        y8cPOmmXCrSWwTuGeVBo21pN7GJfsUO8Yj9mpIOfuVndA+wFK0bTDauyeJAaMuPLsoq4QwETghQ+k
        yqwg3kGZKxQv1t1qwIOGnPKKWJfD7zAXnhoNBeYfZ5Q2t/dBYR0dCjEpeuTeMocBRsEM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oxZaG-0039fx-M6; Tue, 22 Nov 2022 21:09:32 +0100
Date:   Tue, 22 Nov 2022 21:09:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steve Williams <steve.williams@getcruise.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [EXT] Re: [PATCH net-next] sandlan: Add the sandlan virtual
 network interface
Message-ID: <Y30sfGrQ2lQN+CMY@lunn.ch>
References: <20221116222429.7466-1-steve.williams@getcruise.com>
 <20221117200046.0533b138@kernel.org>
 <CALHoRjctagiFOWi8OWai5--m+sezaMHSOpKNLSQbrKEgRbs-KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALHoRjctagiFOWi8OWai5--m+sezaMHSOpKNLSQbrKEgRbs-KQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 06:59:11PM -0800, Steve Williams wrote:
> I have had trouble with the veth driver not transparently passing the
> full ethernet packets unaltered, and this is wreaking havoc with the
> hanic driver that I have (and that I'm submitting separately). That,
> and veth nodes only come in pairs, whereas with sandlan I can make
> more complex LANs and that allows me to emulate more complex
> situations. But fair point, and I am looking more closely at figuring
> out exactly what the veth driver is doing to my packets.

Please don't top post.

If there is a real problem with veth, please describe it, so we can
fix the bugs. We don't add new emulators because of bugs in the
existing system.

It also seems like this emulator is very limited compared to
netem. For testing hanic i assume you need different delays in each
parallel path, different packet losses, packet reordering, etc. netem
does all this for you.

    Andrew
