Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF17229C84E
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829364AbgJ0TFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:05:20 -0400
Received: from mail-ej1-f67.google.com ([209.85.218.67]:39368 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2901438AbgJ0TFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:05:19 -0400
Received: by mail-ej1-f67.google.com with SMTP id bn26so3786484ejb.6
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gjoqvamPf9t2527nhWMYi7LTxPXa9PsB/fcNwiHVC8w=;
        b=GGEuTNWfUds6zj8stVVFhkUPlkOcodU9gxb1IObABXVkZJ4NhQt7NwfSR5LMYYKMxa
         ODoGtqGm2cJc0vyBlWbjM4AGS2zHIOm6FE7glEMEcFLRHTfF/ipOHkpDuTvB3BwPepXZ
         v5fOWZl9H+RWRz77g/Q1mDM6naZURIO9kxnXA1MY/Q+oS88hNCyQtJR3n8xj7Y4tzPo/
         fHQQlB+rtYEb3mngZLGDPJI4i1TqRSLAcpjvdGUXpMADYaFzQyBMFajwvTOseQxcQYok
         BHkuQKXUZwHALvPn7msgAMUDT5vfwJmRUf9t/WbWCVaGf60wdVsmtAJrMo05u5o/Wef4
         Nt2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gjoqvamPf9t2527nhWMYi7LTxPXa9PsB/fcNwiHVC8w=;
        b=ItfcbI00nnhZx9ARF5Py34kJiX+Y7/2IE0dnPQ/KCqASJ1iM+q1R8ZLXlvJUApTnOv
         3JZSo7jySmOOjPdjWlUj19Tf2QzWddZsA2cDmXFti0DpsieF7pEIKFPi2tnwK+ojjtZH
         eGFDh0xj0EVMkvIqWjkieEAju5GUfoQx+N+Gzcm4ZtPKI4Y3G4+FNwHDx1+C8HYpxdlw
         jSAIDrMwAEOAkivjEUddQ8NswZmseg3PItBIV8Hy9MWuOEGSfN1JasSiFjhfV64N+8eW
         lXCV2o40JBvWQEx1uJDv7M7IxtjSlXiusd++vYBFKaj6FH24FsiG6210Ci58ch16JQiW
         HYDg==
X-Gm-Message-State: AOAM530JoYA8zzlfeEL0JRcp0Qtz2YXG8bLj9Hbf2BQNO904koqNt9yJ
        X8U57yBTIgyjsIMSow5aAXc=
X-Google-Smtp-Source: ABdhPJyh//Nt/ixj2YYt58MEjjDuW4e/jCNu6h7kR6CcdTgCCdHGMDxboHPcF0U2zyaRw9TgZ6Ibfg==
X-Received: by 2002:a17:906:539a:: with SMTP id g26mr4002695ejo.71.1603825485422;
        Tue, 27 Oct 2020 12:04:45 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm1518722edx.58.2020.10.27.12.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:04:44 -0700 (PDT)
Date:   Tue, 27 Oct 2020 21:04:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
Message-ID: <20201027190444.6cuug4zm6r7z4plm@skbuf>
References: <20201027105117.23052-1-tobias@waldekranz.com>
 <20201027160530.11fc42db@nic.cz>
 <20201027152330.GF878328@lunn.ch>
 <87k0vbv84z.fsf@waldekranz.com>
 <20201027193337.50f22df0@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027193337.50f22df0@nic.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 07:33:37PM +0100, Marek Behun wrote:
> > In order for this to work on transmit, we need to add forward offloading
> > to the bridge so that we can, for example, send one FORWARD from the CPU
> > to send an ARP broadcast to swp1..4 instead of four FROM_CPUs.
> 
> Wouldn't this be solved if the CPU master interface was a bonding interface?

I don't see how you would do that. Would DSA keep returning -EPROBE_DEFER
until user space decides to set up a bond over the master interfaces?
How would you even describe that in device tree?
