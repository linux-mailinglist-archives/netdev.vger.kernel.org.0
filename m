Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2FF6271D5
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 19:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235391AbiKMSxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 13:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235375AbiKMSxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 13:53:32 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46C0F0F
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 10:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4EcEvtmeUmAHmYo4uhnKIRW+7g7PrtFAwL18KhFmx2g=; b=ScO5dy2DjB/ZjQV7nioVyulKKp
        HAT0idm/1ms4LyLqwPypoEurbCRafQhOyZIMz/I1wkPj40+fK52Um0769B9V5BPnvyNIkKZ2XI7SV
        Z23R6DrEfyWw+bZUwbO7YIvqm9CRr0NhbHx21P7QALgX0ZgXaWtvg6jmQ69TmRD5pfWg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ouI6R-002G5D-2b; Sun, 13 Nov 2022 19:53:11 +0100
Date:   Sun, 13 Nov 2022 19:53:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     John Ousterhout <ouster@cs.stanford.edu>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: Upstream Homa?
Message-ID: <Y3E9F1rUIWSXImUS@lunn.ch>
References: <CAGXJAmzTGiURc7+Xcr5A09jX3O=VzrnUQMp0K09kkh9GMaDy4A@mail.gmail.com>
 <20221110132540.44c9463c@hermes.local>
 <Y22IDLhefwvjRnGX@lunn.ch>
 <CAGXJAmw=NY17=6TnDh0oV9WTmNkQCe9Q9F3Z=uGjG9x5NKn7TQ@mail.gmail.com>
 <Y26huGkf50zPPCmf@lunn.ch>
 <CAGXJAmzrjKUUDNk0GEvqCNk0SUgtdh=rkDhYSDBogoDyUmr9Tg@mail.gmail.com>
 <Y3Cpt4qB5jMoVDDh@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3Cpt4qB5jMoVDDh@nanopsycho>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> You can do it easily in emulated environment, like qemu.

https://translatedcode.wordpress.com/2016/11/03/installing-debian-on-qemus-32-bit-arm-virt-board/

This is a few years old, but things have not changed much. It will get
you a reasonably generic ARM system running in QEMU, on top of
whatever hardware you have. I would replace jessie with bullseye, but
the process should remain the same.

It will not be a very fast machine, since there is no KVM
acceleration. So you probably will want to cross compile the
kernel. This is well supported, it is what Embedded developers do all
the time.

    Andrew
