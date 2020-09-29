Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E1527DC35
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbgI2WoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728752AbgI2WoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 18:44:12 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9EFC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 15:44:12 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d9so6236871pfd.3
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 15:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=WJ3OpDbrgTgrQ83eHhTDtyYULkP8PFP3ddpTJ7Cz6JI=;
        b=HSRrcrIyGUWTHwolbw34ZUjTnHuIg3aAaGQBMIzy+t4tc8Vz6BSbZdLMIOyDGi6UQ6
         CmsXhwhg1QyL/oCo6bhvzgv03gjnjnMPFzd73Dc+PNEtCzjiD0bpQ44/tS14V9HjUOnj
         oJ3gVdhP6JgWhctqvUXqTgwz9ygmu+1qGtJGyOtEdEWiKibWbOksnxb4fvc4wu66E6uY
         Xddng3rRkAlCNrMPzCOWj8aZsOHyiNd6aIh+Cfgd8qPHyLMzij7V9U0ho6u6NDlimzYw
         tbPYwLNXFXNs9HaCrRQJ/aqTLY8YRr4PUIKOBDMFTCtfOwS5rusjKn0ijhLkOKmZA6o2
         Px4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=WJ3OpDbrgTgrQ83eHhTDtyYULkP8PFP3ddpTJ7Cz6JI=;
        b=i9b2rzevDKZvWJSezFM5OmwlUkiizIw4Mm+RQTSXqvbFu/WFmWvFJ5mb4uXKxz6G2X
         H6ic+/AzZhWY4oAfkidLm4xRbA7Uu5SxtPLjtO0aTVK8wy0M+nBUauAhAl7rcxjEq0O4
         SMW+6+vMMQBk4DLoCUzbDEQoQmFAqpC/XdQvOLttgEhVwA3JA5kNUO342qnuLgYH12dh
         Q5NbIXSClvYsf8+NuhwymT6oQmrDJfI04C0Qh5UNiZpoAKYrs9U07grT4KnsMUV5MfFn
         ZfNMGfGltYr0imZa+p+iNBxHBoqgNzdy+EdWpD9bP7/iyzuKHuyQN1zc6fQyYDQYqEXx
         O6+A==
X-Gm-Message-State: AOAM530PkqtrXdS28COotVKBmqa6HE3yo/H1G9mZnQr5Nh2bXptHisLP
        2ZiFe/0gGe8TODjOi33VPBMWTw==
X-Google-Smtp-Source: ABdhPJwAl73qbyVTDoXcKJPwWPHWg+QcdmxtCaCm2NLO+PEzxf193QdZOvGTw8aVDygF1c/UGOTPdw==
X-Received: by 2002:a63:5b5c:: with SMTP id l28mr4750101pgm.243.1601419451673;
        Tue, 29 Sep 2020 15:44:11 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id ep4sm5505819pjb.39.2020.09.29.15.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 15:44:11 -0700 (PDT)
Subject: Re: [iproute2-next v1] devlink: display elapsed time during flash
 update
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>
References: <20200929215651.3538844-1-jacob.e.keller@intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <df1ad702-ab31-e027-e711-46d09f8fa095@pensando.io>
Date:   Tue, 29 Sep 2020 15:44:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200929215651.3538844-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/20 2:56 PM, Jacob Keller wrote:
> For some devices, updating the flash can take significant time during
> operations where no status can meaningfully be reported. This can be
> somewhat confusing to a user who sees devlink appear to hang on the
> terminal waiting for the device to update.
>
> Recent changes to the kernel interface allow such long running commands
> to provide a timeout value indicating some upper bound on how long the
> relevant action could take.
>
> Provide a ticking counter of the time elapsed since the previous status
> message in order to make it clear that the program is not simply stuck.
>
> Display this message whenever the status message from the kernel
> indicates a timeout value. Additionally also display the message if
> we've received no status for more than couple of seconds. If we elapse
> more than the timeout provided by the status message, replace the
> timeout display with "timeout reached".
>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
>

Thanks, Jake.  In general this seems to work pretty well.  One thing, 
tho'...

Our fw download is slow (I won't go into the reasons here) so we're 
clicking through the Download x% over maybe 100+ seconds.  Since we send 
an update every 3% or so, we end up seeing the ( 0m 3s ) pop up and stay 
there the whole time, looking a little odd:

     ./iproute2-5.8.0/devlink/devlink dev flash pci/0000:b5:00.0 file 
ionic/dsc_fw_1.15.0-150.tar
     Preparing to flash
     Downloading  37% ( 0m 3s )
   ...
     Downloading  59% ( 0m 3s )
   ...
     Downloading  83% ( 0m 3s )

And at the end we see:

     Preparing to flash
     Downloading 100% ( 0m 3s )
     Installing ( 0m 43s : 25m 0s )
     Selecting ( 0m 5s : 0m 30s )
     Flash done

I can have the driver do updates more often in order to stay under the 3 
second limit and hide this, but it looks a bit funky, especially at the 
end where I know that 100% took a lot longer than 3 seconds.

sln


