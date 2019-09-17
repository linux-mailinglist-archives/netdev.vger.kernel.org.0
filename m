Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 065EDB556A
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 20:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfIQSgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 14:36:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42714 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfIQSgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 14:36:33 -0400
Received: by mail-wr1-f65.google.com with SMTP id n14so3359964wrw.9
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 11:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MSHjB4CjWiSlSrN7xqv6w+lxCtEAbggOzNdOl4hnvFQ=;
        b=P8kSbzJtg9omSLdYxDi2ICTY4D3ayf6LwX5u1bpZw25ycHSpaq81HiPt/2tTRzzTUD
         h3YQ7IgMMJg70noERLiR124ZyaTntRnNe5//dirg5nA6XBRSHP13GJkaQS5nLOzfX1j/
         0xrHWjUPskuKGPBHJc2u/FlGbIEp6ZAMjQqNAwFZ1By26P0z2eAMZlGA401ilebECUu2
         aniH2QdhseicE3Yd2wMZa0fhSpRtiNbudcP7lRJ7qL6BYbZPN/UxkWRDEA6+xCGKmKal
         y0ooxXJWXDdRwH1G3GtHwQW+FVeurydoggzTuDSMR3GVsdBRC3WOl9qUZEaoYd4LPWmI
         UDiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MSHjB4CjWiSlSrN7xqv6w+lxCtEAbggOzNdOl4hnvFQ=;
        b=gqy6G0yAQXj27dDNoaUcZ5HhnHzuff9nx8fSaux3H32+eaQAZYSikpVajdt78C6zMy
         seykjhZDfVndKNnlsTInFFF+d0kImcqzH4QEM3sZyLtfdC9fSKCvABWK5qu1wTyC/pBh
         EOagwtuhTcEC+IYE+DiBHgNgr9xzi3vzmXIoQjlFLTVyaeny8kmHway0XVTqFvq8Yvn6
         gBauAcLSBTJSzcXfmbfFKbi9XScSF2fVy62XR9MIwxPVOyXQV9qnePqHq5MJyq4OC0RS
         cV689p2pj0mbeGarQsl0HPs/d5xz/tIZ1+HQ2+TRYdWpxwKNGT728mXy3o9fSkq8xaWq
         /U7w==
X-Gm-Message-State: APjAAAX50OrI4EqsuhjJ+lwNvmnp1F/AEgN+BunhMHV2X+bDoiEM6UjD
        MqKE/oghDObLT5EYZ755n1BmcQ==
X-Google-Smtp-Source: APXvYqyy7leTRsWwgUGBSR6skjJwRkFeH4yy0nJO3qU1FHE8vwFLPT6cq5+MpH/eHaPU3xeBby52wA==
X-Received: by 2002:a5d:63ca:: with SMTP id c10mr39569wrw.314.1568745390483;
        Tue, 17 Sep 2019 11:36:30 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id e6sm3670117wrp.91.2019.09.17.11.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 11:36:29 -0700 (PDT)
Date:   Tue, 17 Sep 2019 20:36:29 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        tariqt@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch iproute2-next v2] devlink: add reload failed indication
Message-ID: <20190917183629.GP2286@nanopsycho.orion>
References: <20190916094448.26072-1-jiri@resnulli.us>
 <c9b57141-2caf-71c6-7590-a4783796e037@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9b57141-2caf-71c6-7590-a4783796e037@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Sep 17, 2019 at 06:46:31PM CEST, dsahern@gmail.com wrote:
>On 9/16/19 3:44 AM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Add indication about previous failed devlink reload.
>> 
>> Example outputs:
>> 
>> $ devlink dev
>> netdevsim/netdevsim10: reload_failed true
>
>odd output to user. Why not just "reload failed"?

Well it is common to have "name value". The extra space would seem
confusing for the reader..
Also it is common to have "_" instead of space for the output in cases
like this.
