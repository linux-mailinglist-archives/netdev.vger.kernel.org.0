Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08C666419C
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 08:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfGJGzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 02:55:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40289 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfGJGzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 02:55:41 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so988297wmj.5;
        Tue, 09 Jul 2019 23:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YmPlcvb5bObvvDqCeZdD+v5H0phZt2AX9Ycj4zrkFrk=;
        b=ftOUDOpkpab4eKuULhmrS+FRLyxVGC8+twax0G/we2OtMAwdLncDIdGpusWvby4wXx
         qaw+gRSt5+Ndd0+73JmbFNQzlTuiSuqpqRy/NLPOucRMiHZGuY1KiXFgCHlKc4jkTmIS
         mzIpZsj5ZjF35wRnL9wZc3ck5KqcxXUfffThPNv1l2da+xc0IOHRqsO2Nr4/RQBxdSnP
         +2f+m9SJiaHvwPRBJly9/5dNyl2QqrNiu1NNGojridE4P/SMWCHO11eCumK1+OPbiqFS
         Uz5YMXYLKjqmZIiNVKgpTtig9JIMuXm9y5LliSjb0v4mJWL14ZwmNy5BY+Dp/74t5BVF
         cJJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YmPlcvb5bObvvDqCeZdD+v5H0phZt2AX9Ycj4zrkFrk=;
        b=NVmRtX4yBATxwKOSn6r+tRtzBDX5ESnx/EB8pWXmgSeSuZzqJdRayJGMculvaUzEtG
         ow+Ns888wbGAF+Xd4qRCxOowwOjSC9768B4Kej3QutneL6vP14TGtBlVpeEv/SmXAndI
         XOc1iNe5KQ6Obfl/DEOPmmEfvgTTl3B8LFsM8QeWVSKmzhBcl9M9QDESc6+nYR2f+BoM
         WbCm+Eak4R9aXNj5m9w9f35w5/cg7tBfnZhBEVxgwLefS/z3lCsT6j6OHh/WpmI3p6kr
         hiO9lOxWKGKitQ34MicTLgTSgmOhRFBoBk/Bw82MzkGwTmgrLedf85/6/CdTFkHdLdnx
         fZgA==
X-Gm-Message-State: APjAAAVKgYwAWRuAg11J34TnrJEfjqFYvdXyXmZ+6FOhaTliD2fbWVJS
        AprYj5ir1IbYsQKzqWypq7B1ARmRrOT9F974mUf4Cw==
X-Google-Smtp-Source: APXvYqyV2cje4br2rvgWCpo7VzxXeoAlp013bbyW0+MTW7YLqXKiMA05H4WdDY0Cs2F7BdYU2RCmh50AVLQ0O5HeUQ0=
X-Received: by 2002:a05:600c:c4:: with SMTP id u4mr3399884wmm.96.1562741738878;
 Tue, 09 Jul 2019 23:55:38 -0700 (PDT)
MIME-Version: 1.0
References: <CANpxKHHXzrEpJPSj3x83+WE23G1W0KPz9XbG=fCVzS21+-BpfQ@mail.gmail.com>
 <20190626111322.gks5qptax3iqrjao@breakpoint.cc>
In-Reply-To: <20190626111322.gks5qptax3iqrjao@breakpoint.cc>
From:   Naruto Nguyen <narutonguyen2018@gmail.com>
Date:   Wed, 10 Jul 2019 13:55:25 +0700
Message-ID: <CANpxKHGa6DpV-9n8La7wh6r7MbEZpzGTWOO1AhmhWv072b4LAg@mail.gmail.com>
Subject: Re: Question about nf_conntrack_proto for IPsec
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

Thanks a lot for your reply.

Could you please elaborate more on how generic tracker tracks ESP connection?

Brs,
Bao

On Wed, 26 Jun 2019 at 18:13, Florian Westphal <fw@strlen.de> wrote:
>
> Naruto Nguyen <narutonguyen2018@gmail.com> wrote:
> > In linux/latest/source/net/netfilter/ folder, I only see we have
> > nf_conntrack_proto_tcp.c, nf_conntrack_proto_udp.c and some other
> > conntrack implementations for other protocols but I do not see
> > nf_conntrack_proto for IPsec, so does it mean connection tracking
> > cannot track ESP or AH protocol as a connection. I mean when I use
> > "conntrack -L" command, I will not see ESP or AH  connection is saved
> > in conntrack list. Could you please help me to understand if conntrack
> > supports that and any reasons if it does not support?
>
> ESP/AH etc. use the generic tracker, i.e. only one ESP connection
> is tracked between each endpoint.
