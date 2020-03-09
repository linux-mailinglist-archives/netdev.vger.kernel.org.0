Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4028D17E413
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 16:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgCIPyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 11:54:12 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40791 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgCIPyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 11:54:12 -0400
Received: by mail-wr1-f66.google.com with SMTP id p2so11064740wrw.7
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 08:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iQAdBVPJl3sgSUDhzx9b8VhMSwPP8EHy78vnHlVTGNw=;
        b=VJe/4FZTvYT1YeaQCkNZpA8Z4KNusg4hX0oQHsT6y7O4u9tkBe+TYIpa1s67EGe4Ep
         gZq8Va4E/cJ/dcdGkrs7rozG3MkU7YS+4Di4oLZNDMURiG7ymlXXWrlp1oE0kzWFIKwZ
         4uLH7V8k90pNACCYQS/l3iKO+mat5nqLb6BBXGsCmkSz+HRlevGVA2xmvgFEUn8GfvRb
         cqE12S9KPpCeLsalJLY2mN3Au8sf3WY9BGqgfEmAxqQPz9+3gyCVHkh2TFn/gXky3wNA
         xV4Tu6sGQHZDhu1wWUSblDF1e0J6fp68XmPgX6SbJC/Q/jKoKN7sZZYy5WHXhkvs5r0T
         +7AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iQAdBVPJl3sgSUDhzx9b8VhMSwPP8EHy78vnHlVTGNw=;
        b=SPQd8gHO2XumwQrSgBqRYM3Z5sNPqqySLcKKUgW87azCbQq+uCWTjqoU8PrHKg7CCM
         88PCcFs4IOeiUhNoCE2d8VoHIucDaDeoelIgOmIGO91BTQ9ppEGIXpsbI1gXIcf6Gi+h
         gE6hXHTt9hrz65Pynu8LLx3oEsGg4yJ9m6nGgs+lEl/vmcnOx5T4O6JT89o/zqoLUnCz
         OXSYdH8IBghwknDdy6Y3KJpofma0u2NnzD3a6oyo+pM1zp7gBSvWnKtAnAWicfAe0ZZ2
         rwFVWQLiEClDBC5bhTYM/F7GS1vSyZPtPSrbNgsqed1czaxsCwucVI1rpjPXxVrnrz8h
         qmDw==
X-Gm-Message-State: ANhLgQ0y3WBXMs4wE8gRSqIsu3xRyiKHffwld67fE9sODk/Ue4g6mOfd
        PBq9c5JSXswxdmdu5gHrlsYL5Q==
X-Google-Smtp-Source: ADFU+vvKW3PN4Qph3Q0WAmMIEoNzFNsA8KmBDCnKTR/+5SZUPIjAFwOXB6dbUiQnI/baBFgUNjujbA==
X-Received: by 2002:adf:e447:: with SMTP id t7mr976356wrm.374.1583769250548;
        Mon, 09 Mar 2020 08:54:10 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id n13sm25870406wmd.21.2020.03.09.08.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 08:54:10 -0700 (PDT)
Date:   Mon, 9 Mar 2020 16:54:09 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        mlxsw@mellanox.com
Subject: Re: [patch iproute2/net-next] tc: m_action: introduce support for hw
 stats type
Message-ID: <20200309155409.GD13968@nanopsycho.orion>
References: <20200309152743.32599-1-jiri@resnulli.us>
 <39815e7d-7dd5-c5b4-54b7-90f6852a3d08@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39815e7d-7dd5-c5b4-54b7-90f6852a3d08@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 09, 2020 at 04:38:39PM CET, dsahern@gmail.com wrote:
>On 3/9/20 9:27 AM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> introduce support for per-action hw stats type config.
>
>You need to add more here - explaining what this feature is and giving
>an example.

Sent v2.

>
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>>  include/uapi/linux/pkt_cls.h | 22 +++++++++++++
>>  man/man8/tc-actions.8        | 31 ++++++++++++++++++
>>  tc/m_action.c                | 61 ++++++++++++++++++++++++++++++++++++
>>  3 files changed, 114 insertions(+)
