Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACB0BD660
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 04:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411385AbfIYC25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 22:28:57 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44700 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411378AbfIYC25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 22:28:57 -0400
Received: by mail-pg1-f193.google.com with SMTP id g3so2304052pgs.11
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 19:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bQndJhkaMXLngsphDYHShvkGOldkC5gIqO9lj9AiKjw=;
        b=vX2VewPIzSIuCSCyhbqL14HJtdM9b+8lVBfaJNIViUucxs9NdOuEkPZTPI65UZfU/+
         Axkispnv2laKImKnttk/LwJJ+TfE+Ap/SYSgtVqd1O8D03WSyXjvfQkszguokLfTSl8j
         onAwJNid19E0Fl+hLmi1rnqqH+EBcCo+IcZ8cnPPWCOon37+HJjIffp7X0NI8n54ZFPD
         btK5Xb6RI6iv6SFMNshh89KY0DqB/HvJwCPjAhLEPKGgwnVaYHm23zjyP/iYglViRRxN
         kekWAwBxUojyFRodS4xJTmURsgCPV6z0lN312fzhyTvq+vU5X632g8T9bWeomjQ/wt6p
         zymg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bQndJhkaMXLngsphDYHShvkGOldkC5gIqO9lj9AiKjw=;
        b=X06bA6Yn0OM9OK0yTecGxrEUucNXFcSdSF1amlTGkViLcomIF8+5JZZ4pz/6hBsySh
         NxIRgD899eXXZjFUblunL0r8zQWsHvj7EK8L74ln0ymeeuUdpw7bShtZr+mn6+MgboQW
         PvqgWfe+Qk4sVym13BJ/A7+TVX81tXHDHu19C3JW/KbGsG+I6gIB7mo+snTQtDaAGu6+
         dR8OQHcyYcxSl4Fspji1zB367PpVFbiViTBYGl7UimHWXVhvXZaTPHHlbxskWcZTM7y2
         x6fhRNEkAq9vBJd6Logoy4u3Fxb8A+Ro/sKM83EcD+hMz3ws1LPP1Z9X4yN28myuCZxa
         KIAg==
X-Gm-Message-State: APjAAAU4Xo10B7xWhfdldnqiCdCTieRHo2hC9tRYewe7KjbkLjuRBswb
        7wFTIuLR4uK7KUckMBSCxvWgyOpM
X-Google-Smtp-Source: APXvYqzFJDthH0jG97cLQtPmz5RTKG92V1kJd0vvjiD10NC0tCHNv9zsUE3seY2xDNs4KRvih8XOAA==
X-Received: by 2002:a63:cb:: with SMTP id 194mr6267530pga.172.1569378536096;
        Tue, 24 Sep 2019 19:28:56 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:d0ff:3f4b:4803:5f77])
        by smtp.googlemail.com with ESMTPSA id x6sm6617444pfd.53.2019.09.24.19.28.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 19:28:54 -0700 (PDT)
Subject: Re: Fw: [Bug 204903] New: unable to create vrf interface when
 ipv6.disable=1
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <20190919104628.05d9f5ff@xps13>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a15f9952-e5ed-8358-e28d-6325bf4d5801@gmail.com>
Date:   Tue, 24 Sep 2019 20:28:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190919104628.05d9f5ff@xps13>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/19 2:46 AM, Stephen Hemminger wrote:
> 
> 
> Begin forwarded message:
> 
> Date: Wed, 18 Sep 2019 15:15:42 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 204903] New: unable to create vrf interface when ipv6.disable=1
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=204903
> 
>             Bug ID: 204903
>            Summary: unable to create vrf interface when ipv6.disable=1
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 5.2.14
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>           Assignee: stephen@networkplumber.org
>           Reporter: zhangyoufu@gmail.com
>         Regression: No
> 
> `ip link add vrf0 type vrf table 100` fails with EAFNOSUPPORT when boot with
> `ipv6.disable=1`. There must be somewhere inside `vrf_newlink` trying to use
> IPv6 without checking availablity. Maybe `vrf_add_fib_rules` I guess.
> 

ack. I'll take a look when I get a chance. Should be a simple fix.
