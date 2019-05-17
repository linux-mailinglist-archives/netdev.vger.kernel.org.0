Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D742621A13
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 16:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbfEQOxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 10:53:01 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44069 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728968AbfEQOxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 10:53:01 -0400
Received: by mail-pf1-f193.google.com with SMTP id g9so3791537pfo.11
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 07:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k861ZzcXOI7SlsZz3F755giJdwTPf49mrIy7dM2Cg60=;
        b=wn5Giblwh/qXwIqxrp2HWzBy2g4S3DGFffnmEVq6N0kuRT8R+hh8DbbKSV7LQEBXSt
         YzQZx/E0kjvDzmCAwdNddJhIdtiYYEEOZNAPlSUUpSPL628OSR/0lsNmEtBxkjAZp82u
         bNAvZ/qaCgnWST9G2Y6899Iz35pnVxTHMTSeqwd4KnZ6aKYYRH2ooA2gvNGAjLBJ1nth
         JgNlzS4bubYG3vG+KwIkeQEEfJS4+BUxvUJVV3ajOJ3n9WczqWFjxeqhZq8OY1peV12N
         V30BllbAuGzgBNWmQ+1hMfzoYJDfV+dbidzRSWBftEj8DEYvskkGZuENtrtZM2+2smsE
         tVxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k861ZzcXOI7SlsZz3F755giJdwTPf49mrIy7dM2Cg60=;
        b=G6vH0xXt8gogt+++LNEY4VmgXCuPf6T7nFS4yTO8l/5VjlDcvVxKM8AdHQLixsbLFX
         b6N+oYm16F5W2DSh2T1JKC1ZXmT6L5rFkD4o2WtffO9/tKiShcW08o+Ohh+PS4xXOBBh
         xBTq1t4QaumrvfGuic19cTJi+9fXf8h+bZKRHiauBCIZgfLed3ne1YGk0j7vnMXtHyGM
         gzgryuhFGDKoKGDExG3VFL/+mqr06Z9cpYsap+5Oc8lZggrqon7IUbaVqzMVq8zFSGtj
         ljzjmANUhta5Zg9/TzxIKLLnRbyWd0ONEMsbEgBHVUQiUIBORGi7irmZ+dcNUflZ3Ld5
         UbUA==
X-Gm-Message-State: APjAAAXBzY7hJoHWDzrUfsizzKX5BT6pPMggc/6ApClfp6oG6BqnQnIF
        zTTkuaYp4c06v8ErWtKuInqGJ2B7QcI=
X-Google-Smtp-Source: APXvYqzZq3gvOysbnEbehuZi88/LTrgsyFyiQg2XZY3c3XgBU20xpjqDf2tjt234u9heY5SEwfox8w==
X-Received: by 2002:aa7:81ca:: with SMTP id c10mr11984921pfn.163.1558104780205;
        Fri, 17 May 2019 07:53:00 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 37sm13193688pgn.21.2019.05.17.07.52.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 May 2019 07:53:00 -0700 (PDT)
Date:   Fri, 17 May 2019 07:52:53 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2-next] treewide: refactor help messages
Message-ID: <20190517075253.3a40f48f@hermes.lan>
In-Reply-To: <20190517133828.2977-1-mcroce@redhat.com>
References: <20190517133828.2977-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 May 2019 15:38:28 +0200
Matteo Croce <mcroce@redhat.com> wrote:

> Every tool in the iproute2 package have one or more function to show
> an help message to the user. Some of these functions print the help
> line by line with a series of printf call, e.g. ip/xfrm_state.c does
> 60 fprintf calls.
> If we group all the calls to a single one and just concatenate strings,
> we save a lot of libc calls and thus object size. The size difference
> of the compiled binaries calculated with bloat-o-meter is:
> 
>         ip/ip:
>         add/remove: 0/0 grow/shrink: 5/15 up/down: 103/-4796 (-4693)
>         Total: Before=672591, After=667898, chg -0.70%
>         ip/rtmon:
>         add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-54 (-54)
>         Total: Before=48879, After=48825, chg -0.11%
>         tc/tc:
>         add/remove: 0/2 grow/shrink: 31/10 up/down: 882/-6133 (-5251)
>         Total: Before=351912, After=346661, chg -1.49%
>         bridge/bridge:
>         add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-459 (-459)
>         Total: Before=70502, After=70043, chg -0.65%
>         misc/lnstat:
>         add/remove: 0/1 grow/shrink: 1/0 up/down: 48/-486 (-438)
>         Total: Before=9960, After=9522, chg -4.40%
>         tipc/tipc:
>         add/remove: 0/0 grow/shrink: 1/1 up/down: 18/-62 (-44)
>         Total: Before=79182, After=79138, chg -0.06%
> 
> While at it, indent some strings which were starting at column 0,
> and use tabs where possible, to have a consistent style across helps.
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Looks good thanks, I had been doing this bit by bit over time.
