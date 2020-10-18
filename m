Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A84729180A
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 17:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgJRP1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 11:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgJRP1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 11:27:19 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59119C061755
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 08:27:18 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id k6so10089574ior.2
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 08:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xxetPx4u+QiDU/ybn80IZGIewcRYEfrsACrq35pQrlE=;
        b=vR48Wlxq0wpJfaVeuTQZZ9CE5PzfQW1TU2UVQGp4z3aHLtYgU0sFIIYciPVsAQMxLe
         H+y8aNhs+AXl4e4qF0Q1NF4K2Kx5HVvU727XgRqu7xpbdtKV89V1c33rOjonA6IOdBjY
         BDsBimriG+mjNJ8y0P7prgoVZukdevl0SyqAAgPt2QmJ/Ordw2U/NLhY/s9+pQwz2T5K
         RKHdWPSsBei3gw8zP7+/n5Ah2ssVVCkJ6I/8xd9iGwmDQz/f6uvPwV7+QWZaV5P4K5LE
         vxktUTy33pMCDDcExBs4aicEG/I0mwHfT5Wb0WJI7UluwK/Nohk5bDHCmfewBfwaK6nd
         A7Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xxetPx4u+QiDU/ybn80IZGIewcRYEfrsACrq35pQrlE=;
        b=lJZIc/b2rHEALYLqKC6rsBmds71vQv95z7ocEx5mahX/JWRZxtvdlE0TMPObmzIUmX
         UH54tmilE1WSsQeUscHb45xVg6Kd1gcHU9eJizCRbftlv+JjzeT6cahNiEnGyEy0zn9C
         nrg1FcyXBk4SCqjFQ0K1mtEPP5QRJAl2olL5SlUtSUp+njzxj5pl6LUaQcm7DunZXgjJ
         I8lNQ1aS5Ark9WLqNJR2dq+ZZAt/kT9g/o2ni/VOmH0rML/KpGEcBavJdj+ABjCEYK3o
         0QfYJ1Ml1ld8FaVD7ciyh6ER/EIFtkeJH1VMsoxV61uGzNaMlnAzoqu3P2AGX/ATeTs9
         /yTQ==
X-Gm-Message-State: AOAM5310ZVWPQWe9fwVxHrEIdWXhfrYM5FysR6+cK9Cc7JFJCFaV2aaV
        9lv9P/HicDf+o9rSqvnBfLgdlcIcOA0=
X-Google-Smtp-Source: ABdhPJyu7LUkcEhlNELch0r1IFzI5WSW+MgFom3ZYszUpRro9qy/WQAUsIVNkysEuPA95p8ZiZW9dw==
X-Received: by 2002:a6b:9243:: with SMTP id u64mr7923158iod.197.1603034837561;
        Sun, 18 Oct 2020 08:27:17 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:284:8202:10b0:d908:7fe8:cfc0:66e2])
        by smtp.googlemail.com with ESMTPSA id a11sm7371956ilk.81.2020.10.18.08.27.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2020 08:27:16 -0700 (PDT)
Subject: Re: Why revert commit 2271c95 ("vrf: mark skb for multicast or
 link-local as enslaved to VRF")?
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org,
        sashal@kernel.org, mmanning@vyatta.att-mail.com
References: <20201018132436.GA11729@ICIPI.localdomain>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <75fda8c7-adf3-06a4-298f-b75ac6e6969b@gmail.com>
Date:   Sun, 18 Oct 2020 09:27:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201018132436.GA11729@ICIPI.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/20 7:24 AM, Stephen Suryaputra wrote:
> Greetings,
> 
> We noticed that the commit was reverted after upgrading to v4.14.200.
> Any reason why it is reverted? We rely on it.
> 

$ git show 2271c95
fatal: ambiguous argument '2271c95': unknown revision or path not in the
working tree.
Use '--' to separate paths from revisions, like this:
'git <command> [<revision>...] -- [<file>...]'
