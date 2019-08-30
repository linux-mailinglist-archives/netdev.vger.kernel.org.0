Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64047A2C82
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 03:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfH3BzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 21:55:11 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36371 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbfH3BzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 21:55:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id w2so3467045pfi.3
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 18:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=C/rIPqRnCxjehMrRZykfN2Pikoku80prbn4PQ3WrWxc=;
        b=aBDiwEUf9orIecXXiHqnS7IC8pUBV0Etw6SQZV7DJzHPGg/pt8PswixOFjaa8bwf8T
         1cqIbuwWE/5UbPNsKmOBBdYJDQrbxPrhDwmHO132AbwE2Hm47s92ieQari9fqdJWNCJs
         5NvA6+rcdwkYqNVchSiDh7CFtwkiLQHvlIuGqrpB7QJ/bZRA5iyjFEI6HWxvBzdzQkQ6
         qZm9vdfZtAoY7sW/NSHzPurEI6axHfFc4igBIMIl6cqHmIcIQ/VPGpPgn79Rz/uWZw+X
         mWaySGkxk1n/ki1fSZ4xQNp8F9pSkP7SpKIlbFAArvHyYvxDxSsbHHm7vmjmu/ISgFeL
         mfpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=C/rIPqRnCxjehMrRZykfN2Pikoku80prbn4PQ3WrWxc=;
        b=kD6KnCB1r42RKzw5gWnBvJE5ApxO2/pU1z4mzj5zhK3ap+VE45UX2DStnYymE8h+6B
         dJU1HUoo3TKdhJc2iuAGN03T+VTjv+5sV+bzBl8SXBWeWvgl00lddT10M1bY1jknScMW
         pC6oQO47uAhK2t7VyOWPp587O9b4sW16yGT/f6gXi6sWWGe4/uqS5Hc8FQYHSx3PM1t1
         vCzouX18MliTkTPF0mOXNxERxgC/D+hVNCZPkKFTcES9vZruSK8L+JvuozngbsGKx+rD
         7H1DgA+XRH+nAovswH93w2+oguy7HNjneACdTfcMFjQ0kels0lWKZNQniRErUCH3tze8
         eK4g==
X-Gm-Message-State: APjAAAXzZ06sik6BWxftw01RxaLh7xc8EK8j6I3b1/68fMOoi0KPXZ/6
        jdV6suXNqTkjn4GZCSlD6tyjF3PK2js=
X-Google-Smtp-Source: APXvYqzUwCj01UDS+jNdtjarJp+Kqp1GKBmtVGAiF/Zp1EKlVuDOItf6c+d4TR6XBsictPqKO9GjWA==
X-Received: by 2002:a63:6c4:: with SMTP id 187mr10155470pgg.401.1567130110117;
        Thu, 29 Aug 2019 18:55:10 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id v18sm7116927pgl.87.2019.08.29.18.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 18:55:09 -0700 (PDT)
Date:   Thu, 29 Aug 2019 18:54:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@resnulli.us
Subject: Re: [PATCH 0/4 net-next] flow_offload: update mangle action
 representation
Message-ID: <20190829185448.0b502af8@cakuba.netronome.com>
In-Reply-To: <20190830005336.23604-1-pablo@netfilter.org>
References: <20190830005336.23604-1-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 02:53:32 +0200, Pablo Neira Ayuso wrote:
> * Offsets do not need to be on the 32-bits boundaries anymore. This
>   patchset adds front-end code to adjust the offset and length coming
>   from the tc pedit representation, so drivers get an exact header field
>   offset and length.

But drivers use offsetof(start of field) to match headers, and I don't
see you changing that. So how does this work then?

Say - I want to change the second byte of an IPv4 address.

> * The front-end coalesces consecutive pedit actions into one single
>   word, so drivers can mangle IPv6 and ethernet address fields in one
>   single go.

You still only coalesce up to 16 bytes, no?

As I said previously drivers will continue to implement mangle action
merge code if that's the case. It'd be nice if core did the coalescing,
and mark down first and last action, in case there is a setup cost for
rewrite group.
