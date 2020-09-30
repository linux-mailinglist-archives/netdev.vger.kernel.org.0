Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03F027EDEB
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730632AbgI3PxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgI3PxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 11:53:14 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BBEC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 08:53:13 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t13so1283715plb.10
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 08:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=swIUQiVFaYvHqLxfhGPku+zeCACnBKIKCwr5CUvrZ2Q=;
        b=Yc3Ozwlq/27LSPl7CnX91fhyQXXnrc9474mTY+Y8rxP48QbSCdWP5Ev1sQfd0Josqz
         Ro3GNYUZSvpOUM3dLBFcTLNKKb3ql2Lgqs8BO8izzmUx38/nfu4apBZnS7s+l0DKw6o1
         iiqAM6BCOb1AkgaCGlVk5BA7B292J+Ww2LCFtgByboFszaGlIeWJiX+78Jsu/AdDcx3k
         mrUBr76UmdHIbFntlZubx/QnVx0r2cAfo1V2lsZoc2BZjmjWuwWyE87D3T0sYcGNvGjX
         Q3yY/Aq6yEJh73lNjMdZ3UHnVf/fSPMFSH+/HrzjZoOSfAI1QJUCNtUg3uyHyQMGv4eS
         jK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=swIUQiVFaYvHqLxfhGPku+zeCACnBKIKCwr5CUvrZ2Q=;
        b=F4nB4cyNOumeLnxFh9rZL26KJeSUMzlpsUViNNO5jFzpI6yPyc91u3+lwRCewZ/dOg
         vnqWsnoC13zLPIn3AKRm6AQeJR01RDvm9OJLj7JXf0qB4OzWrjA8INAT1PkjydqzCKRc
         VuydeykOAF/M48Xl/kHO0PqjsQDaSvGUDrZniK5rnpqCXS/KeEPnkh3OMeA2PHPhOJvL
         KhjHYIe8giaOwl3eBx1svAao+abGAnE1O/8v47/SnqgVN79POZ17LIiENXBajzfL2378
         Yil9HXk0ruNpe77h80OrK7vSbyhzkN6NNKiXTT6Q43CHnPj+Y0ZfHYicMiXbn1KUUH5h
         1/BA==
X-Gm-Message-State: AOAM530t+GwamXWi55p390doXe3v7uZnjIGmrYGKw85MkQ2dR5+Mgiky
        EVrF6LVPOks5F8fHADQKwnuZYRp5jRECWw==
X-Google-Smtp-Source: ABdhPJwkX/ogYmX1FT9meOZ3BwK1QEryrL08mXve5NcK1SfDUh8K6ZuLSWQhAqMt1oA//x3PMmtX/w==
X-Received: by 2002:a17:902:9694:b029:d2:1b52:f46 with SMTP id n20-20020a1709029694b02900d21b520f46mr3028960plp.78.1601481192607;
        Wed, 30 Sep 2020 08:53:12 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id j144sm3097089pfd.106.2020.09.30.08.53.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 08:53:12 -0700 (PDT)
Subject: Re: [iproute2-next 2/2] devlink: support setting the overwrite mask
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
References: <20200929234237.3567664-1-jacob.e.keller@intel.com>
 <20200929234237.3567664-3-jacob.e.keller@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ea1c0928-c865-3bac-0898-61ff54e74e7e@gmail.com>
Date:   Wed, 30 Sep 2020 08:53:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200929234237.3567664-3-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/20 4:42 PM, Jacob Keller wrote:
> Add support for specifying the overwrite sections to allow in the flash
> update command. This is done by adding a new "overwrite" option which
> can take either "settings" or "identifiers" passing the overwrite mode
> multiple times will combine the fields using bitwise-OR.
> 

per my last request, please roll the cover letter information into this
patch log. Headers are updated by a sync, not individual patch sets
making this a 1-patch set and the git log should contain the example
commands and overview from the cover letter.
