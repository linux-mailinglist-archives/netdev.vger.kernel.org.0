Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19EFF161ED0
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 03:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgBRCFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 21:05:20 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42399 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbgBRCFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 21:05:20 -0500
Received: by mail-pg1-f194.google.com with SMTP id w21so10136474pgl.9
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 18:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=44aPxottmg4tlMVIsoggokzIejN9F/nYZzOhak9olnk=;
        b=ITLpJhnJOXFbX5kxqAIrsKVZD2MudPmpRr0bMuXpO1AQBFoeKpxsFAfKYn/DqDbOEr
         LfPEziUOMnNbWlr3mQLrDnn61RuFWaOYtYvg/9shI6f/NpqHezgT0k1sv8mvrPcIr4dy
         UE6uLc83lS03Fk5undB3jX9eYVl+3ibDzPW7of+E3PehNnOj3nRIGfYT+sFLKkRoKnUZ
         wLf13U8utYsyYO7fPE6yzIGMBn5VolrZkkxBh4MZbBWciCx2gbuo75PQz2OgoCR+ZMAT
         CjZ22aSk0EpshVNanGszLY4G6iDYypLOrtEW0DVHF/LVT8wgDIl4Q9JsIMk3plA9aEVl
         uaJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=44aPxottmg4tlMVIsoggokzIejN9F/nYZzOhak9olnk=;
        b=ddhG5cOeLcLdzn7+37Ao7RzCLBEuegFZlEsey4qhaHsEyIcnU1IwDAu9iXxXJgJ2SL
         QrLVbO/ZAnlfWKB/PVN7yQqF/iQ6EqIxCzREaAmdSBe8ZJvR26zX/JQqTEBhCtBo//2D
         AxQMUfAS2xcbg7Bg9Mop5c7lYJZn3sjjAmocs6tN8knEFV/NBl8m98TNj9azQ+q5UqKP
         THh0+6Iz+7e9gmHqQnKMyfvHydgZsX6xoVy2Vlh9pfP1iLytAl270M8mc09fMx2+re/M
         4q7DFCh5kyUfxUcvLUoz8LDWBlkdjgE/itAbnsC/K5tfRASSQHohDnul2ZnJEAlHtnHl
         X32Q==
X-Gm-Message-State: APjAAAUr3HBp2pUJeX9Ay7TjA5bcM0r2D36g+Pvw99opjuYYfmRQXyud
        mkQ93QrtrvcA+Lm+VamrIjrEBIm24hM=
X-Google-Smtp-Source: APXvYqzD5znAhIAk/77GyMMx4FqV+TrjruZ6YbvSqIQd3e/04TOpVotihrYDSKW4KczRchEkUo8cfA==
X-Received: by 2002:a62:788a:: with SMTP id t132mr19285876pfc.134.1581991519360;
        Mon, 17 Feb 2020 18:05:19 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g19sm1626487pfh.134.2020.02.17.18.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 18:05:18 -0800 (PST)
Date:   Tue, 18 Feb 2020 10:05:08 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Petr Machata <petrm@mellanox.com>
Cc:     Petr Machata <pmachata@gmail.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Dawson <petedaws@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH net] selftests: forwarding: vxlan_bridge_1d: fix tos value
Message-ID: <20200218020508.GQ2159@dhcp-12-139.nay.redhat.com>
References: <20200213094054.27993-1-liuhangbin@gmail.com>
 <87a75msl7i.fsf@mellanox.com>
 <20200214025308.GO2159@dhcp-12-139.nay.redhat.com>
 <875zg9qw1a.fsf@mellanox.com>
 <20200217025904.GP2159@dhcp-12-139.nay.redhat.com>
 <87r1ytpkdu.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1ytpkdu.fsf@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 11:40:13AM +0100, Petr Machata wrote:
> >> > Thanks for this remind. I re-checked the tos definition and found a summary
> >> > from Peter Dawson[1].
> >> >
> >> > IPv4/6 Header:0 |0 1 2 3 |0 1 2 3 |0 1 2 3 |0 1 2 3 |
> >> > RFC2460(IPv6)   |Version | Traffic Class   |        |
> >> > RFC2474(IPv6)   |Version | DSCP        |ECN|        |
> >> > RFC2474(IPv4)   |Version |  IHL   |    DSCP     |ECN|
> >> > RFC1349(IPv4)   |Version |  IHL   | PREC |  TOS   |X|
> >> > RFC791 (IPv4)   |Version |  IHL   |      TOS        |
> >
> > As the commit said, we should not use config tos directly. We should remove
> > the precedence field based on RFC1349 or ENC field based on RFC2474.
> 
> Well, RFC1349 didn't know about DSCP. I do not think it is possible to
> conform to both RFC1349 and RFC2474 at the same time.

No, we can't. I mean no mater based on RFC1349 or RFC2474, we should not use
the config tos directly.

> 
> RFC2474 states that "DS field [...] is intended to supersede the
> existing definitions of the IPv4 TOS octet [RFC791] and the IPv6 Traffic
> Class octet [IPv6]". So the field should be assumed to contain DSCP from
> that point on. In my opinion, that makes commit 71130f29979c incorrect.
> 
> (And other similar uses of RT_TOS in other tunneling devices likewise.)

Yes, that's also what I mean, should we update RT_TOS to match
RFC2474?

Thanks
Hangbin
