Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD8A26FFAD
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 16:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgIROUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 10:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgIROUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 10:20:04 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C715BC0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 07:20:03 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id k14so6314052edo.1
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 07:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=R7DF7jEYqvBdRq7ZNCghITrEelCFxCHmWgXevvmD2z4=;
        b=BJGc0QbHtsCL3qg5oHeVj58Aj3yyeTQenOWdsJd+rZ7IOw2TkGVI4qZryCTMKPY97X
         SD1mrd/6Y35l+xxrwIcuO+qqKlEC/69Rq3iNqfvMo3luMX4zRVUrODTCB2vFudLQCQF0
         JNB8B74TcmLV2e4tXyu2/2PNR9CGhzNt/1IU6Z1ptu5gExOHmJ2erxEbeWlVwdUwlx+2
         X70AFryKXb1hzjTDuKJp7a9W20q3Al3v+w4VQCRQVeeUd+lruFwaauW8PtAkpLyV8/1T
         ixvvTA4TPc45QAd+qex2Who3xD1O5Hj67yKac7VL5mQZlwPadUsm1zcNhLEoatqQVoq7
         9WJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=R7DF7jEYqvBdRq7ZNCghITrEelCFxCHmWgXevvmD2z4=;
        b=mQwE+R60kkyRBHaVWCpMoEO2fHX1ES1NfzQJqaS2bKzAM3lLXqawPUdtqUdBLMwEcp
         6I8tKYrW+keJw7z7BJ6ilUnAslrNXJVGsZCWJnLKbrf8WU9yolt7/uy5xAdEcBHHjDTs
         rETRLaym14dzmDtm9mCdzfhzofLX33knTZDf8UvQz7W5h5su/0p41OFuGo7WXemWJd5y
         Hets1CvAGvRePgEn9r1cYVrAN5lUDjdPE6Vjzl/GcxFztLAQ5HEGUjYniVTG1adLzkVF
         QTOI81IrEQCpC4Umm/EgXBgABgkIxihvurbeVyWm2hFpRk0ozpw+OK+rPaLO1QE1BaMK
         LEww==
X-Gm-Message-State: AOAM533+Co7+VZM1dWJpwmcD1Jcios99IJW4zbIjxQeMiXFF18GOs0hR
        Dfq4821sieAPNlXnuP1B2dr15A==
X-Google-Smtp-Source: ABdhPJym9QwtZS+OPv3kGgI6x8ns3WfM5pfyOsKwrskqKf9jcfbsEp9oTLkOD5nVZZIUSwUn/D867Q==
X-Received: by 2002:a50:fe0a:: with SMTP id f10mr25982386edt.133.1600438801744;
        Fri, 18 Sep 2020 07:20:01 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([81.246.10.41])
        by smtp.gmail.com with ESMTPSA id l26sm2352402ejr.78.2020.09.18.07.20.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 07:20:01 -0700 (PDT)
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        MPTCP Upstream <mptcp@lists.01.org>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Request for net merge into net-next
Message-ID: <07cc0dc2-f789-fc5f-b0e8-88daa249ffbd@tessares.net>
Date:   Fri, 18 Sep 2020 16:20:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Jakub,

We have a few net-next MPTCP changes depending on:

- 57025817eaa4 ("mptcp: fix subflow's local_id issues")
- 2ff0e566faa4 ("mptcp: fix subflow's remote_id issues")
- f612eb76f349 ("mptcp: fix kmalloc flag in mptcp_pm_nl_get_local_id")

We guess you are going to send a pull request for 'net' to Linus soon 
and sync everything once it is done. But just in case, if not, could you 
please merge 'net' into 'net-next' so that we can post without causing 
conflicts later and issues in tests?

Thank you!

Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
