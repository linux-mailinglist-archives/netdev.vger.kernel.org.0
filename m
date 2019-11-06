Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76525F1A7C
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 16:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbfKFPzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 10:55:03 -0500
Received: from mail-il1-f169.google.com ([209.85.166.169]:41472 "EHLO
        mail-il1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfKFPzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 10:55:03 -0500
Received: by mail-il1-f169.google.com with SMTP id z10so22225122ilo.8
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 07:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xn66eqD8KUVeckkexvhb2mMJ9+zzmGylr6vAH56KVD4=;
        b=dqvcvbFFa56vSuVH8IfTgIDmw2rSCzaBIAofH/e+rZF/TDw1cweV/YjCbgP1yLPJGS
         xenHxVqC/DoonMUOaR6gJzz5LaXqMhm9opjkxZz9EQAD8+Kz7X2NPL9WXuTe6khMK20A
         zZi7gt1/Bf690ROS7Hz9cpi4oG7FQegaNAmgsf/KPWpHYtfSbLg3hJQ9VdwHBslPj1Ay
         WvPtOgGlh2gst7hrGuf33B6TWDFf+jPs6/fhu/+EJoWP9BkTf3lf7DY5e40AtyBHHgGO
         uqAtuFnr0HvQU2Ln7cHo4PZC+9lmgBZjcAvj+Lm7H2SApBF/2GTH1pJ6E5y8t+jHoZ0m
         pCOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xn66eqD8KUVeckkexvhb2mMJ9+zzmGylr6vAH56KVD4=;
        b=j1mYdi4beVyCs4LTHsB02T25r4e5k4PzzdZRY9GUhNtZ/YAghdcNhegI9sziESdjjb
         3esgO/+qr8M46ZFSWDzhL6DSyAJziol2KpKMTiTwCnVRS4abXHwXifrGwOx2HoLE6tdA
         gSjvZpSPw+2AmGBtalTSRb6eIK3z42Ra5UlRNbumkq+zjhpXM9T4yiNtm9C/CDoP0bJx
         dYbqukH2YDGjy/4xOmqrK/V9m9r7ElpQ7+snvEgMP7rm7DG3BbSMbboTt3lIm+B8UKRK
         aTe3c8+gXU7soMrDDIUtTkKYKWdni4GJM08ix8j3fpKeFHJRA9pVonvETrvlp66PLjRe
         Bl4w==
X-Gm-Message-State: APjAAAXRHziBPPHODntIBeEfW9vv+7iswRhjTbGlmwdjv3SI5gmAWE4Y
        ZWLmt2qucu1do+11VM/ojJLauupr
X-Google-Smtp-Source: APXvYqxf1+7Ehv0RE0q/gHnluuuwSimLZsVmBMCRaFdVsPQ18uYZgjvBn43zfEoa+nmhyiE9QQS+6w==
X-Received: by 2002:a92:5d88:: with SMTP id e8mr3309139ilg.95.1573055701929;
        Wed, 06 Nov 2019 07:55:01 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:ec38:6775:b8e6:ab09])
        by smtp.googlemail.com with ESMTPSA id f22sm2305357iol.17.2019.11.06.07.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2019 07:55:01 -0800 (PST)
Subject: Re: SIOCSIFDSTADDR for IPv6 removed ?
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <63900c63bcb04f226fba538fd31c609c8ff6e776.camel@infinera.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <038e090c-b9cb-a15d-6aea-4a5ccbc6e95c@gmail.com>
Date:   Wed, 6 Nov 2019 08:55:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <63900c63bcb04f226fba538fd31c609c8ff6e776.camel@infinera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/6/19 4:34 AM, Joakim Tjernlund wrote:
> From what I can tell, it is not possible to set DSTADDR in IPv6 and I wonder why?
> 
> There is an expectation for IPV6_SIT which can but am using pppoe and there I cannot.
> 

Code is still present and does not appear to have been changed recently.
