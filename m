Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37F0288964
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 14:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387891AbgJIMzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 08:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387878AbgJIMzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 08:55:45 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F6AC0613D6
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 05:55:45 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id s4so10384251qkf.7
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 05:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=gHpUJmDZonPV5j8bU/1gBGhpCio2vFsUWRF9qpU9vW8=;
        b=Lv+1KPQkmVCaxhltL1Bptxe2IohBZ8ELxZYbQe/XYjACfOACvHXKhaHyOm8IR0GUew
         wat8Nj2Kwua/hznueUu76ai46V0xbmWtGqGpay8TEGG3L6pIlpW4gQYKFpBSgfA2vS+z
         9E68uw+n3AT99JdnfW9e4IN0hpwEPbhb6qmGJF7AY1/4uooFoN8UYUvXXaX5eZ2StaXW
         jjPAsYOcCPkui18mRBdvgTk/w/ew74rkYLDr+A5UusbAblZBRZ4CENgT5jXB793qRjrl
         smtWElf1b/JVS6VPvhfcX7WOPh2LvFnmOYbXcdi65lLTWZdbuIXdoHxhBGNEmAIFgp4r
         OMtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=gHpUJmDZonPV5j8bU/1gBGhpCio2vFsUWRF9qpU9vW8=;
        b=QF24bSnonQ2hdu+b5XDLLl9EcDVzZaRMRSWTPPDG96kRaWBbynKbao0tEzJNIjPrVF
         1f0jxg9+2k6aicXNaFtW3nJRJsYMYn8xTVNvAGtegMIo2T3HNtzJlZzQakQ6N+rxG5mY
         VnxpmA00T1XJ8hchNgQ9LDa96N6ZdSa8IZfvSdqKTZs1T4DJ9nsM8sMHwXuXq3fzlNmP
         fWYW4XE3z5MEdhgsq+Cbr1EsQs3oSo1USTAOuC5Y3GTOdmL9nXV5A5zbBorK0JI5Fz3F
         zszzbnEpwnK+SWOK1HocPPskce7a5rmheRfy1mPUAaL9kwgXUyChwWGzCXcomnl5MeCr
         9/ug==
X-Gm-Message-State: AOAM533twGgrTD2Iro7MPzbe1IgEVHFLFBigQpoiBafiuRegj4SMPPYS
        jncsOjZUle3DYgSZAPTMedwZLA==
X-Google-Smtp-Source: ABdhPJyEXSEu+fLH6EcqCWM/nDKyRAe6bzO6Hgdk8YDlZ9eCtXjIZcw4aQ6Gim1mSBxKZLtFvn/A1w==
X-Received: by 2002:a37:c51:: with SMTP id 78mr13313885qkm.30.1602248144600;
        Fri, 09 Oct 2020 05:55:44 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id d78sm5775681qke.83.2020.10.09.05.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 05:55:44 -0700 (PDT)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: 0x14: Videos posted
To:     people <people@netdevconf.info>
Cc:     speakers-0x14@netdevconf.info, prog-committee-0x14@netdevconf.info,
        attendees-0x14@netdevconf.info,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, lwn@lwn.net,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Christie Geldart <christie@ambedia.com>,
        Kimberley Jeffries <kimberleyjeffries@gmail.com>
Message-ID: <95981c19-d157-0f13-ed3f-ce82b612e12c@mojatatu.com>
Date:   Fri, 9 Oct 2020 08:55:43 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


To everyone (PC, organizing committee, speakers, workshop chairs,
Tutors, sponsors, and attendees) - thank one more time
for making the conference the success it was!

The videos are now up.

The sessions page is at:
https://netdevconf.info/0x14/accepted-sessions.html

The videos can be viewed directly on the 0x14 playlist here:
https://bit.ly/2SHJWow

cheers,
jamal

PS: apologies if you receive this multiple times...
