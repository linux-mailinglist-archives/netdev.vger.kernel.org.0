Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F13811621F1
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 09:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgBRIAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 03:00:36 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42062 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgBRIAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 03:00:36 -0500
Received: by mail-pl1-f194.google.com with SMTP id e8so7749511plt.9
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 00:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Dm/sGfYdMvjyQYkkd21rkvl9rEckkFP1HBweiRWiBjQ=;
        b=Oi6LfA4trdmyx1Umigih3vj8QyFcgEQV5QYtiCUg6rcoHsQLsRyDPDQtiaPk/GnrB5
         fzoFfce5QLmyLZS33hti9zkYyIPULorKjlAF0VJmRmRC8vrUdFQHL3s19SGFdM5d5Efz
         qAeyhWKRRRT1kcx6W8q4wUddtMxysYt7zstA3wkkjJVYh9Z6mnjr3UFRdwQREL3FidlB
         Kn1cE8vKhCMh0B8sywd4T3K115vV6QlUSukUq6uT/jXROLDlwiNQk25Rh8G+um5okPMI
         LS5CKELGziDX1DLcS71V3/rgsGOkoffVJFH0ofmgrcN6+PCQPTFPcwFysxG3Uyu8lQL3
         RTYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Dm/sGfYdMvjyQYkkd21rkvl9rEckkFP1HBweiRWiBjQ=;
        b=CSFkezcAEEyQkBUJJo26QSGH64FHpAD2I7we7kqjYntcG6UajMs3G2pECBL5r2a2f0
         KSMWviELgFNjvsK7J0q3KsYHFIP0hmXnxWePISveLbuWkDpMYssUReA4J7Hb2lwAMnlG
         tZjwG3xRYuHAiwrhFM04FAYAbra8mneAU2xNnOmDX1z+Lq/JVLVRa8958mZuIKc3WcnX
         YPiMJM1s8Gqjk1gHtmc7hVJPkzaSnAqDbBZl6NQaz/Za6p5mKjANcV2CWQ3x7Dkg7KKV
         UvvadLGWEt6DhTyxmS5Tquhakdxd7lDQGoNjV21GaZSEnxoxrbHFOZEoHV+IVpQtnqQT
         H/2g==
X-Gm-Message-State: APjAAAX5PQ+1rJ9X9WzbDLwlyP7zwMM+iBR/W7XJSdAh48NcYEMd+VI8
        nzU+bqofv5KrYzY1L6bLXG0=
X-Google-Smtp-Source: APXvYqwrACXjr19VP4zyBc9BGjAVljhWpMF79ujUTVORK/FJG4wSXE7TrLHBLACxXv1pdrWQcH8coQ==
X-Received: by 2002:a17:902:9a06:: with SMTP id v6mr3023252plp.304.1582012835366;
        Tue, 18 Feb 2020 00:00:35 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t11sm1949032pjo.21.2020.02.18.00.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 00:00:34 -0800 (PST)
Date:   Tue, 18 Feb 2020 16:00:24 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     petrm@mellanox.com, pmachata@gmail.com, netdev@vger.kernel.org,
        idosch@mellanox.com, petedaws@gmail.com, daniel@iogearbox.net
Subject: Re: [PATCH net] selftests: forwarding: vxlan_bridge_1d: fix tos value
Message-ID: <20200218080024.GR2159@dhcp-12-139.nay.redhat.com>
References: <20200217025904.GP2159@dhcp-12-139.nay.redhat.com>
 <87r1ytpkdu.fsf@mellanox.com>
 <20200218020508.GQ2159@dhcp-12-139.nay.redhat.com>
 <20200217.190118.1525770684039829483.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217.190118.1525770684039829483.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi David,

Thanks for the comments. Please see the reply below.
On Mon, Feb 17, 2020 at 07:01:18PM -0800, David Miller wrote:
> > On Mon, Feb 17, 2020 at 11:40:13AM +0100, Petr Machata wrote:
> >> RFC2474 states that "DS field [...] is intended to supersede the
> >> existing definitions of the IPv4 TOS octet [RFC791] and the IPv6 Traffic
> >> Class octet [IPv6]". So the field should be assumed to contain DSCP from
> >> that point on. In my opinion, that makes commit 71130f29979c incorrect.
> >> 
> >> (And other similar uses of RT_TOS in other tunneling devices likewise.)
> > 
> > Yes, that's also what I mean, should we update RT_TOS to match
> > RFC2474?
> 
> The RT_TOS() value elides the two lowest bits so that we can store other
> pieces of binary state into those two lower bits.


In my understanding, RT_TOS() only omit the lowest bits and first 3 bit, as
it defined like:
#define RT_TOS(tos)     ((tos)&IPTOS_TOS_MASK)
#define IPTOS_TOS_MASK          0x1E

> IPv4/6 Header:0 |0 1 2 3 |0 1 2 3 |0 1 2 3 |0 1 2 3 |
> RFC2474(IPv4)   |Version |  IHL   |    DSCP     |ECN|
> RFC1349(IPv4)   |Version |  IHL   | PREC |  TOS   |X|

This looks that it's based on rfc1349. At the same time, we have function
INET_ECN_encapsulate() to respect of rfc2474, which elides the two lowest
bits to stor ECN.

But this two has some conflicts. RT_TOS() omit config tos with 3 PREC bits
and 1 ECN bit. INET_ECN_encapsulate() then omit 1 more ECN bits and set
new ECN based on inner header.

Petr mentioned(and I agree) that this would make us lost 3 DSCP bit info.
So what I though is we should update IPTOS_TOS_MASK to 0xFC, so we can
catch all DSCP field from config tos and leave the two lowest ECN bit
to INET_ECN_encapsulate().

> 
> So you can't just blindly change the RT_TOS() definition without breaking
> a bunch of things.

Yes, RT_TOS() was used in many places. I'm also afraid it may break
some old configs. But then I found that the current IPTOS_TOS_MASK
is more strict. It only take 4 bits(and 1 bit will be overwrite by ECN bit
later) from tos config. If we update it to 0xFC, it would take more
bits.

So what do you think?

Thanks
Hangbin
