Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6086F3112B
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 17:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfEaPVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 11:21:12 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43935 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfEaPVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 11:21:11 -0400
Received: by mail-pg1-f193.google.com with SMTP id f25so4220009pgv.10;
        Fri, 31 May 2019 08:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+0Tr9vEtpNIU9gu0fEyXMYZNnfuGPbfVny8e35K7Kv0=;
        b=qa2Has4hjqsc9E22UmpYbTt4OdiyMl8szg8dXRLUHkfhZsEAtiaTBRBsWMUpjvqqdQ
         kJ0oj3H8MkAcWTEf5mXKFnGnPFlP6/mjyavNLJBLvwAnXccTiOmY05+EUnW3+o4cla3I
         GfBcVDycUWmmb6RmWZjDbSk5uF96LLc7RXBv3QRRKiVV9dRTigdw0u6MOwPv1cKQKIKR
         dcTBwCrLH/L9SeZ4kM5cwqKXFoA44SoEoB1/TcaJIDbWSnzUNamXH1IEqQYKHIDX4/Og
         QTOQnX75e4Pzpz6/NbfmC3Vgs8SYDA0+g1M22HGdW/cXS+BBOg+oQtM7yqVAV5tlSmH5
         aM7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+0Tr9vEtpNIU9gu0fEyXMYZNnfuGPbfVny8e35K7Kv0=;
        b=Wfw1anoiFr6TiEyMlxK4cvW0YRl10rXHa6CNeRDYzN+z7/W49Cn0hnjaOmrz+QN5xD
         Ku3NxZBGg8ervAMVaxj/P4Wi0cCGiMTXkCwfq0OhVjt4ZSFhCBkUrOmQbZ+t2JKgA7B8
         kABH1+OVQZz2mY8fMj2A5rB51OlVKOHbEFp3SGih5EQ/oGEsN4fqeJWVCLkVn39/7DjZ
         X5ILSMNbsl99FFYCWopI5D0JkQ0Y9j019PcOsVOplVHmMsWINtwN7qA4K+SVtmKG7JXR
         25QZ+1ONplH0CnFPSCEg6y7md3rUUJSPe5byQc1lyyegFOubD2Ejj10ydUoIWtO9uy5V
         wk8g==
X-Gm-Message-State: APjAAAVu3xv0ufUPeeIha2A1c5ISjMTCtL3V5AoIQeUeWdD9cF5H847h
        zkpsRy+OlTBLaA7N/IWbVC4=
X-Google-Smtp-Source: APXvYqyAPFnlaHrqF/GZwnXik6QwrjBv7CSby7C0zENM6QriBeQFnaUvjKpMk1wBgbOVPKf+OKzpIQ==
X-Received: by 2002:a63:1f04:: with SMTP id f4mr10131740pgf.423.1559316071156;
        Fri, 31 May 2019 08:21:11 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id j97sm5832998pje.5.2019.05.31.08.21.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 08:21:10 -0700 (PDT)
Date:   Fri, 31 May 2019 08:21:07 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/5] PTP support for the SJA1105 DSA driver
Message-ID: <20190531152107.24zux6grua3s6x22@localhost>
References: <CA+h21hpjsC=ie5G7Gx3EcPpazyxze6X_k+8eC+vw7JBvEO2zNg@mail.gmail.com>
 <20190530143037.iky5kk3h4ssmec3f@localhost>
 <CA+h21hpp68AEEykxr8bJB=uJ+b0tg881Z7Ao_OfbTAXNxS8WgQ@mail.gmail.com>
 <20190530150557.iur7fruhyf5bs3qw@localhost>
 <CA+h21hrBwR4Sow7q0_rS1u2md1M4bSAJt8FO5+VLFiu9UGnvjA@mail.gmail.com>
 <20190531043417.6phscbpmo6krvxam@localhost>
 <CA+h21hp9DfW3wFy4YbHMU31rBHyrnUTdF4kKwX36h9vHOW2COw@mail.gmail.com>
 <20190531140841.j4f72rlojmaayqr5@localhost>
 <CA+h21hroywaij3gyO0u6v+GFVO2Fv_dP_a+L3oMGpQH8mQgJ5g@mail.gmail.com>
 <20190531151151.k3a2wdf5f334qmqh@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531151151.k3a2wdf5f334qmqh@localhost>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 08:11:51AM -0700, Richard Cochran wrote:
> 
> 1. When the driver receives a deferred PTP frame, save it into a
>    per-switch,port slot at the driver (not port) level.
> 
> 2. When the driver receives a META frame, match it to the
>    per-switch,port slot.  If there is a PTP frame in that slot, then
>    deliver it with the time stamp from the META frame.

Actually, since the switch guarantees strict ordering, you don't need
multiple slots.  You only need to save one Rx'd PTP frame with its
switch-id and port-id.

Thanks,
Richard
