Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E54E17AA21
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 17:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgCEQFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 11:05:46 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:34991 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgCEQFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 11:05:45 -0500
Received: by mail-pj1-f68.google.com with SMTP id s8so2717076pjq.0
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 08:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ww6wAKiVURPhmwKhj+Ta6VA6mxACgHsSc1wSJYYEuGs=;
        b=bDp1/kWgumnl7GvOoaiK6O/DZMpE7Ifr9fNK0OguHIbDIZ9Zgcnaam0UMtkh3B+k09
         ZpZ9s0NRhGrlRKhNKj3eJLxk8aBktRErqrkaz4WCP/xLQD1GDBg/HXlgSDryR1JwbSoh
         CeCkHQ5kJ0EBRTlezhHGM07cZ0eX6EaChWMYmCt0hutYC8sYZHmt8Ta41IFoZECihXkp
         tYft7KCEzWVruSZwKH1UfpH/St0cnPG3xfoByL5iqqjVGWCLFb0opQHK7lQOQbp8BncD
         AFerYC5uVaPZoJrX+pTOXFCEe5OqdTQ2djM2Bzv3sJf5VXLo8ndMM1b/Uz6DscQK1xIZ
         8MNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ww6wAKiVURPhmwKhj+Ta6VA6mxACgHsSc1wSJYYEuGs=;
        b=XR/Igo37VpkKFi8+8u5qtL++AcD5AUgq7ThbAOnZegwuuT3hF1Rl99rVzkZ6nK+fTf
         L+1YjvIl/GvVHoXvqOayywlRMSEXdobi9Q0eEQw7Ufyg74Rc/E/ATbIVQwyFprkLpuKa
         2r1J1maXfMovmdOvL+23fFwvStKcNid9JOUgjojAANCdHBTJe89IBrpatcgzJRx9K5ZX
         Bsmrwqm3T8I2V7zerCBMf93bYNalxxD4pqbrPNpNrlWhsXjXJc54T3TGClTaTxieyifn
         nvsIn1o9BIAVH3BUXPUG7h4r9HLXsPUWSwA1RHwj/f+Ep9fmg7S87IMimZ4gUE+DvfTs
         OzUA==
X-Gm-Message-State: ANhLgQ2gPSe9DYCs1yS0LF66096d1/3KqcwS2ajc2SjzWmeU3gvq9UAv
        nCWs0U84CysTTVR2/3I5lzFD9uYQksA=
X-Google-Smtp-Source: ADFU+vsQoZoWDJklBpQXguUCACZMpT6IpB/q9Ik2smzCmZaLMLf5giGWTe0W0dBS+8ap6DgzyIyWSg==
X-Received: by 2002:a17:902:b68c:: with SMTP id c12mr8605258pls.160.1583424344910;
        Thu, 05 Mar 2020 08:05:44 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id x6sm32139178pfi.83.2020.03.05.08.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 08:05:44 -0800 (PST)
Date:   Thu, 5 Mar 2020 08:05:35 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     bugzilla-daemon@bugzilla.kernel.org, netdev@vger.kernel.org
Subject: Re: [Bug 206761] New: escape codes in network interface names
 causes chaos
Message-ID: <20200305080535.59ff59b0@hermes.lan>
In-Reply-To: <bug-206761-100@https.bugzilla.kernel.org/>
References: <bug-206761-100@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 05 Mar 2020 10:42:39 +0000
bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=206761
> 
>             Bug ID: 206761
>            Summary: escape codes in network interface names causes chaos
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 5.6
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>           Assignee: stephen@networkplumber.org
>           Reporter: george.shuklin@gmail.com
>         Regression: No
> 
> netlink permits creation of interfaces with escape codes. Suck names can trick
> root by drawing at random places in terminal.
> 
> 
> Minimal proof of concept:
> 
> 
> echo -e '\x1B[2J'|xargs -I I ip link add I type dummy
> ip l
> 
> 
> (rollback): echo -e '\x1B[2J'|xargs -I I ip link del I
> 

My opinion is that this is not a problem that can be addressed without breaking kernel ABI.
