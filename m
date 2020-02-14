Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 629E915D033
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 03:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgBNCxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 21:53:20 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46221 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727988AbgBNCxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 21:53:20 -0500
Received: by mail-pg1-f195.google.com with SMTP id b35so4042809pgm.13
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 18:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/RYmTHKDlAJmj61zB+5XESJ8Xf1mxuR1YO0mIKa2Sec=;
        b=mFY5QO10qW6qhT5Tnkc+9lOYAyVpjASiE2OO99kNiKEVs9L+Jw/4i2WxSKwUTo914K
         RefhgtN3dXuiAGUPq6n9azugWtW6juI8dy9gRQ4dgkT+Ii5zHmlKOYSWlvU6/tJFlG2a
         lkA6j4o/YY8YRPd3DjnhOcGgkpEyvW3v8YEpLkvlmCq7GwSF4Iz6bO+ic6VwS7p62Txb
         mSQbxiQIOmy75/JFpdC13ZJ3CDbKJ3c/boiTj2SbFmu0HkoQgplMoFMW/1ldAgnE7HRa
         dtBaZ9PnHfGjzpu93+Wh3UVuPDsL2flgjH8lJakJT1Zq27fL4kA+NymTE4uNpi+T0SQ5
         cQ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/RYmTHKDlAJmj61zB+5XESJ8Xf1mxuR1YO0mIKa2Sec=;
        b=T4vYrNfhQMOw5nrMRpAKZM3b6UJRh67YBe3pc7RnuBPuGPRNu3YXqTlq6B+8aHmecn
         3eHPlNv+WkFyADVQ6jTj8W5AfqXLxIs5HrJRko3htRqKZoRq+4qB2uQNYDRVfcQRgegl
         /axlco06BW9yXMXp2N41RVw2R2rMZybR2J4hKrZFADJRnDDBfQw+ODwff4zC7aE1mpYM
         dBMXoLoo+64vNhvVgFHdFpA/Ij00uBQSj+MSHjpUx6JYwqV1Cqx8DyuOa8eH4GZ5++1X
         tXdA6zXIhNG69A8IlI63XCXuPYpNzfhh2RO08e6z5aqfmhsfcI/sxNE+OT5bxofqNDoG
         HY8w==
X-Gm-Message-State: APjAAAVrY7hjw7MCNZAVVs0gIbFOQbjOX2tXLw3q6gvbKobigc7GXNkv
        7tYT+rUa3o3vQEGJ1qcK8smuXTLJz7g=
X-Google-Smtp-Source: APXvYqxmKjhle6r6I2rzFyIQvJG86jsdgiOwv7J1f6gJcr2G61HXCbzj0GuDKzi3p8zfjGB+85v3tQ==
X-Received: by 2002:a63:504f:: with SMTP id q15mr1126048pgl.8.1581648799862;
        Thu, 13 Feb 2020 18:53:19 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u12sm4583324pgr.3.2020.02.13.18.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 18:53:19 -0800 (PST)
Date:   Fri, 14 Feb 2020 10:53:09 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Petr Machata <pmachata@gmail.com>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Dawson <petedaws@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH net] selftests: forwarding: vxlan_bridge_1d: fix tos value
Message-ID: <20200214025308.GO2159@dhcp-12-139.nay.redhat.com>
References: <20200213094054.27993-1-liuhangbin@gmail.com>
 <87a75msl7i.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a75msl7i.fsf@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 01:52:49PM +0100, Petr Machata wrote:
> 
> Hangbin Liu <liuhangbin@gmail.com> writes:
> 
> > After commit 71130f29979c ("vxlan: fix tos value before xmit") we start
> > strict vxlan xmit tos value by RT_TOS(), which limits the tos value less
> 
> I don't understand how it is OK to slice the TOS field like this. It
> could contain a DSCP value, which will be mangled.

Thanks for this remind. I re-checked the tos definition and found a summary
from Peter Dawson[1].

IPv4/6 Header:0 |0 1 2 3 |0 1 2 3 |0 1 2 3 |0 1 2 3 |
RFC2460(IPv6)   |Version | Traffic Class   |        |
RFC2474(IPv6)   |Version | DSCP        |ECN|        |
RFC2474(IPv4)   |Version |  IHL   |    DSCP     |ECN|
RFC1349(IPv4)   |Version |  IHL   | PREC |  TOS   |X|
RFC791 (IPv4)   |Version |  IHL   |      TOS        |

According to this I think our current IPTOS_TOS_MASK should be updated to 0xFC
based on RFC2474. But I'm not sure if there will have compatibility issue.

What do you think?

> >  	tc filter add dev v1 egress pref 77 prot ip \
> > -		flower ip_tos 0x40 action pass
> > -	vxlan_ping_test $h1 192.0.2.3 "-Q 0x40" v1 egress 77 10
> > -	vxlan_ping_test $h1 192.0.2.3 "-Q 0x30" v1 egress 77 0
> > +		flower ip_tos 0x11 action pass
> > +	vxlan_ping_test $h1 192.0.2.3 "-Q 0x11" v1 egress 77 10
> > +	vxlan_ping_test $h1 192.0.2.3 "-Q 0x12" v1 egress 77 0
> 
> 0x11 and 0x12 set the ECN bits, I think it would be better to avoid
> that. It works just as well with 0x14 and 0x18.

Thanks, I will update it.

[1] https://lore.kernel.org/patchwork/patch/799698/#992992

Regards
Hangbin
