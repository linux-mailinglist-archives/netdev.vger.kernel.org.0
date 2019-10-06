Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A39C0CD1F9
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 15:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfJFNCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 09:02:09 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35327 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfJFNCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 09:02:09 -0400
Received: by mail-ed1-f67.google.com with SMTP id v8so9967297eds.2
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 06:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9AwqnhgtOOUXGVCNpH8IY4ryeQkVjL7OB1vs9tz40sE=;
        b=Y50BQv1hqbszNXcSxs47YyjyV6FMAm/thjsDfJhl4aatvnAqaBt4Axugq8vtoQ6grF
         pleTG4MkAunepcPD1iHyH0oIDfeCgE47WvIDyS85P7naPkEJzWD4gOAIxwrS1Bddj5eI
         HIJ/OdPDpSvX8AyfIW6DhxfqK9TNUGOPNVEo+8806cyjTtmzNUrJTCwEDx31lea/no+9
         MwHiO8lo9tBYbZ2tqa8ei6WoGz0j8KHDOKJsJHEzn6uI+XAeki40kID5Pjvf2MRmcZML
         3GGkkk51CK8Dfj7+pdkKEwZ+XvGcn8JOYpzQ1AP6pG5TB7D2W8R7kdODQ8RuwdKH5EFe
         JRUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9AwqnhgtOOUXGVCNpH8IY4ryeQkVjL7OB1vs9tz40sE=;
        b=Oum7pJ/yDz8flTNGVaGW0y/+8OvGUhqrNOJ/x2zIs2WIww9yl81mCZ8IQEuwQkkBLv
         HiBfp7YdB1giGABi5WuzYnwKMm6Mm5/a64u49ingkynQ+B95umCrg7yxP+OMuoggfPfq
         EvtRievKQRisJzfairWPNJZx7FPzJ8/U1SH+a5AnPRYwrjsPdkPWl9SvSX1S0UzfpnKO
         JTIp1N9E397jyl6EWq5rtd6qjV5aUcSVyj/GRKHIINj7tlDWaYllRH3bVHyE/Oi9AcMZ
         OPR70p5TLPAMkiHeRl4rb2P3OuMCqtK/C3zl1ZGD97FH/omVM+xd4W7tpwQ686UqwUf8
         yuzQ==
X-Gm-Message-State: APjAAAULBE/7DNMrb9HxJFj1030Hs6cgdkiQmJeeWDp7fVhDUItMi+Ye
        Zexsl7PU5MYtmjyNvoQa0LKruw==
X-Google-Smtp-Source: APXvYqw3VSRwlsFMVkuMkNo4QAK6Ptr1bcI6CS88021zk4OuoYptiUqG9X9RUmT5Nyp+xWUm/0k+/Q==
X-Received: by 2002:a17:906:bcd9:: with SMTP id lw25mr12057064ejb.315.1570366927704;
        Sun, 06 Oct 2019 06:02:07 -0700 (PDT)
Received: from netronome.com (penelope-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:c685:8ff:fe7c:9971])
        by smtp.gmail.com with ESMTPSA id ba28sm2656050edb.4.2019.10.06.06.02.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 06 Oct 2019 06:02:07 -0700 (PDT)
Date:   Sun, 6 Oct 2019 15:02:06 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Tom Herbert <tom@herbertland.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Tom Herbert <tom@quantonium.net>
Subject: Re: [PATCH v5 net-next 1/7] ipeh: Create exthdrs_options.c and ipeh.h
Message-ID: <20191006130205.3ccn4ap7pkm3dtxq@netronome.com>
References: <1570139884-20183-1-git-send-email-tom@herbertland.com>
 <1570139884-20183-2-git-send-email-tom@herbertland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570139884-20183-2-git-send-email-tom@herbertland.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 03, 2019 at 02:57:58PM -0700, Tom Herbert wrote:
> From: Tom Herbert <tom@quantonium.net>
> 
> Create exthdrs_options.c to hold code related to specific Hop-by-Hop
> and Destination extension header options. Move related functions in
> exthdrs.c to the new file.
> 
> Create include net/ipeh.h to contain common definitions for IP extension
> headers.
> 
> Signed-off-by: Tom Herbert <tom@herbertland.com>

Hi Tom,

I'm not entirely clear on the direction this patchset it going in -
I assume its part of a larger journey - but in isolation this
patch seems fine to me.

Reviewed-by: Simon Horman <simon.horman@netronome.com>

