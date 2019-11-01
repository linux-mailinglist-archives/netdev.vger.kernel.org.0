Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEE8EC6E6
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 17:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbfKAQhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 12:37:16 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36736 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727626AbfKAQhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 12:37:16 -0400
Received: by mail-pf1-f193.google.com with SMTP id v19so7433903pfm.3
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 09:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9olrjEyMSdONJQExzLeQuTlD9WIBn8xFGfQKFRK23SA=;
        b=TrUwRCmZKfSwGm7+5QOUdF3n+cNW/SfojFp6SeI06G5ZYQa9L2nY9Nf9K47t17Jn1R
         9zDE5efa8h6AyqhZQyI+rm6Pd2/57csdFbUkvnr8UckOLLK4fm8GHsLFXzWvF54zJiN6
         afyHX4zymSBRNbBW9EMp2yHjjQ+zcVJGUqNlvgn5S6FS8tLrXu4rB+8DuzKQvG98JO3H
         MDvmr97zJ4MwsfelM//SxpRS7GBTbV5fiQrmxE4/P5ohdNZTtkyveuCC6rR/9vTajg5o
         oXT2Wy7jZk+KP0ZapdaICr8cAEyMEYARM4b8f5rtq6osz+8D8ExfoBQa1QZXwoKnATry
         R1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9olrjEyMSdONJQExzLeQuTlD9WIBn8xFGfQKFRK23SA=;
        b=LvLuMRO0OZSKuqeKWc7aM7HYAj6iLObedpR42GZkSUofVmAdjQLH9mtu3qPpsBtjRC
         1MWMrKnIvdS5itYZuA/QSGypD7wIxO+IxCTU3BDPtHfint/lyzu4n3wj3cPj9++Ze6e7
         NX3+DIQKQ7/jIg9/N6Bk1D7vj5Y0cPNah6ftNHaTAkPDHwxAIH8CSJBQ4VdL6z2dCZ9R
         PdQ2b5BHHycL4RtvrGr8IaS24fMyc75RbMe6UYaQ7VJiA9uDETdBlCkKxRfubgmol5rm
         RstC/ZJOu/JgEvS2mGr/lF4cFT0CqpCDEn9WTH1Kp2ETUAjElUcI8uLnO56/5szOIPnB
         tqjQ==
X-Gm-Message-State: APjAAAUQlJFOegHtXWW5lzT8+o9U92glEdCPE4A6MQNMIu1yuvdvExHv
        PJDxnBQPc+h9w2ql4bXxbo843g==
X-Google-Smtp-Source: APXvYqzOk7f+QogF16yViGBzV8zOr6xhGDRK3DK/FK/x1DTPgcRtVkpClfq/fW92njMlJcOzv1PnSw==
X-Received: by 2002:a17:90a:22a6:: with SMTP id s35mr16056921pjc.3.1572626234126;
        Fri, 01 Nov 2019 09:37:14 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k24sm6659105pgl.6.2019.11.01.09.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 09:37:13 -0700 (PDT)
Date:   Fri, 1 Nov 2019 09:37:05 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] ip-route: fix json formatting for multipath
 routing
Message-ID: <20191101093705.5f7ea85e@hermes.lan>
In-Reply-To: <f15a41a2-f861-550c-0f0b-5fc0b40db899@gmail.com>
References: <99a4a6ffec5d9e7b508863873bf2097bfbb79ec6.1572534380.git.aclaudi@redhat.com>
        <f15a41a2-f861-550c-0f0b-5fc0b40db899@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Oct 2019 10:11:23 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 10/31/19 9:09 AM, Andrea Claudi wrote:
> > json output for multipath routing is broken due to some non-jsonified
> > print in print_rta_multipath(). To reproduce the issue:
> > 
> > $ ip route add default \
> >   nexthop via 192.168.1.1 weight 1 \
> >   nexthop via 192.168.2.1 weight 1
> > $ ip -j route | jq
> > parse error: Invalid numeric literal at line 1, column 58
> > 
> > Fix this opening a "multipath" json array that can contain multiple
> > route objects, and using print_*() instead of fprintf().
> > 
> > This is the output for the above commands applying this patch:
> > 
> > [
> >   {
> >     "dst": "default",
> >     "flags": [],
> >     "multipath": [
> >       {
> >         "gateway": "192.168.1.1",
> >         "dev": "wlp61s0",
> >         "weight": 1,
> >         "flags": [
> >           "linkdown"
> >         ]
> >       },
> >       {
> >         "gateway": "192.168.2.1",
> >         "dev": "ens1u1",
> >         "weight": 1,
> >         "flags": []
> >       }
> >     ]
> >   }
> > ]
> > 
> > Fixes: f48e14880a0e5 ("iproute: refactor multipath print")
> > Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> > Reported-by: Patrick Hagara <phagara@redhat.com>
> > ---
> >  ip/iproute.c | 23 +++++++++++++++++------
> >  1 file changed, 17 insertions(+), 6 deletions(-)
> >   
> 
> This is fixed -next by 4ecefff3cf25 ("ip: fix ip route show json output
> for multipath nexthops"). Stephen can cherry pick it for master

Sure, cherry-picked the other commit (it was clean)
