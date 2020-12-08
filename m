Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6542D26A4
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 09:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgLHIyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 03:54:38 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:57275 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbgLHIyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 03:54:38 -0500
Received: from [192.168.1.155] ([95.117.39.192]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1Mcp3E-1kCwmM2v6w-00ZvNN; Tue, 08 Dec 2020 09:51:08 +0100
Subject: Re: [PATCH 1/7] net: 8021q: remove unneeded MODULE_VERSION() usage
To:     Greg KH <greg@kroah.com>, Vladimir Oltean <olteanv@gmail.com>
Cc:     "Enrico Weigelt, metux IT consult" <info@metux.net>,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, marcel@holtmann.org, johan.hedberg@gmail.com,
        roopa@nvidia.com, nikolay@nvidia.com, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, jmaloy@redhat.com,
        ying.xue@windriver.com, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
References: <20201202124959.29209-1-info@metux.net>
 <20201205112018.zrddte4hu6kr5bxg@skbuf> <X8us4vsLCh/tXFLh@kroah.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <205b379c-d7fd-f78f-e72a-1344fad09c0f@metux.net>
Date:   Tue, 8 Dec 2020 09:51:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <X8us4vsLCh/tXFLh@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: tl
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:75He4GTwP2Pvr21utgxi6AvViAZ7g5MjhAO11u3+NPpSzLfFLc1
 05qvQ/DIJ15MDosO2cS6TKULJURaScDofuDcOX/+B3gM0L36yNx9z3A3Qb2AatOm0CS3zNd
 9NhWFabN63eqogzR2Omj5Ny/VL6I72XtMp2k5RZAfmbTKm6Z3ApiKhcN1+i/l7u4m/l2G+e
 AZO2kaBUH4MmtQv1RiCfw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:gDrGPN27EYA=:3RlVwi+Jn1Kc7zgvTGKFkt
 fT4zNzzqalCRi84tpWOeKt6fl/A7qaVbjhfEbgQrfLXEmRA948xdC42+C44p5Wk6ADZELEpBz
 LjMRDZGEhvuAWEY+W5TBshM9KPisBiw/uxRmavaZpX4eVerxAA7KVL734pmLnYNJF5QwOoHxn
 /aUVEjbUn0MvlcQ9ibl9caueSVpnu1789fVOd+Y8qKckwxpSO8krjmBZWKIGr4AUmyzouG3ww
 j4kSICRJb3f9XGmjTKOO+icXVFvqtq67E1qAkRmPA071mzZ2wt7nxseN5AsYlI/RDOUI3RQD9
 g+qYs44exDr9Kda/3AyCXIwd8v+XfxBkDZoBNYc7DvOP0rxNE5HZxSJANqqNu71g9itTl71/P
 767N1iog4QbsBbgAOOxW/VN1hBJgy9O28or7m9S3zrZm4kaQDBZMr2kMkOIDG
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.12.20 16:53, Greg KH wrote:
>> How do we feel about deleting this not really informative message
>> altogether in a future patch?
> 
> It too should be removed.  If drivers are working properly, they are
> quiet.

Just sent a separate patch for removing this message. I'll rebase my
patch queue when this patch went through.


--mtx

-- 
---
Hinweis: unverschlüsselte E-Mails können leicht abgehört und manipuliert
werden ! Für eine vertrauliche Kommunikation senden Sie bitte ihren
GPG/PGP-Schlüssel zu.
---
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
