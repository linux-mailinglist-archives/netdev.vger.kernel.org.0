Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BADA8E76D
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 10:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfHOIwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 04:52:17 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:36641 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbfHOIwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 04:52:17 -0400
Received: by mail-wm1-f42.google.com with SMTP id g67so662844wme.1
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 01:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LSqth/Zmr7BnH1CKrqYkXzyo5tCxtVijnH/CELBPm64=;
        b=yXq+mJU/4Vyy2Nh2Qmh4JBwiYe3mvurAbfdxrnAQISu8WISyqsZAZ8DrZ/gSYrJDPx
         7TuE3jQpHK+EP2Kz61+5Rl64PEheQf4OB1exDjBgwza1AWWPMWZVYUvt/q6qz1WFNZ3Z
         On9XgD7e8YRTsOg/DE1EPSjLPX1t8hBJbpMXShzVHk52CVU+XmhCZ27BrQpRbBCzNI84
         4ZJ35kJt3COilSChxcyTmVtB9DaWJC71UBCoKxS+bMsgFgTofPDZQkQu/ZM1RwY9P8ps
         cv1JxzRyzVGIF7ByNFUcTzArAJN3Y8Of9HY/dW2o2yuoxDqLDF9ASMd/Smvb17j0DX0s
         Q2EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LSqth/Zmr7BnH1CKrqYkXzyo5tCxtVijnH/CELBPm64=;
        b=foANBvLOR/rkW8YmIjyJNzpC5V9k91IdQoee20ccSrB3Y/LU1ImWmClYgSdVTDQFgv
         lo9SXG8qexPLmLDMLMhuxFIehbwBZyujEOCM1wbI7oaOHtOdD2HQXLTcZ+PLvJVoVyGR
         vMZ8WRgHJjAtWQyaVJHdEMcL6ofTVhYTadfzgCV8mY2Otz3Lw6Q1DWLpNyJJ60rqLN8G
         Vl7fuQ+lYigIkp+gvcWvv4g2lp9i4IptuhPPizAAiEeLE5CQzGzYhzDC4fw98e1xQ7jC
         MdZWcKoGNLtvJXG9sDVeKSRzR0E6wG66LEJQQzPp2xgI27biPaqBtvgs58Spj9y1oF3N
         hH1g==
X-Gm-Message-State: APjAAAUtb6FBEsMwujN8qVJkTZyngslRS8yu7wVfXQ0AJtjgKSZ87d7d
        cGt+DdDgN8JQF8QFVjXVMEJqpQ==
X-Google-Smtp-Source: APXvYqx6rT2SfzBGyzZ5di7mUzk4bK4z3cpFgwk43RCUURKRwR7WoP33qQOphJhDOhnfmtZo4HHRvw==
X-Received: by 2002:a7b:ca54:: with SMTP id m20mr665752wml.102.1565859135311;
        Thu, 15 Aug 2019 01:52:15 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id s25sm719175wmc.21.2019.08.15.01.52.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 15 Aug 2019 01:52:14 -0700 (PDT)
Date:   Thu, 15 Aug 2019 10:52:14 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 2/2] selftests: netdevsim: add devlink params
 tests
Message-ID: <20190815085214.GC2273@nanopsycho>
References: <20190814152604.6385-1-jiri@resnulli.us>
 <20190814152604.6385-3-jiri@resnulli.us>
 <20190814180900.71712d88@cakuba.netronome.com>
 <20190815084545.GB2273@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815084545.GB2273@nanopsycho>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Aug 15, 2019 at 10:45:45AM CEST, jiri@resnulli.us wrote:
>Thu, Aug 15, 2019 at 03:09:00AM CEST, jakub.kicinski@netronome.com wrote:
>>On Wed, 14 Aug 2019 17:26:04 +0200, Jiri Pirko wrote:
>>> From: Jiri Pirko <jiri@mellanox.com>
>>> 
>>> Test recently added netdevsim devlink param implementation.
>>> 
>>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>>> ---
>>> v1->v2:
>>> -using cmd_jq helper
>>
>>Still failing here :(
>>
>># ./devlink.sh 
>>TEST: fw flash test                                                 [ OK ]
>>TEST: params test                                                   [FAIL]
>>	Failed to get test1 param value
>>TEST: regions test                                                  [ OK ]
>>
>># jq --version
>>jq-1.5-1-a5b5cbe
>># echo '{ "a" : false }' | jq -e -r '.[]'
>>false
>># echo $?
>>1
>
>Odd, could you please try:
>$ jq --version
>jq-1.5
>$ echo '{"param":{"netdevsim/netdevsim11":[{"name":"test1","type":"driver-specific","values":[{"cmode":"driverinit","value":"false"}]}]}}' | jq -e -r '.[][][].values[] | select(.cmode == "driverinit").value'
>false
>$ echo $?
>0

Ah, it is not the jq version, it is the iproute2 version:
8257e6c49cca9847e01262f6e749c6e88e2ddb72

I'll think about how to fix this.


>
>
>>
>>On another machine:
>>
>>$ echo '{ "a" : false }' | jq -e -r '.[]'
>>false
>>$ echo $?
>>1
>>
>>Did you mean to drop the -e ?
