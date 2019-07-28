Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E17578068
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 18:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfG1QPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 12:15:37 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44956 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfG1QPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 12:15:37 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so26989385pgl.11
        for <netdev@vger.kernel.org>; Sun, 28 Jul 2019 09:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c8uhXnPXa6dBED7NJxA3J6lTYF7EaEpdCPqzZY/Iye8=;
        b=HZE17vQ16Rt3kKpYhOwuAUfO9APDe7Fsuaup86nRz1dBvU8jJzFB7g3xRtRyckEIwi
         HCZyHtXe9CRMLjc27wfC75OoGWsmr5h8AU8Xz+IE5G9Lq/PYzKDevcrjOMCJLuPouKD/
         aLy55MPf4uIfdcV84kH7+X7Cyd11DBETDPqN1CFZrEx47k9jpu+dQja+X8rFcgCKOeK5
         /Kit597FoPiCPHIq+j5dOrVJbwOQUTKKDu12JpydBDNtakVXY9A+mzpAze4APSE64wje
         x8O0ThOOcCmfsS7PQoDc3OQtDHj29WYOOZKXSRem8BkAEuSWx6YY8HeSKybWAhNWTTpi
         2+5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c8uhXnPXa6dBED7NJxA3J6lTYF7EaEpdCPqzZY/Iye8=;
        b=MDdXJhKX4lCTFljaWJ0OJVdEZh2sM5mUFMouOp9f2V3d6DhV3XKbIr2i1iABtLXYpI
         pClvp1R833t2t0fg5VsGUhr/HID56tDr0IMspZc232kr9316zbA3fjHDQ3vtIhXvDQ8L
         AapbIaDQzk8S+i5uoY9EMjXNnLJuvxiD7i9ZOHqA0b+o8cb1kH0pJ2kIL0mFtcfhXMYI
         5NU+VMOh+dRnlrKzqrja2/ZjZQYwG1Pj4G+Oe/GKRjfoSKcxxHA1X4KCBIxQSZ2I/7/M
         ex5cLY4CrFw6QgMDmendhgc8b1AoCE8AAWeNKwdl4K+1xcU9cmwOeUdaCvChdcBgDybl
         Drgw==
X-Gm-Message-State: APjAAAVYpyUQByMSlicL7QF/cYThqmAN/RRe30cYTLtwN92ayJTTdYYM
        scSlbn7Vi7f1qDN5HRcbJ8uuPvLV
X-Google-Smtp-Source: APXvYqxzb9INvfKDJtqhVULbD0xzM6gDOWT9GJyEg/bsgFNqE743K6Yjws6tt7krB2eTGoHvdIgwpg==
X-Received: by 2002:a63:30c6:: with SMTP id w189mr97144163pgw.398.1564330536028;
        Sun, 28 Jul 2019 09:15:36 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v12sm50665153pjk.13.2019.07.28.09.15.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 28 Jul 2019 09:15:35 -0700 (PDT)
Date:   Sun, 28 Jul 2019 09:15:28 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Michael Ziegler <ich@michaelziegler.name>
Cc:     netdev@vger.kernel.org
Subject: Re: ip route JSON format is unparseable for "unreachable" routes
Message-ID: <20190728091528.0cf18c74@hermes.lan>
In-Reply-To: <6e88311b-5edc-4c62-1581-0f5b160a5f4e@michaelziegler.name>
References: <6e88311b-5edc-4c62-1581-0f5b160a5f4e@michaelziegler.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Jul 2019 13:09:55 +0200
Michael Ziegler <ich@michaelziegler.name> wrote:

> Hi,
> 
> I created a couple "unreachable" routes on one of my systems, like such:
> 
> > ip route add unreachable 10.0.0.0/8     metric 255
> > ip route add unreachable 192.168.0.0/16 metric 255  
> 
> Unfortunately this results in unparseable JSON output from "ip":
> 
> > # ip -j route show  | jq .
> > parse error: Objects must consist of key:value pairs at line 1, column 84  
> 
> The offending JSON objects are these:
> 
> > {"unreachable","dst":"10.0.0.0/8","metric":255,"flags":[]}
> > {"unreachable","dst":"192.168.0.0/16","metric":255,"flags":[]}  
> "unreachable" cannot appear on its own here, it needs to be some kind of
> field.
> 
> The manpage says to report here, thus I do :) I've searched the
> archives, but I wasn't able to find any existing bug reports about this.
> I'm running version
> 
> > ip utility, iproute2-ss190107  
> 
> on Debian Buster.
> 
> Regards,
> Michael.

Already fixed upstream by:

commit 073661773872709518d35d4d093f3a715281f21d
Author: Matteo Croce <mcroce@redhat.com>
Date:   Mon Mar 18 18:19:29 2019 +0100

    ip route: print route type in JSON output
    
    ip route generates an invalid JSON if the route type has to be printed,
    eg. when detailed mode is active, or the type is different that unicast:
    
        $ ip -d -j -p route show
        [ {"unicast",
                "dst": "192.168.122.0/24",
                "dev": "virbr0",
                "protocol": "kernel",
                "scope": "link",
                "prefsrc": "192.168.122.1",
                "flags": [ "linkdown" ]
            } ]
    
        $ ip -j -p route show
        [ {"unreachable",
                "dst": "192.168.23.0/24",
                "flags": [ ]
            },{"prohibit",
                "dst": "192.168.24.0/24",
                "flags": [ ]
            },{"blackhole",
                "dst": "192.168.25.0/24",
                "flags": [ ]
            } ]
    
    Fix it by printing the route type as the "type" attribute:
    
        $ ip -d -j -p route show
        [ {
                "type": "unicast",
                "dst": "default",
                "gateway": "192.168.85.1",
                "dev": "wlp3s0",
                "protocol": "dhcp",
                "scope": "global",
                "metric": 600,
                "flags": [ ]
            },{
                "type": "unreachable",
                "dst": "192.168.23.0/24",
                "protocol": "boot",
                "scope": "global",
                "flags": [ ]
            },{
                "type": "prohibit",
                "dst": "192.168.24.0/24",
                "protocol": "boot",
                "scope": "global",
                "flags": [ ]
            },{
                "type": "blackhole",
                "dst": "192.168.25.0/24",
                "protocol": "boot",
                "scope": "global",
                "flags": [ ]
            } ]
    
    Fixes: 663c3cb23103 ("iproute: implement JSON and color output")
    Acked-by: Phil Sutter <phil@nwl.cc>
    Reviewed-and-tested-by: Andrea Claudi <aclaudi@redhat.com>
    Signed-off-by: Matteo Croce <mcroce@redhat.com>
    Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
