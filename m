Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E004A407A
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 11:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbiAaKvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 05:51:12 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:58718 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiAaKvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 05:51:12 -0500
Date:   Mon, 31 Jan 2022 11:51:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643626270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1HrP+Vgt7n8HpLZHmiyqAEpK9Ixl+Sdp3tB06tFj4yc=;
        b=aGcD+R4O0eu7ZleuhENO8bvx7FAC54O8C7udu7gGgCzpcy58KmGtlMzLtXubTSOQQUOnUJ
        qZmGkIyx4Y8o1hDWUbQUZ5OEkMWSB3mXFSHH+TxeNar7MkxjuvkSQpObE212Cts36kIKoJ
        2L3B9UUJ357lZju+xXEVCb85G4euGPy8GE4Ithmkr4VEMkkRM4WhUbG+9qYM2w2bX5fzn6
        cZYAK+LP2LPp7zd6FqcjtKUIqHb9fNSUX+91ife3yHrjv1ee8ZYo76PqiQ7kAnT79+ygDH
        WqWt0qJcEMH3UkSCFxmdV7SCMiqJPt1XxCvMsiUsrznDxH7yX15F0Vw/AdnJjQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643626271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1HrP+Vgt7n8HpLZHmiyqAEpK9Ixl+Sdp3tB06tFj4yc=;
        b=MaOSiJLkg8AEcChbUuJMKsgGzU8A4SbK6zofyz0ImKVT9VSKNj0JPchJW0k/x6EYQIIyU+
        hhglHafTXe7PsJAw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>
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
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH 1/7] genirq: Provide generic_handle_irq_safe().
Message-ID: <Yfe/HRsKaGPPUc/B@linutronix.de>
References: <20220127113303.3012207-1-bigeasy@linutronix.de>
 <20220127113303.3012207-2-bigeasy@linutronix.de>
 <c26a4348-fa0c-6eb6-a571-7dbc454c05d0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c26a4348-fa0c-6eb6-a571-7dbc454c05d0@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-28 13:18:14 [+0300], Sergei Shtylyov wrote:
> On 1/27/22 2:32 PM, Sebastian Andrzej Siewior wrote:
> 
> > Provide generic_handle_irq_safe() which can be used can used from any
>                                           ^^^^^^^^^^^^^^^^^^^^
>    You're repeating yourself. :-)

corrected, thank you.

Sebastian
