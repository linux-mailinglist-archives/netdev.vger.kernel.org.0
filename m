Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15D339A284
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404853AbfHVWBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:01:33 -0400
Received: from mail-qt1-f171.google.com ([209.85.160.171]:43443 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403834AbfHVWBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 18:01:33 -0400
Received: by mail-qt1-f171.google.com with SMTP id b11so9407907qtp.10
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 15:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=q94N1a4CEh/0zqhyBs2kCb5IhlZY38AuxFUVWZUpUwA=;
        b=d/seBOH0Rr4jXH6JE6gEzE4GS/Q4e/GbEHXihCrNhUxtpuwKkAtHRPTxfYo5HKSPfp
         e8vug1rYaoCjQawn7GnxR08fAzFh3bGin3QGOiqbavs6K8RUkPp/KF9WTSeDp+vzRV/2
         6iit5xWHKy/hSEdVsuqlJw3TMN+kQmSixuW9hFaHxPGFvEGf0gHg5BGRkSTaxSkQPIDN
         Rx8+2ZF797nubv/HMD0H7u1daWu7Yggb+qijoCSkrpMQNlDAjDcWtDgkHG5ywF0dglVa
         ME+y/hM2jQHpGayYYj+xpWV/EW0N05d2zecdhjIb4Z2l8Oz6lka06DwLfPQD1XNijOfg
         d2rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=q94N1a4CEh/0zqhyBs2kCb5IhlZY38AuxFUVWZUpUwA=;
        b=plA95E95cjztbo+to8R9twCBOcpPhI4u0qXN3gLTwDZLQRu9xHEXDMoQNLHakJoozZ
         LcQx4PjinxTmoviUiecQtEe3vBpJqllGmOxAVu1RsbNHj/wFO/KwqBJI2HFy0/VHSHc8
         kkL+3iit74FbLz1n1yUOvExIZVHYHSsSTE0/EpZ5n4og/Y+SM0vGaRpvSK12VfLk+ZeZ
         JXrhOScBKIEoWoHV8lL1BWR+yEe6W86JXDp4krDo7RVGk0VsWPqrYjWYRd39Ky4twstr
         7OXPQYPTUG4Y0/8vxI19qlT0BISsInpaheiaF2nk5tr/FclzMIe2EjD2Bw/XsFlgJCv2
         k00A==
X-Gm-Message-State: APjAAAUym5XXfAEdN6NGkbQfx+CsQHWJFwfRjKOSjrwHoSHWMXJ8Ht/j
        Wx9Ja65B7fzri2C893Bs8+CmFlZz8mM=
X-Google-Smtp-Source: APXvYqx/33hLmUf8s2vye8JD5S8SWyHAeX7/DBeOqyqob2u4au2eHidxhogbtB7VWvq8e7Co5UGeXA==
X-Received: by 2002:ac8:67d4:: with SMTP id r20mr1859680qtp.215.1566511292115;
        Thu, 22 Aug 2019 15:01:32 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y188sm517081qkc.29.2019.08.22.15.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 15:01:32 -0700 (PDT)
Date:   Thu, 22 Aug 2019 15:01:24 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next v2 00/13][pull request] 40GbE Intel Wired LAN Driver
 Updates 2019-08-22
Message-ID: <20190822150124.50e5b67d@cakuba.netronome.com>
In-Reply-To: <20190822203039.15668-1-jeffrey.t.kirsher@intel.com>
References: <20190822203039.15668-1-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Aug 2019 13:30:26 -0700, Jeff Kirsher wrote:
> v2: Combined patch 7 & 9 in the original series, since both patches
>     bumped firmware API version.  Also combined patches 12 & 13 in the
>     original series, since one increased the scope of checking for MAC
>     and the follow-on patch made use of function within the new scope.

Thanks, LGTM
