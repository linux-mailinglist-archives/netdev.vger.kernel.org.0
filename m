Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A21363A1
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 20:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfFESyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 14:54:39 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41237 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfFESyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 14:54:38 -0400
Received: by mail-pl1-f195.google.com with SMTP id s24so9882635plr.8
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 11:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZOhUkjqycRNcvjz1AcTvLd41yLqeEJ1fFL3uA+Ac3KQ=;
        b=oizaXMkeqeah/hK9xLFcV37IR3qySg2r/xl7BdqUK/WgO9yQbHcBeD6GQexHUSIdZs
         U5PlPMIOGWA38GyIrLEzI4Sr7vCiiWRZ7H+SnPbBpTM0XcZV44GRn4yyBI1fsUV1Orqc
         yiWD+NYuJFPpAD5MDJkdPuiaZOLzgXCuYTAl5CQXxZHBPcN/okVUCcy7QvEIeOp7KEcO
         PYmJhcGl54A9Kq13WrVIEbTxKXylcN7Aq9zQlpbvNCtkeMKeu0bom6V+YFRGQTmaYCvk
         X9OhjQ36Z8VmxvepYho+JUPxtfmDyqPFrAxbNKWItStLiqZ0TNzTWlOsMMtRfiwqLC/M
         8ZMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZOhUkjqycRNcvjz1AcTvLd41yLqeEJ1fFL3uA+Ac3KQ=;
        b=SJCah8ZLEm3bFW4SgoBJ5Pqj2a0tUQvd6efiv6WbFrkhYottXwlBwMVnzOAqHjF2f3
         /t0eeORu3+pYOJFVOQ6FN/tJw4h4i8rnigFNeDai2dyCDS6obUHGG+/UY/82CxfVTzz5
         m+h7RxHaj9IPKxhDrwTPK/726N17h2MeDS5h11vwsytIgvz43Hbq4zMgPPvL3elGhCOA
         vvJvYiQ+DXkzWuFljkWPswjaM0JhgpOb7CrULi+5N+tP30H3MZO+Yf04aMBzl2o+4fYX
         wj+9F560FsOCKrt6Fld3/D6WjJBLRB1MokGalGN1kIc2VaLWzadooZQKL5T1YXdDzlIS
         5pJQ==
X-Gm-Message-State: APjAAAXW8rCrd1bFdxfzAndEM0uQvNgvKCeffIcyUQTE4eXRlodC1Lhi
        Wnv2+ws/UuBCTzIb1QVNHYeHl92BPwQ=
X-Google-Smtp-Source: APXvYqzEypiVeMN6BTmRpvg9meCCAHm7HWcsU1ZorT0+EY70hEd1yMAKAV/pwIeMFgPmfgHkNGdItA==
X-Received: by 2002:a17:902:27a8:: with SMTP id d37mr46143358plb.150.1559760878320;
        Wed, 05 Jun 2019 11:54:38 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id l1sm21172722pgj.67.2019.06.05.11.54.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 05 Jun 2019 11:54:38 -0700 (PDT)
Date:   Wed, 5 Jun 2019 11:54:36 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Joe Perches <joe@perches.com>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC iproute2-next v4] tc: add support for action
 act_ctinfo
Message-ID: <20190605115436.3092dd50@hermes.lan>
In-Reply-To: <95fa3d641e5df79b7e69ff377593c4273e812bb6.camel@perches.com>
References: <20190602185020.40787-1-ldir@darbyshire-bryant.me.uk>
        <20190603135040.75408-1-ldir@darbyshire-bryant.me.uk>
        <95fa3d641e5df79b7e69ff377593c4273e812bb6.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 05 Jun 2019 11:23:59 -0700
Joe Perches <joe@perches.com> wrote:

> Strict 80 column limits with long identifiers are just silly.
> 
> I don't know how strictly enforced the iproute2 80 column limit
> actually is, but I suggest ignoring that limit where appropriate.


Not strictly enforced, but long identifiers are discouraged.
Overly deep nesting which is the main cause of long lines
is also discouraged.
