Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A005542FF55
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239159AbhJPAEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235896AbhJPAEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 20:04:12 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA51C061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 17:02:05 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id g125so15322445oif.9
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 17:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XnHDGEE6L64o9fJgbhzw9HiCviY4S3K7IWTZ4pRYfm8=;
        b=GemM4bPJbPXAZJwCf06nh0bRJwF5ROeaabPzSKcgzegviIdCrHX5QLK6y4NdNfmkFp
         FYk85BtlRPSKsEKJ+ORojgt6KLdyHQbGDto3+mJsh5ItXdyygC1JeRG6fSEbu66x1DaY
         Pg2LQKCwDWM2pA80oCiyC9+XTWYcIHgvnUPRprVDOuD93/jFU2/5YpMB1wx8nLk6yQlQ
         p+px5qzWA81s0ZKki870HJOHsSNb44973Y5PTHrv/w4+0SBWP0IB01i2xcuQw9I7dgMR
         Y0ox87CDk5zIWNSu1oNstcKUGCD7dlmdjTkQr68PZZusN0zuabV+BQA6/v0SzBWXE9oc
         3OTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XnHDGEE6L64o9fJgbhzw9HiCviY4S3K7IWTZ4pRYfm8=;
        b=QXRr0JfHYnSwkED/SeTtFT54/M7pkgL50Bb40EIWdxquuEDt8dLg2rdfHhrWOwRY/l
         y1fI7ASJgmar+ElXA76NnB7rhXLVzG6mvzUaqVL0C7iVO314kw8m4ZwolFQRlEjmNVqK
         VitQVzkqXlWgetaOrpDCxOisTukllz5kMElC8mYW8iK97JeV3IACXI+4Z4TstmUUAtcL
         zPkCMd6RL/+6rADQV2VrwqK3m7E9+KSjHU3NTcsRq3aG4IcppSBbBadYgy4J38vPw5Zf
         3viFttt2tW6+y7w7sE5bOC6zRxMiQV1JR/WFKa7Lbn9LYy8JpU1pn+RKRK6lrjrgOg8Z
         Z5KQ==
X-Gm-Message-State: AOAM530bkCBH/FFawq8amaZ9m8iAdWJED4uBRQZiK3HBe4XeAToVBUyl
        mxgdeLIxQQLNSgJ5czVIgRoINKRb8JYMGA==
X-Google-Smtp-Source: ABdhPJyMWNT7g/hrUpziBpKJ2jOf2OfxC2/oHV5daqzP9Rfcfyk/nJiHzCUoLcwfpMxqx0WH+WeBog==
X-Received: by 2002:aca:bd02:: with SMTP id n2mr19841055oif.113.1634342524796;
        Fri, 15 Oct 2021 17:02:04 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id o16sm1256717oor.41.2021.10.15.17.02.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 17:02:04 -0700 (PDT)
Subject: Re: [PATCH iproute2 v5 0/7] configure: add support for libdir option
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, bluca@debian.org, phil@nwl.cc,
        haliu@redhat.com
References: <cover.1634199240.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e892800e-b914-78c8-f6af-033a5dd2144e@gmail.com>
Date:   Fri, 15 Oct 2021 18:02:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <cover.1634199240.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/21 2:50 AM, Andrea Claudi wrote:
> This series add support for the libdir parameter in iproute2 configure
> script. The idea is to make use of the fact that packaging systems may
> assume that 'configure' comes from autotools allowing a syntax similar
> to the autotools one, and using it to tell iproute2 where the distro
> expects to find its lib files.
> 
> Patches 1-2 fix a parsing issue on current configure options, that may
> trigger an endless loop when no value is provided with some options;
> 
> Patch 3 fixes a parsing issue bailing out when more than one value is
> provided for a single option;
> 
> Patch 4 simplifies options parsing, moving semantic checks out of the
> while loop processing options;
> 
> Patch 5 introduces support for the --opt=value style on current options,
> for uniformity;
> 
> Patch 6 adds the --prefix option, that may be used by some packaging
> systems when calling the configure script;
> 
> Patch 7 finally adds the --libdir option, and also drops the static
> LIBDIR var from the Makefile.
> 

applied to net-next. Thanks for working on this.
