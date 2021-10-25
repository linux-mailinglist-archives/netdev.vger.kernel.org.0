Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4412439E2C
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 20:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhJYSKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 14:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbhJYSKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 14:10:43 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC1AC061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 11:08:21 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id q8so7764873qvl.9
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 11:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metztli-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=723Xr55q/68X2ExvwXw8IoW4BYez2a4ZswDyF1RWfVc=;
        b=tp1nVPmXlM7LhIyoZMXYOBCzGWlp2bTB4bl/pmtLhYoeMuMPde4Y+jWwNxVhkQrGJi
         ZgLrageuDgDcPaeT8P3m64dQ0S52Qc0PaFcgbT/XTcyUrQTG8d3i9DciU2WMS7Qh1EwU
         fONRGIBVmJG+HpVTBVn8ghQwTIUVbOnCrNuGJO3HJ9+7c169teR/ZWuT0ZPMRtGiGe6K
         RPFERBH6k8EdbgaKQ22aEg+qNGxATHHzQj23hn1uahgnFA1c1g3BcIXHDAUdeHG0m0R6
         8c2q2c8T7NAVEhesqheFUqPxkf6yu+CzaGl2eHMHrfVS9f4k7zamRkX77czkw5BMAGjo
         /qOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=723Xr55q/68X2ExvwXw8IoW4BYez2a4ZswDyF1RWfVc=;
        b=SouHwyAcfsIQXPAorSB4AU0V8bKFeYStdqZaSZU1zmF1x5C+OFbcUdN6eB3evDCFKh
         t9zOcRfeDsPgMpQakVgkl4JwvQvJaoPFLozmaU7b8zwyjhJWnxLGNQ9D0pigJ8Pi4LhJ
         T/FP3KNfJhOw2uIJ68UraG8itu65PhetHHhjeYMEiCDbRS2Gjf/FcFE2pY1p9foNXcVf
         ucqt0eD1WJ5zq9MHcw0iJfm2BfbG5EDirwrouCqVExcvawyUyihqlzmEFVLhFLdejYMX
         c+GdT1baz8N4uNdcGUUMz1EW+db6lFuybJNC/iXLLy2M/H0ez8J5b7SefnfUuAl9rkFe
         614g==
X-Gm-Message-State: AOAM532258YODuKvZSCOXKgDJ+kLtGHDr346eVLNKY/xJsGGKpDcpdVv
        zQ4eBL4gpv+MhW3ZSPdDs2MuTmJtl8nKiiewg5k=
X-Google-Smtp-Source: ABdhPJxkcb9HnLsfJa/4T621dr8t3FlYiTSyavcPJ+N/CsdAw93qnKJukwhU2yD9djc4WyxNFH6TWg==
X-Received: by 2002:ad4:5965:: with SMTP id eq5mr17118845qvb.45.1635185300223;
        Mon, 25 Oct 2021 11:08:20 -0700 (PDT)
Received: from ?IPv6:2600:1700:6470:27a0:4e80:93ff:fe00:3ff7? ([2600:1700:6470:27a0:4e80:93ff:fe00:3ff7])
        by smtp.gmail.com with ESMTPSA id g10sm2241191qko.38.2021.10.25.11.08.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 11:08:19 -0700 (PDT)
Subject: Re: Unsubscription Incident
To:     Slade Watkins <slade@sladewatkins.com>,
        Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Lijun Pan <lijunp213@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alan Coopersmith <alan.coopersmith@oracle.com>
References: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
 <CA+h21hqrX32qBmmdcNiNkp6_QvzsX61msyJ5_g+-FFJazxLgDw@mail.gmail.com>
 <YXY15jCBCAgB88uT@d3>
 <CA+pv=HPyCEXvLbqpAgWutmxTmZ8TzHyxf3U3UK_KQ=ePXSigBQ@mail.gmail.com>
From:   Metztli Information Technology <jose.r.r@metztli.com>
Message-ID: <c00f22d2-6566-8911-b56b-142f6fe42b8c@metztli.com>
Date:   Mon, 25 Oct 2021 11:08:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CA+pv=HPyCEXvLbqpAgWutmxTmZ8TzHyxf3U3UK_KQ=ePXSigBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/25/21 10:04 AM, Slade Watkins wrote:
> On Mon, Oct 25, 2021 at 12:43 AM Benjamin Poirier
> <benjamin.poirier@gmail.com> wrote:
>> On 2021-10-22 18:54 +0300, Vladimir Oltean wrote:
>>> On Fri, 22 Oct 2021 at 18:53, Lijun Pan <lijunp213@gmail.com> wrote:
>>>> Hi,
>>>>
>>>>  From Oct 11, I did not receive any emails from both linux-kernel and
>>>> netdev mailing list. Did anyone encounter the same issue? I subscribed
>>>> again and I can receive incoming emails now. However, I figured out
>>>> that anyone can unsubscribe your email without authentication. Maybe
>>>> it is just a one-time issue that someone accidentally unsubscribed my
>>>> email. But I would recommend that our admin can add one more
>>>> authentication step before unsubscription to make the process more
>>>> secure.
>>>>
>>>> Thanks,
>>>> Lijun
>>> Yes, the exact same thing happened to me. I got unsubscribed from all
>>> vger mailing lists.
>> It happened to a bunch of people on gmail:
>> https://lore.kernel.org/netdev/1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com/t/#u
> I can at least confirm that this didn't happen to me on my hosted
> Gmail through Google Workspace. Could be wrong, but it seems isolated
> to normal @gmail.com accounts.
>
> Best,
>               -slade

Niltze [Hello], all-

Could it have something to do with the following?

---------- Forwarded message ---------

From: Alan Coopersmith <alan.coopersmith@oracle.com>
Date: Thu, Oct 21, 2021 at 12:06 PM
Subject: [oss-security] Mailman 2.1.35 security release
To: <oss-security@lists.openwall.com>


Quoting from Mark Sapiro's emails at:
https://mail.python.org/archives/list/mailman-announce@python.org/thread/IKCO6JU755AP5G5TKMBJL6IEZQTTNPDQ/

 > A couple of vulnerabilities have recently been reported. Thanks to Andre
 > Protas, Richard Cloke and Andy Nuttall of Apple for reporting these and
 > helping with the development of a fix.
 >
 > CVE-2021-42096 could allow a list member to discover the list admin
 > password.
 >
 > CVE-2021-42097 could allow a list member to create a successful CSRF
 > attack against another list member enabling takeover of the members 
account.
 >
 > These attacks can't be carried out by non-members so may not be of
 > concern for sites with only trusted list members.


 > I am pleased to announce the release of Mailman 2.1.35.
 >
 > This is a security and minor bug fix release. See the attached
 > README.txt for details. For those who just want a patch for the security
 > issues, see
 > https://bazaar.launchpad.net/~mailman-coders/mailman/2.1/revision/1873.
 > The patch is also attached to the bug reports at
 > https://bugs.launchpad.net/mailman/+bug/1947639 and
 > https://bugs.launchpad.net/mailman/+bug/1947640. The patch is the same
 > on both and fixes both issues.
 >
 > As noted Mailman 2.1.30 was the last feature release of the Mailman 2.1
 > branch from the GNU Mailman project. There has been some discussion as
 > to what this means. It means there will be no more releases from the GNU
 > Mailman project containing any new features. There may be future patch
 > releases to address the following:
 >
 > i18n updates.
 > security issues.
 > bugs affecting operation for which no satisfactory workaround exists.
 >
 > Mailman 2.1.35 is the fifth such patch release.
 >
 > Mailman is free software for managing email mailing lists and
 > e-newsletters. Mailman is used for all the python.org and
 > SourceForge.net mailing lists, as well as at hundreds of other sites.
 >
 > For more information, please see our web site at one of:
 >
 > http://www.list.org
 > https://www.gnu.org/software/mailman
 > http://mailman.sourceforge.net/
 >
 > Mailman 2.1.35 can be downloaded from
 >
 > https://launchpad.net/mailman/2.1/
 > https://ftp.gnu.org/gnu/mailman/
 > https://sourceforge.net/projects/mailman/

 > --
 >        -Alan Coopersmith- alan.coopersmith@oracle.com
 >         Oracle Solaris Engineering - https://blogs.oracle.com/alanc


Best Professional Regards.

-- 
Jose R R
http://metztli.it
---------------------------------------------------------------------------------------------
Download Metztli Reiser4: Debian Bullseye w/ Linux 5.13.14 AMD64
---------------------------------------------------------------------------------------------
feats ZSTD compression https://sf.net/projects/metztli-reiser4/
---------------------------------------------------------------------------------------------
or SFRN 5.1.3, Metztli Reiser5 https://sf.net/projects/debian-reiser4/
-------------------------------------------------------------------------------------------
Official current Reiser4 resources: https://reiser4.wiki.kernel.org/
