Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23B9654D9D
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 13:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730411AbfFYL3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 07:29:36 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41893 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728940AbfFYL3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 07:29:36 -0400
Received: from [5.158.153.52] (helo=mitra)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <b.spranger@linutronix.de>)
        id 1hfjdl-0004yt-Ns; Tue, 25 Jun 2019 13:29:33 +0200
Date:   Tue, 25 Jun 2019 13:20:26 +0200
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 0/2] enable broadcom tagging for bcm531x5 switches
Message-ID: <20190625132026.06a5c543@mitra>
In-Reply-To: <f1f45e1d-5079-ab24-87d8-99b8c6710a08@gmail.com>
References: <20190618175712.71148-1-b.spranger@linutronix.de>
        <bc932af1-d957-bd40-fa65-ee05b9478ec7@gmail.com>
        <20190619111832.16935a93@mitra>
        <f1f45e1d-5079-ab24-87d8-99b8c6710a08@gmail.com>
Organization: Linutronix GmbH
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 22 Jun 2019 19:24:10 -0700
Florian Fainelli <f.fainelli@gmail.com> wrote:

> Something like this should take care of that (untested). You might
> have to explicitly set the IMP port (port 8) in B53_UC_FWD_EN and
> B53_MC_FWD_EN, though since you turn on management mode, this may not
> be required. I might have some time tomorrow to test that on a Lamobo
> R1.

The patch work fine in a manual setup, but not with automagicaly setup
of $DISTRO. But that is a very different story. Trying to debug whats
going wrong there.

Thanks for the patch.

The whole setup of the switch seem to be desperate fragile. Any chance
to get that more robust?

Regards
    Bene Spranger
