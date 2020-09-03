Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE8B25BAAB
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 07:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgICF5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 01:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgICF5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 01:57:32 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95406C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 22:57:31 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z4so1766430wrr.4
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 22:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0cLcEDkB0cieEHnFjZFG8vgjCv+LK2cnNzMV4mmRD6o=;
        b=V/dkrpkkQePuyRvKXGcLbyBd2E6DotZyBB7ugmZ0bXE0kVgkhNPTitGzFUvXhQ5blr
         Akc5pzfkvLCBAG/vLVyfjU8Pql5DevAWS/R8gKH1asCEWbt5IMvZGpi+lzgWPuIhnHAw
         TPbfN/zLnmmcRGcGV0fshOayt1NYx9SCIxwXz9285YVPvsDImWKTeL+0Mqvy7yoLBcNI
         gTCrG6eXIikxWUIEqBn1wUcxiEGBcKhW80y/l35gdvJGU9JAcjqMi8KhIus/BITMVANx
         ncwcHxKayEa5WjYx5CM+v01N89crOj5yGXi7DQSwygfYoZZzLcdSw2B/RfOpa+YBawaD
         sYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0cLcEDkB0cieEHnFjZFG8vgjCv+LK2cnNzMV4mmRD6o=;
        b=GtZRrdFceH7oKNzG2KqM8CfczVllqLIjq+uYwrhwdytZYqsKD8m/e1wIDUzRiQRXBj
         3m84YEDTF2yLZL0E82ky+H0EHT8MtAVA72dwwWVTY2n/V6NOVc53Q0RugSC/g/0KY8A4
         qRamIeTDnkhDMlzPCWdwcpsmN0ucljVYVHHABEeo/YOpIxG9O4KXYnurdAI0uWy1bEan
         LajpKFohVj8tM/r1pfJ3HsASh97368k8xCw8EW6624nP1lpJy58B4G6s4Rn0ToT7sVKM
         yZF6YiA53NYrk6vOk81p3c2YKNvLfdJuchk9syjt2TbsYDRbHKj432OboySzpPuPPPc8
         mHRw==
X-Gm-Message-State: AOAM533+GLTDPMQmoPhnaC6FnWSzmuuqKO02Fh4vxcHVCMd8WGoGO+kV
        XtJU6SuPhCpvtCbJXCaY3cMg9R71cFAiE/UM
X-Google-Smtp-Source: ABdhPJxQgkxBtohhCsr4H0v0wzSWrAQ8ofJ525rt3OzN2RstTyakQYN4Q1D8nQumpbglXOuA8l9wPA==
X-Received: by 2002:adf:fc0a:: with SMTP id i10mr440403wrr.111.1599112650340;
        Wed, 02 Sep 2020 22:57:30 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id g12sm467061wro.89.2020.09.02.22.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 22:57:29 -0700 (PDT)
Date:   Thu, 3 Sep 2020 07:57:29 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Moshe Shemesh <moshe@nvidia.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v3 01/14] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200903055729.GB2997@nanopsycho.orion>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
 <1598801254-27764-2-git-send-email-moshe@mellanox.com>
 <20200831121501.GD3794@nanopsycho.orion>
 <9fffbe80-9a2a-33de-2e11-24be34648686@nvidia.com>
 <20200902094627.GB2568@nanopsycho>
 <20200902083025.43407d8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902083025.43407d8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Sep 02, 2020 at 05:30:25PM CEST, kuba@kernel.org wrote:
>On Wed, 2 Sep 2020 11:46:27 +0200 Jiri Pirko wrote:
>> >? Do we need such change there too or keep it as is, each action by itself
>> >and return what was performed ?  
>> 
>> Well, I don't know. User asks for X, X should be performed, not Y or Z.
>> So perhaps the return value is not needed.
>> Just driver advertizes it supports X, Y, Z and the users says:
>> 1) do X, driver does X
>> 2) do Y, driver does Y
>> 3) do Z, driver does Z
>> [
>> I think this kindof circles back to the original proposal...
>
>Why? User does not care if you activate new devlink params when
>activating new firmware. Trust me. So why make the user figure out
>which of all possible reset option they should select? If there is 
>a legitimate use case to limit what is reset - it should be handled
>by a separate negative attribute, like --live which says don't reset
>anything.

I see. Okay. Could you please sum-up the interface as you propose it?
Thanks!
