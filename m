Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15F1A242EB
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 23:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfETViJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 17:38:09 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46007 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfETViJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 17:38:09 -0400
Received: by mail-pl1-f194.google.com with SMTP id a5so7286638pls.12
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 14:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gi4tKs7osYeDxJJSVH/Cid/fg14/a7uZkweSBaaoLeQ=;
        b=nZ3CYE5Lf0tB5BCwHph5nBQEY61SHL8oekOG/n9KyhX725ImnvVMAZK4roqe4+Y9Og
         Q6RFZfBnaZ/VZ8hwNKRlCnJ9g+Ff+kWu+QVI3sRbrMXTBfkuCFqX60sRN2wpCVuEYDQI
         eZiPAkpNdPAj7ayzZ6aqKb1/cYh0+xEp3vnyy72RVj6aqGEUT1tw1akxCHRcdm3Z0TKk
         R8uJUbahIWF+h13Q24SHpLCPtRFeZIUEHGKitj4IKXw8WN9iHuG26eYhZ84h1GCdSrFo
         nhNF51la2bOBrySSokNg7/r246V73r9XMkB247hg2gm2m9aaipCintGV3EWws1xyH2d7
         473A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gi4tKs7osYeDxJJSVH/Cid/fg14/a7uZkweSBaaoLeQ=;
        b=q5VwwztlSCoZQN183Q7dH4sJ8eMzFl9h4Q7r4gY0l9jKcXP8fE+BqWj5ME8tG7Fwcl
         8hB+Re+Aa9Wq2tvpxQeWIlUvlHA7VrpQ8nSdYgMAzcCkMgS0JlL8Wr2WuqSMBNCO4qVO
         sGJW0EPzlVN/Zf7c7wW1XiQLadGL9yO+73ZLRhXLWVPkTEtlMZD3iQDXNmO7FhujCUxu
         YkbritTtqrsrWIzPGG85P3B6Ht4i7E+WzND6su8VNLNuBJjMhXjn0ofkSgjR5vCCLhbx
         URiXO7H/otUeUQlMUCKRh37veatyLIGuCojsdnDPfz0jhilfpsVWSzcVRv4CdZaNY803
         DD2w==
X-Gm-Message-State: APjAAAWHli1jU04oJjmejxSdySBvomJURP/qgiCeTRetjGmmBri+1tm8
        DtbAuI3O2nX02VLif0jewxc=
X-Google-Smtp-Source: APXvYqxl0qpIMKUmhuxHLv21Q//DL0M4hxwFeoiR6P5CLTPs83CamPikb37M6GMrJSMqu2nUid4Juw==
X-Received: by 2002:a17:902:3283:: with SMTP id z3mr52041261plb.278.1558388288583;
        Mon, 20 May 2019 14:38:08 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:4813:9811:27e6:a3ed? ([2601:282:800:fd80:4813:9811:27e6:a3ed])
        by smtp.googlemail.com with ESMTPSA id j19sm22431554pfr.155.2019.05.20.14.38.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 14:38:07 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] treewide: refactor help messages
To:     Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
References: <20190517133828.2977-1-mcroce@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e363c59b-585b-b596-f588-3d9fd3c3b624@gmail.com>
Date:   Mon, 20 May 2019 15:38:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190517133828.2977-1-mcroce@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/19 7:38 AM, Matteo Croce wrote:
> Every tool in the iproute2 package have one or more function to show
> an help message to the user. Some of these functions print the help
> line by line with a series of printf call, e.g. ip/xfrm_state.c does
> 60 fprintf calls.
> If we group all the calls to a single one and just concatenate strings,
> we save a lot of libc calls and thus object size. The size difference
> of the compiled binaries calculated with bloat-o-meter is:
> 

...

> 
> While at it, indent some strings which were starting at column 0,
> and use tabs where possible, to have a consistent style across helps.
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---

applied to iproute2-next. Thanks for taking the time to clean this up.

