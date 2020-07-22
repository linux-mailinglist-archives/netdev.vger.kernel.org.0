Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FE722A32F
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 01:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730153AbgGVXmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 19:42:31 -0400
Received: from linux.microsoft.com ([13.77.154.182]:48522 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbgGVXmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 19:42:31 -0400
Received: by linux.microsoft.com (Postfix, from userid 1070)
        id 3850520B4908; Wed, 22 Jul 2020 16:42:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3850520B4908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1595461350;
        bh=8nFQ2Lcsut3ehCNONJCifbSUqk3XtP90FAvfPGV5V8M=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=sUkVovD5JtN3wMWJ9+zyQkFggOHc3SD7UuQcLlEiOuw6g827SaoLx597VeqeeDNZQ
         ZBjooW8odcJ89N/QoqTmJAoLcFN4j5lw8HNR8xtTeCH+cBQc6vQRzYUXsB3JL3QV8Y
         lmRY29tSV4LDlRjcFc/ltBQA+E/F7ArRkbMhR71c=
Received: from localhost (localhost [127.0.0.1])
        by linux.microsoft.com (Postfix) with ESMTP id 33D97307032D;
        Wed, 22 Jul 2020 16:42:30 -0700 (PDT)
Date:   Wed, 22 Jul 2020 16:42:30 -0700 (PDT)
From:   Chi Song <chisong@linux.microsoft.com>
X-X-Sender: chisong@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
To:     Florian Fainelli <f.fainelli@gmail.com>
cc:     Jakub Kicinski <kuba@kernel.org>,
        Chi Song <Song.Chi@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Miller <davem@davemloft.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 net-next] net: hyperv: Add attributes to show TX
 indirection table
In-Reply-To: <78ca93f5-bb3f-96f9-17c5-3c1855b11a40@gmail.com>
Message-ID: <alpine.LRH.2.23.451.2007221641040.99377@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
References: <PS1P15301MB028211A9D09DA5601EBEBEA298780@PS1P15301MB0282.APCP153.PROD.OUTLOOK.COM> <20200721122127.3ce422f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <78ca93f5-bb3f-96f9-17c5-3c1855b11a40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Tue, 21 Jul 2020, Florian Fainelli wrote:

> On 7/21/20 12:21 PM, Jakub Kicinski wrote:
> > On Tue, 21 Jul 2020 04:58:59 +0000 Chi Song wrote:
> >> An imbalanced TX indirection table causes netvsc to have low
> >> performance. This table is created and managed during runtime. To help
> >> better diagnose performance issues caused by imbalanced tables, add
> >> device attributes to show the content of TX indirection tables.
> >>
> >> Signed-off-by: Chi Song <chisong@microsoft.com>
> >
> > Sorry for waiting until v6 but sysfs feel like a very strange place to
> > expose this. Especially under the netdev, not the bus device.
> >
> > This looks like device specific state, perhaps ethtool -d is a more
> > appropriate place?
>
> Agreed, or a devlink resource maybe?

Thank you for comments, I will move it to ethtool.
