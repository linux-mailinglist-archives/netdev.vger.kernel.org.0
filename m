Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E194A4235
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359185AbiAaLLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:11:02 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:58840 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376845AbiAaLJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:09:12 -0500
Date:   Mon, 31 Jan 2022 12:09:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643627350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3CXtlXLTYIfo3z5h+Q2OsJCQ12poAJsYf5yCuql9h1s=;
        b=c+YABeix0gi4ppJRFkLpKFxjY+Ytig8FpkSfuk/SZHFOHJ1gJQsbiGwZ6nfjejBPU8ERO5
        CYdn0GkZDT+VVJqI1WdZkpwPUQpeAi/n4+glk2vYUpuJetL9z4UGT2NCM1k/ey8x3dsRp9
        22j7zX0gciD3hf8NQNSeO/JfDgjz1zaZ+hpQUKYpH4ZYqdfBI2wJUOWRtUSCH4Zb2PAmtN
        ncatMzLntfDNR4ypAo4d8tRT+tx1CW0JOzEBBZf539Y0AVqw30qfM8cxcAmLcJYpBUMkVJ
        GkpokhJd/lbvLcVc5JPDox7q2v01KvGzwvT1wi0qPHNLn0SSKDrfzERT+GrNZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643627350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3CXtlXLTYIfo3z5h+Q2OsJCQ12poAJsYf5yCuql9h1s=;
        b=5s9Py6ARZQ6qDeei7b7BBr531WGkrJ236qvkaU0qhDyMd7g05rEbO+FeMqY4ay3u5mDJzN
        PY0FMItDPWWIGpAw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        Michael Below <below@judiz.de>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: Re: [PATCH 2/7] i2c: core: Use generic_handle_irq_safe() in
 i2c_handle_smbus_host_notify().
Message-ID: <YffDVXN7fGFqYs1Y@linutronix.de>
References: <20220127113303.3012207-1-bigeasy@linutronix.de>
 <20220127113303.3012207-3-bigeasy@linutronix.de>
 <4929165.31r3eYUQgx@natalenko.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4929165.31r3eYUQgx@natalenko.name>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-27 15:41:24 [+0100], Oleksandr Natalenko wrote:
> Hello.
Hi,

> Reviewed-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> 
> Worth linking [1] [2] and [3] as well maybe?

no, they are fixed since commit
   81e2073c175b8 ("genirq: Disable interrupts for force threaded handlers")

> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1873673
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=202453
> [3] https://lore.kernel.org/lkml/20201204201930.vtvitsq6xcftjj3o@spock.localdomain/

Sebastian
