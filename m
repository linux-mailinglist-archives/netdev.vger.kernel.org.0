Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3DE8F1AC
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 19:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731403AbfHORMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 13:12:44 -0400
Received: from mail-qk1-f180.google.com ([209.85.222.180]:44925 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731383AbfHORMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 13:12:44 -0400
Received: by mail-qk1-f180.google.com with SMTP id d79so2370129qke.11
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 10:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=lO6uLU2VGZEGqwPhDXvAC3eXD75K3oSMtqEUigHPitc=;
        b=U06si8s94cpDNZlIaGz3xof9KzE5VE9HqLXG8qOkLZ6X8Nr3pgUzUOZHYOfY3uqANy
         KNLij5Uk3GG0KZ6UPalfxWLTr5GQ/tXAPO0mTHZUoBeb+Of+9NMqLmRqf5IF3FgIv4/f
         iNW5orL5PDwG0dUMc4h64DZlKiWXAXOWW9eC1119ndZULblQVg/7yCH93Eh98bbtHAno
         imNQIcU644KbRfCb7LPnq1cAnJQe9soE/I7cXpqQk5/5/hsZbwdQJJMguWog1Btacmvo
         wUMqEcnKq4ocLJNxWhl1nZD7fhqXdT7F3M7lpGM/lY9fafRvypUnpH1TZLTHXJ9fSnrw
         JDGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lO6uLU2VGZEGqwPhDXvAC3eXD75K3oSMtqEUigHPitc=;
        b=Ck0plWFkaKAVH8+fMXKi7+ZSNL8oEWoWp5b31Jd5W8dgrZuDRNr4X91d8lHGDSNuDE
         WdNBVuMbAoXH98P1hLK8lW+kaQn6DVGqYTpdJgj4IEoE8TWXL0MblU2YM0Bqgtz6VkHs
         fmdpk0GUE22jrfV0I7zR5EiBFRPPRnIt0qFfM03PiXNg/A6yK+cebZFzAjr9RKQO66GW
         aBEyeEAwEREdsrOAdg9zHd7H4kFKXZfmCbGrOA70zTWmiUeyfGAuCKYLrOpQIiaaJ511
         A0CZQ5e5hWvUVPZLdRyVGk8Xl3C1iSNZgLylaUZIUmS+SJDofOTLnySnL4A+VNfekoUo
         ToTA==
X-Gm-Message-State: APjAAAVjp/80Rhqq3G1ZO7G3woSZ279tBthgsub5jys8BEzZh2H7Knyl
        CtDLs2Lx9+BW4fENgirvnjIUCA==
X-Google-Smtp-Source: APXvYqzBudGJcCogkGmlmf7bBwxA78xcaZZLgNykR9Qxhj1lm33krVpduNeDeYTVvi8G8sE3ZJoO9A==
X-Received: by 2002:a37:d2c2:: with SMTP id f185mr5132855qkj.173.1565889163629;
        Thu, 15 Aug 2019 10:12:43 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f20sm2415600qtf.68.2019.08.15.10.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 10:12:43 -0700 (PDT)
Date:   Thu, 15 Aug 2019 10:12:28 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 2/2] selftests: netdevsim: add devlink
 params tests
Message-ID: <20190815101228.3eefdf9d@cakuba.netronome.com>
In-Reply-To: <20190815085214.GC2273@nanopsycho>
References: <20190814152604.6385-1-jiri@resnulli.us>
        <20190814152604.6385-3-jiri@resnulli.us>
        <20190814180900.71712d88@cakuba.netronome.com>
        <20190815084545.GB2273@nanopsycho>
        <20190815085214.GC2273@nanopsycho>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Aug 2019 10:52:14 +0200, Jiri Pirko wrote:
> Thu, Aug 15, 2019 at 10:45:45AM CEST, jiri@resnulli.us wrote:
> >Thu, Aug 15, 2019 at 03:09:00AM CEST, jakub.kicinski@netronome.com wrote:  
> >>On Wed, 14 Aug 2019 17:26:04 +0200, Jiri Pirko wrote:  
> >>> From: Jiri Pirko <jiri@mellanox.com>
> >>> 
> >>> Test recently added netdevsim devlink param implementation.
> >>> 
> >>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> >>> ---
> >>> v1->v2:
> >>> -using cmd_jq helper  
> >>
> >>Still failing here :(
> >>
> >># ./devlink.sh 
> >>TEST: fw flash test                                                 [ OK ]
> >>TEST: params test                                                   [FAIL]
> >>	Failed to get test1 param value
> >>TEST: regions test                                                  [ OK ]
> >>
> >># jq --version
> >>jq-1.5-1-a5b5cbe
> >># echo '{ "a" : false }' | jq -e -r '.[]'
> >>false
> >># echo $?
> >>1  
> >
> >Odd, could you please try:
> >$ jq --version
> >jq-1.5
> >$ echo '{"param":{"netdevsim/netdevsim11":[{"name":"test1","type":"driver-specific","values":[{"cmode":"driverinit","value":"false"}]}]}}' | jq -e -r '.[][][].values[] | select(.cmode == "driverinit").value'
> >false
> >$ echo $?
> >0  
> 
> Ah, it is not the jq version, it is the iproute2 version:
> 8257e6c49cca9847e01262f6e749c6e88e2ddb72
> 
> I'll think about how to fix this.

Ah, wow, you're right! Old iproute2 works fine here, too!

> >>
> >>On another machine:
> >>
> >>$ echo '{ "a" : false }' | jq -e -r '.[]'
> >>false
> >>$ echo $?
> >>1
> >>
> >>Did you mean to drop the -e ?  

