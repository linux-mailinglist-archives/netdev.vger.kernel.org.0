Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7A33FC4CA
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 11:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240405AbhHaJC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 05:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239721AbhHaJC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 05:02:58 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242B3C061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 02:02:03 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id s3so30483573ljp.11
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 02:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=82wEVgxf11LlkOeTx0adpoZG5S2V/OUXzk9UIfE0jSQ=;
        b=kLeTVclPc/dJ6c7Iq1nRMFun16+FOAsBSHiyVaAuJSxKCPGN70wK99WBQ3G2Fsloqa
         wPgp70rr0ERHwNc3gvVTqUxpqxXxPQLDUKcx8RFQGynLQ8C5do2fpni64OfapGRMYRLR
         73z5VaABhxMU4tlqBZdI5VWOKFirdf8J0mwOsLFwjSTM52TbHd+l+ZkfCrAIdH13uxKy
         6rm+QC4y/kjen8WQGEqmcAcUW2Fqj/UZ6OzzIqlHbB4NKZ0iyv45RLGNVYnDJYempUkT
         kjtERnLcpxIGUA2qPk7+2Ha7yVdapo5qPflYMVjJfWsp5we0JFraaK/9b9uS2mRFFWbK
         nCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=82wEVgxf11LlkOeTx0adpoZG5S2V/OUXzk9UIfE0jSQ=;
        b=nxLXwLxH4EOpkMcdmow+PhZ/B8rCVO/2A3BbsXQIiw5P2Ga/ZTtnI0GOp+KZ4rgeK8
         XcKBFbWarShnZk/E8m+dX2wXOswDUkXc4HZyGxfeDM+HN2dH4KEM/eNI73VBCEEEDriP
         yJVWWfa1Sac5jBMO9xOXDA/faR0LhkugOWfk47lxBp8a9JbZNSERTo+pq/G/3VG/Dhya
         W2pHSSEdY/C9ZyjaGYfKKltEzwSFBNAOzZeX2KxcoPHC3kShFlYFdqHD4OWG238jQiJT
         B3T2SUc9bArsloHv2BARZIPUCWdpQvLL06tVa+Q+VP6J/QtodmtI8Fqgwa4H5XgWiHHK
         5myA==
X-Gm-Message-State: AOAM530nxt8Xnash9XpD7Di72BZT01b5lh0/vwfeKYeoYkZmiEEp/rEb
        dQ2Y07w50ZwykBOAWYmRpLw=
X-Google-Smtp-Source: ABdhPJwxTpPwBFrlO71PGShq6vqr5TAO8gua+1n+U46/g9/uxyPalbNPvzO/nTvx6KxMVDAEyENgVA==
X-Received: by 2002:a2e:8e39:: with SMTP id r25mr23705319ljk.272.1630400520873;
        Tue, 31 Aug 2021 02:02:00 -0700 (PDT)
Received: from wbg (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id u17sm2291590lja.45.2021.08.31.02.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 02:02:00 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH iproute2-next 06/17] bridge: vlan: add global mcast_igmp_version option
In-Reply-To: <20210826130533.149111-7-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org> <20210826130533.149111-7-razor@blackwall.org>
Date:   Tue, 31 Aug 2021 11:02:00 +0200
Message-ID: <87pmtuoulz.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Nik,

awesome to see this patchset! :-)  I've begun setting things up here
for testing.  Just have a question about this:

On Thu, Aug 26, 2021 at 16:05, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> Add control and dump support for the global mcast_igmp_version option
> which controls the IGMP version on the vlan (default 2).

Why is the default IGMPv2?  Since we support IGMPv3, surely that should
be the default, with fallback to IGMPv2 when we detect end devices that
don't support v3?

The snooping RFC refers back to the IGMPv3 RFC

  https://datatracker.ietf.org/doc/html/rfc3376#section-7

I noticed the default for MLD is also set to the older version v1, and
I'm guessing there's a reasoning behind both that I haven't yet grasped.

Best regards
 /Joachim
