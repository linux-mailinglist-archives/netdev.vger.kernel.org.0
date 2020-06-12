Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD0A1F730E
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 06:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgFLEhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 00:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgFLEhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 00:37:02 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F893C03E96F
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 21:37:02 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id g18so6234618qtu.13
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 21:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F97uV/ArOqgg3/t8g2ZR/V8/lEFaYz13EXKGPRdcTt4=;
        b=j/CUCJm0VrxPmEBvvcLMcYsl8D7gvIApjW0OoVLaOkTaZbNvTBQqz1QkML6HGRjFC7
         jXSiLzuLLZX84StWJ6gQshsZ+MkUfC6uQhGenGSA4UgmJrlRujH0z874NHusc4oKtxvD
         4EINLwT6iW0S7KNRwxp+ZrUTMPYhd6p0/W9TaEwrKY9LpKpFZDMzFPD1RAoOX0847zZH
         pZHTpT6Qs1y4Ted2xkfRAhxxQYv/A99IFS/Dmk1TfB/PPNBsaKjAi7rg2vteqyGH/l6j
         DNyJEaCYMufX5/1+qycLRAjzY3D/AFJlBInOhY1EmUKcN6C0bTDR7fk8h9mMCcrXYqWh
         blCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F97uV/ArOqgg3/t8g2ZR/V8/lEFaYz13EXKGPRdcTt4=;
        b=W4dgAEWAD5dGNyZkNiyV9bu3XDsg6JuozkO4KUPoW4BBdg+2QnrblttLxf/y/pnvQD
         okYwms9W/DSmzvs+sLnRFGX/9zoyojRvXowtfMOTNlf5xc0bCT8c54ToUg75K/g960u1
         QTsA6pNxYSMdKcbKNdDtRJg++Wf/5/TdlAWz/2zpzC0SpNoKO8kQzxe+D+/CV32DYiei
         hWUiehYOrYr6o+pXRSYXzDeHaRewVB4W3brGd7XdgjdZcaMBtid6749Kd066nKPXVBHX
         AG4NEFPHl3dE5kk8BVKXevnd7+aG2w0rexQXLtxpCFmDtR4tzqymJ17bkGNG3RALRn9U
         AdVQ==
X-Gm-Message-State: AOAM530LXDalVZllaSXNRivs430e7LXj0r6h2vm1j/LFKBtDyygQcyg9
        H6B2PS3e4hBcfguaZp0/ex44WkPh
X-Google-Smtp-Source: ABdhPJwqtVHcFLvjJ/rUshHkDB4qTN99rmQAf6mxEdrResdb1IJ0p3Pn985DPuCcv0Hv0qAWTqCKOg==
X-Received: by 2002:ac8:3210:: with SMTP id x16mr1306222qta.192.1591936621347;
        Thu, 11 Jun 2020 21:37:01 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:1179:8d76:2c34:5284? ([2601:282:803:7700:1179:8d76:2c34:5284])
        by smtp.googlemail.com with ESMTPSA id c201sm3683592qkg.57.2020.06.11.21.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2020 21:37:00 -0700 (PDT)
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1BBVENIXSBjYW4gY3VycmVudCBFQ01QIGltcGxl?=
 =?UTF-8?Q?mentation_support_consistent_hashing_for_next_hop=3f?=
To:     =?UTF-8?B?WWkgWWFuZyAo5p2o54eaKS3kupHmnI3liqHpm4blm6I=?= 
        <yangyi01@inspur.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>
References: <4037f805c6f842dcc429224ce28425eb@sslemail.net>
 <8ff0c684-7d33-c785-94d7-c0e6f8b79d64@gmail.com>
 <8867a00d26534ed5b84628db1a43017c@inspur.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8da839b3-5b5d-b663-7d9c-0bc8351980dd@gmail.com>
Date:   Thu, 11 Jun 2020 22:36:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <8867a00d26534ed5b84628db1a43017c@inspur.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/11/20 6:32 PM, Yi Yang (杨燚)-云服务集团 wrote:
> David, thank you so much for confirming it can't, I did read your cumulus document before, resilient hashing is ok for next hop remove, but it still has the same issue there if add new next hop. I know most of kernel code in Cumulus Linux has been in upstream kernel, I'm wondering why you didn't push resilient hashing to upstream kernel.
> 
> I think consistent hashing is must-have for a commercial load balancing solution, otherwise it is basically nonsense , do you Cumulus Linux have consistent hashing solution?
> 
> Is "- replacing nexthop entries as LB's come and go" ithe stuff https://docs.cumulusnetworks.com/cumulus-linux/Layer-3/Equal-Cost-Multipath-Load-Sharing-Hardware-ECMP/#resilient-hashing is showing? It can't ensure the flow is distributed to the right backend server if a new next hop is added.

I do not believe it is a problem to be solved in the kernel.

If you follow the *intent* of the Cumulus document: what is the maximum
number of load balancers you expect to have? 16? 32? 64? Define an ECMP
route with that number of nexthops and fill in the weighting that meets
your needs. When an LB is added or removed, you decide what the new set
of paths is that maintains N-total paths with the distribution that
meets your needs.

I just sent patches for active-backup nexthops that allows an automatic
fallback when one is removed to address the redistribution problem, but
it still requires userspace to decide what the active-backup pairs are
as well as the maximum number of paths.
