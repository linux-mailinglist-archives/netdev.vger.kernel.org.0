Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8F461075D0
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 17:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfKVQ3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 11:29:16 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55440 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbfKVQ3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 11:29:14 -0500
Received: by mail-wm1-f66.google.com with SMTP id b11so8059197wmb.5
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 08:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vCjthGSWcUzAL79D+rlS/r2aEmSRDFb+k7vT0Z5q+bw=;
        b=sPaCKNoppg1X1f00LO6A8XDJG3BPOn15YAQ1wOIMYz+TC69tQKeQ2gw0A+XKgVzrfQ
         bz4MbLlU3Bo+okfkzxL7+KbVKOtDUWFqAKGHU5iy0H1C/OriSE5B8IJoANvMa6iYUjAp
         nGRXAbT/7oGp3eWuiXt0bF33fCIRCxxkavxPWcO+Kjp6YOGbE2GCeS5T6R9ZGltRSq+t
         WWsysWQ0ZaCL7PzRpnAEqn734Kdtfa8BEODSzEPaebgq8zcCetSeSt6SPiQfs+fUwPAK
         WNitLdxSQNti39s8SZWmoO2ug3G0bn+Z+Lk2I8BG9UsHsiytOlNZjjdgMgqtFSy/jYUb
         fvCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vCjthGSWcUzAL79D+rlS/r2aEmSRDFb+k7vT0Z5q+bw=;
        b=hVzvROkPX59pyWEixD/TICafvvtvkPGuWAroXmkFtLeAGddvE2JJpJl3pps+TkRsJY
         /LGV6d913D34+v2liLHioewklm3QFbwOQpZ1lRl19kvb2MAGrmpUWSScZy6WVOcGvbCN
         HvWOaYC4uW3W9t2awXVhDuLIKzOYZUH3VOk3SBjOJM97ZxtuaYexfOYjchF+Poi6m0XQ
         cLRSlVWmveERtkRsh4WevI4N4Ml+E/s/e10WG6FTqaZWE+F+am4kPFGzqj2364926htJ
         DAj+5iB+62h1MN7WnJAfqyE9WabrSIgvsg8ugCT799rwlCggGhVIDxq1eloPSaryAnzq
         R0Eg==
X-Gm-Message-State: APjAAAV/aoYNiUy/qXyBOVOutfe0RTHs37s9Bey/Vjteu+4MFMmAcE1A
        Ff3kZlS5j2iN3+xvKjXALUmbJA==
X-Google-Smtp-Source: APXvYqyh6rueJx/gyOhHn95RLgrHKGiQO/80ylgSv9lDWCj6OzdZhvtunWDKiVKR5Tuw7JMrTzm55g==
X-Received: by 2002:a05:600c:149:: with SMTP id w9mr3391704wmm.142.1574440152946;
        Fri, 22 Nov 2019 08:29:12 -0800 (PST)
Received: from localhost (ip-94-113-116-128.net.upcbroadband.cz. [94.113.116.128])
        by smtp.gmail.com with ESMTPSA id b196sm4089301wmd.24.2019.11.22.08.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 08:29:11 -0800 (PST)
Date:   Fri, 22 Nov 2019 17:29:11 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Petr Machata <petrm@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] net: flow_dissector: Wrap unionized VLAN fields
 in a struct
Message-ID: <20191122162911.GC2234@nanopsycho>
References: <c2be1d959f0d710dbbb99392eeb190a81952307a.1574437486.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2be1d959f0d710dbbb99392eeb190a81952307a.1574437486.git.petrm@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 22, 2019 at 04:47:21PM CET, petrm@mellanox.com wrote:
>In commit a82055af5959 ("netfilter: nft_payload: add VLAN offload
>support"), VLAN fields in struct flow_dissector_key_vlan were unionized
>with the intention of introducing another field that covered the whole TCI
>header. However without a wrapping struct the subfields end up sharing the
>same bits. As a result, "tc filter add ... flower vlan_id 14" specifies not
>only vlan_id, but also vlan_priority.
>
>Fix by wrapping the individual VLAN fields in a struct.
>
>Fixes: a82055af5959 ("netfilter: nft_payload: add VLAN offload support")
>Signed-off-by: Petr Machata <petrm@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
