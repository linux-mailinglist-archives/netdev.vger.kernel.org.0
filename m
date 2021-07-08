Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A1C3C1917
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 20:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhGHSUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 14:20:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60951 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229768AbhGHSUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 14:20:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625768279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SO03xakY40s8N1+WAWasQT2ggeCA8hIJcILoFkFBttY=;
        b=DpVY8UpO5+r+U9o4zvoiV0Y4S0eLQv8NoRmU7NryUUWRfdHPQMTYnRPxdLte9xZvuwqO1m
        U8eSEe0Nd/aRz77cjF5mChuNtTwgJDslMRaZ38OyzSUwV3dPhO7Uwo8IRmNvAcdzRKetlA
        RXjG7pCicWxtn5KzSpM0tM4Kgc/d9tU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-oIQzgSyLNEGSF-zJTSXiKg-1; Thu, 08 Jul 2021 14:17:57 -0400
X-MC-Unique: oIQzgSyLNEGSF-zJTSXiKg-1
Received: by mail-ej1-f72.google.com with SMTP id 16-20020a1709063010b029037417ca2d43so2199662ejz.5
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 11:17:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SO03xakY40s8N1+WAWasQT2ggeCA8hIJcILoFkFBttY=;
        b=oD6l7nDniXMEqu0ihnko0AVZo+DY+h2j1NHVjb7sdWfPg337TFXg9OSMy1RXlXHrtr
         H0jR+1nielnUPtu+tMJxj/8WYMvQGF7MgxPXAlDr8JW8EB2N/ODGvjmMwIP6PLw/9AW1
         mRq+9N9wmaJUTHn/sd1JY+fx8C1lCHdQfv3sc50+5l7yO6pNCLyq2aUWG12dAu1O2Xs6
         ji/mMvZacjYzGml/AIeID3pjaLLti+CRhWFgzHtUXK0zSVNEov4Ra4Rufc5ImpFoz95X
         C8jZE+RfbRJiVpLfHtgCQKzYkANlVLevKB+uWjTRUuACb3J3ItV1DxBR5BoMWUblHHrw
         Hl9A==
X-Gm-Message-State: AOAM532nvpXHcf8RCPDe46+/sPgSer/NNMKfrb73SQNE/J4vpW46dIpu
        bdzu9Tx1V3RNEeEZVJeYmt9tC2Xsh4gqDnaU9j6dPkiaDA31ejo1WOCv33m4vsGQHQbwypXEyXu
        jT1xT1+GHzD5mbXctjaO2K4zwgi2MD97KzMWZt8uP9hh5oK8mQjPttaRvQfkpbGsFROkT
X-Received: by 2002:aa7:d9c9:: with SMTP id v9mr40275622eds.42.1625768276277;
        Thu, 08 Jul 2021 11:17:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzF+MdSofNjk71MMybcq+V6l3diSzd2mj1To6c8XO6nG3nanDwKFjr7Lj8eq8s/rL5e6xNORg==
X-Received: by 2002:aa7:d9c9:: with SMTP id v9mr40275597eds.42.1625768276045;
        Thu, 08 Jul 2021 11:17:56 -0700 (PDT)
Received: from localhost (net-188-218-31-199.cust.vodafonedsl.it. [188.218.31.199])
        by smtp.gmail.com with ESMTPSA id i11sm1620327edu.97.2021.07.08.11.17.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 11:17:55 -0700 (PDT)
Date:   Thu, 8 Jul 2021 20:17:54 +0200
From:   Davide Caratti <dcaratti@redhat.com>
To:     netdev@vger.kernel.org
Subject: Re: [PATCH net 1/1] tc-testing: Update police test cases
Message-ID: <YOdBUjdGZQUeqX8s@dcaratti.users.ipa.redhat.com>
References: <20210708080006.3687598-1-roid@nvidia.com>
 <54d152b2-1a0b-fbc5-33db-4d70a9ae61e6@mojatatu.com>
 <1db8c734-bebe-fbe3-100f-f4e5bf50baaf@nvidia.com>
 <f8328b65-c8db-a6ae-2e57-5d1807be4afd@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8328b65-c8db-a6ae-2e57-5d1807be4afd@mojatatu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 08, 2021 at 09:05:03AM -0400, Jamal Hadi Salim wrote:
> On 2021-07-08 8:11 a.m., Roi Dayan wrote:
> 
> [..]
> > 
> > no. old output doesn't have the string "index" and also output of index
> > is in hex.
> > 
> > it is possible to make the old version work by allowing without index
> > and looking for either the unsigned number or hex number/
> > 
> > but why do we need the old output to work? could use the "old" version
> > of the test.
> 
> I think that would work if you assume this is only going to run
> on the same kernel. But:

in my perspective, that's already an issue (though a small one), because
somebody needs to ensure that a kernel is tested against a specific version
of iproute2. I say "small", because most probably the test will be waived
or skipped until all the changes (in iproute and kselftests) propagate.

> In this case because output json, which provides a formally parseable
> output, then very likely someone's scripts are dependent on the old
> output out there. So things have to be backward/forward compatible.
> The new output does look better.

the JSON output is something newly introduced  by this  commit, and I 
agree  it's good / sane to see 'index' and decimal printout in there,
like in other TC actions.

> Maybe one approach is to have multiple matchPattern in the tests?
> Davide?

sure, that's a possibility, but then:

> We will have to deal with support issues when someone says their
> script is broken.

that's probably something we need to care of. TC police is there since a
lot of time, so there might be users expecting no "index" and hex
printout in the human-readable format. If you use the old format
string with PRINT_FP, and the new one with PRINT_JSON, you should be
able to run tools/testing/selftests/net/forwarding/* and
tools/testing/selftests/tc-testing with the same iproute program,
with no "spoecial handling" for act_police.

WDYT?
-- 
davide

