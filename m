Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5B3D771C7
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 21:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388306AbfGZTBc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 26 Jul 2019 15:01:32 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43359 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387743AbfGZTBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 15:01:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id p13so55412218wru.10
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 12:01:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:from
         :message-id;
        bh=fPVZv67npERROw25thP+mdmtiD9pfDH4a8c0L+Q4PXk=;
        b=IJ1jY8y3xTFcVRBhkJzVf0AM32rbKMg2lOntvmDCP8/neOEHOwC3+My5EUc/Mv1ZIf
         8FuxMnzNXPmFznumxEKl/pnJghSzKOHn+Egv+ylcMWbEVOKqbQTc0z1rEpQKw0thy8aN
         tJSLPUbeNGxYVugXA1vTSlmv+s+OdyChn4ZOc/Tm2mxBzoc1ucML/rdBeZTLL2QSmvD6
         UOB0p655xsv6jRGZZ8AWl57KpEMsH4GjmPa3oUzy5afmgf/ITkyk5kLpT1ZiNMv5TDQi
         kr07WZUCj1UE0HX1fbH08v+NXvCqocXmba8QiE0Fa/6mUEv9yScekOISfgK9AN5wIMh1
         nRWg==
X-Gm-Message-State: APjAAAWGl1YRqadhOm6Wwf34PY20lf8HffisY7Vu4nw1KKQvp779RQ8y
        y0Lml0MustEwN0fpD/gcvjOiaectFlsBnw==
X-Google-Smtp-Source: APXvYqwNHxqyF+TOoWuCugo4EeXLOLt6BMiYf4gg0iJVX8pmdGhoqeRXA+eiLsq5XNmyR8mkiilc4g==
X-Received: by 2002:adf:e8cb:: with SMTP id k11mr19723823wrn.244.1564167689822;
        Fri, 26 Jul 2019 12:01:29 -0700 (PDT)
Received: from [192.168.1.66] (93-40-194-98.ip40.fastwebnet.it. [93.40.194.98])
        by smtp.gmail.com with ESMTPSA id x129sm51725558wmg.44.2019.07.26.12.01.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 12:01:29 -0700 (PDT)
Date:   Fri, 26 Jul 2019 21:01:23 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <20190726112514.4b0f63e4@hermes.lan>
References: <20190724191218.11757-1-mcroce@redhat.com> <20190726112514.4b0f63e4@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH iproute2] iplink: document the 'link change' subcommand
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
From:   Matteo Croce <mcroce@redhat.com>
Message-ID: <80DD5B99-66CA-43B7-9A57-87971984FC01@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On July 26, 2019 8:25:14 PM GMT+02:00, Stephen Hemminger <stephen@networkplumber.org> wrote:
> On Wed, 24 Jul 2019 21:12:18 +0200
> Matteo Croce <mcroce@redhat.com> wrote:
> 
> > ip link can set parameters both via the 'set' and 'change' keyword.
> > In fact, 'change' is an alias for 'set'.
> > Document this in the help and manpage.
> > 
> > Fixes: 1d93483985f0 ("iplink: use netlink for link configuration")
> > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> 
> Probably just done originally for compatibility in some way with ip
> route.
> Not sure if it really needs to be documented.

Maybe not in the output help, but in the manpage we should state it.
-- 
Matteo Croce
per aspera ad upstream
