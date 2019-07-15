Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94DFA69D03
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729875AbfGOUs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:48:28 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44820 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729505AbfGOUs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 16:48:27 -0400
Received: by mail-pf1-f193.google.com with SMTP id t16so7962728pfe.11
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 13:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vKetL6Hk7BIlYs67nTL5M9xydmGkj8hPTdOlbViijow=;
        b=A2XXYR/8KZx5UggD5ilanhVccOJPuvgXePMLSrdJ7EaReZzqLqYVRTbery0Izs25y6
         0ZJJr8NEYWXc5wSdEEgap4KqwLPll5x9Wm4BOxFBbnKBRqkiceF/kmiltsnL0iSdRDzG
         nc/GUvFuTk5g26ai0uEYHifz0sw9f5Ft7VS0BjSPkDCZ/LqtTtdzIBxW/QQbCB6cqWZS
         KuIt8C+88s2WLg59YLROmIDqg1p2gkab6zIRU7coqhuVV7ASw1FTgl7o7Neaj/QhXVHO
         za7bBHQeVZSLNwbT0Sd6MXtmXwKfFSVotjcWLPSsGPXo9s64vf8BzZzZBfE04GpTpTLk
         l9dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vKetL6Hk7BIlYs67nTL5M9xydmGkj8hPTdOlbViijow=;
        b=Ss1oZepHXd7or42wcX8VW5q2cCSTPZp79HV+/YyU6IfPw9n/0X3ZaxLjTWak/C2dkd
         B922u8ezodT/EoOEg0T7Hw/WoXOm/RzkTicKh7kiMRtg/xoGhLAR5pzbTPGBE5fYs7Vl
         BMuXy2aMjaJa+weLKhL/ZAXBkT6/ct49Ah7GnL11BMS/DKTLzvtvnPMcNqfFwR31xbaH
         VWhMa3HHjRhTLM9FBmW7FJW1FLes5KF1MIzkHvgnQcdB/P8AqzA3tjG84H4WbgiJkO4k
         BSsr0cERd6A8/ZJRWY52vxPmZexquGpmE8T4p2dIpp1pqtAHMsD5VrLjLT1mFtnENrNF
         MMIw==
X-Gm-Message-State: APjAAAWrzIAiucj+mwJwsrNCUNSqAaz2Z8nSVPs2pj9pBo9NJ4MxHNMZ
        mf57zsBpKD7/Yimo4BeBR8k=
X-Google-Smtp-Source: APXvYqxvyxxJxJykHaVUBsarByG+YmhKuqBIcWe4q/239gh5B61DwzgIGE/N68M5wQzvJ3t1bJxxdg==
X-Received: by 2002:a63:5823:: with SMTP id m35mr29356732pgb.329.1563223707215;
        Mon, 15 Jul 2019 13:48:27 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id i126sm17991795pfb.32.2019.07.15.13.48.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:48:27 -0700 (PDT)
Date:   Mon, 15 Jul 2019 13:48:20 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org
Subject: Re: [PATCH iproute2] tc: util: constrain percentage in 0-100
 interval
Message-ID: <20190715134820.119e0cb8@hermes.lan>
In-Reply-To: <c0a9b4ce15d5389ac59fbf572f5f1b3030ec4c90.1563011008.git.aclaudi@redhat.com>
References: <c0a9b4ce15d5389ac59fbf572f5f1b3030ec4c90.1563011008.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 13 Jul 2019 11:44:07 +0200
Andrea Claudi <aclaudi@redhat.com> wrote:

> parse_percent() currently allows to specify negative percentages
> or value above 100%. However this does not seems to make sense,
> as the function is used for probabilities or bandiwidth rates.
> 
> Moreover, using negative values leads to erroneous results
> (using Bernoulli loss model as example):
> 
> $ ip link add test type dummy
> $ ip link set test up
> $ tc qdisc add dev test root netem loss gemodel -10% limit 10
> $ tc qdisc show dev test
> qdisc netem 800c: root refcnt 2 limit 10 loss gemodel p 90% r 10% 1-h 100% 1-k 0%
> 
> Using values above 100% we have instead:
> 
> $ ip link add test type dummy
> $ ip link set test up
> $ tc qdisc add dev test root netem loss gemodel 140% limit 10
> $ tc qdisc show dev test
> qdisc netem 800f: root refcnt 2 limit 10 loss gemodel p 40% r 60% 1-h 100% 1-k 0%
> 
> This commit changes parse_percent() with a check to ensure
> percentage values stay between 1.0 and 0.0.
> parse_percent_rate() function, which already employs a similar
> check, is adjusted accordingly.
> 
> With this check in place, we have:
> 
> $ ip link add test type dummy
> $ ip link set test up
> $ tc qdisc add dev test root netem loss gemodel -10% limit 10
> Illegal "loss gemodel p"
> 
> Fixes: 927e3cfb52b58 ("tc: B.W limits can now be specified in %.")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>

Looks good. Applied
