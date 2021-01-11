Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC67E2F169C
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 14:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387975AbhAKNyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 08:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387623AbhAKNyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 08:54:49 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E581C061786;
        Mon, 11 Jan 2021 05:54:08 -0800 (PST)
Date:   Mon, 11 Jan 2021 14:54:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610373246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9GWyJS5KMpdsznuurt3EHiTiqgJ+mfm8rqSh5n6E2UY=;
        b=ri5EZh9QWTy55Ad0hPtd2xs6nGAWHJN5Ni4wSvJNbBtqpPMXHq52YBA0jmRjWj5ZEe/E00
        Hs0ta33h8wm1lVivy9Bqi6KI86ou8ik+WOgHXeQD+9cp8njvBqikBtG8JJVKt4P0EpGQEc
        dpcMKBzrFZQQvGlk6C9Y1OeAbDG6kQ2qFFiJS8lOTJKQCvGw+ngU/KSaASQcS1R/W9chze
        tAeHxLP3bM1afJZ5rar4l3LZEKtR+MVEhvU3sJcKEw68C1scUngPbUN6nZArUkxjkQGvl7
        LYUzCnpiMlU/baOu1XZ1PL1agdLn6MFErAbizp7ZgeI+XmAmzG/v0gNuqhjyIQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610373246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9GWyJS5KMpdsznuurt3EHiTiqgJ+mfm8rqSh5n6E2UY=;
        b=SQAGnelhxP9OBypcC5CExEzyO6j4vdCp+rN7f8Cz9TvFEaj/Wox32YBB50A1rkVxBi0zwn
        kn4NHdX7VyaL61Dw==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
Subject: Re: [RFC PATCH 0/1] net: arcnet: Fix RESET sequence
Message-ID: <X/xYfVi3mQrnjth+@lx-t490>
References: <20201222090338.186503-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222090338.186503-1-a.darwish@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Dec 22, 2020 at 10:03:37AM +0100, Ahmed S. Darwish wrote:
...
>
> Included is an RFC patch to fix the points above: if the RESET flag is
> encountered, a workqueue is scheduled to run the generic reset sequence.
>
...

Kind reminder.
