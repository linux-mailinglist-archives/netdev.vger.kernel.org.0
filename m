Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D71A610FB6E
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 11:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfLCKLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 05:11:07 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41735 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLCKLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 05:11:07 -0500
Received: by mail-ed1-f66.google.com with SMTP id c26so2608847eds.8
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 02:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xqb9+Qi7JEzQs9BDmcRuAQ9tcm+g+UC6+1Q6gwB66yw=;
        b=IoFdabC2MmvsRhK0+vKjxjAymTLVduFvkRcYv4bBBW7ZgQc4O2NTHX/+Lx6PnX56Ps
         DBMdJhbKNi0zk4FcQIDgl5/rtui4PeuwZk1xq2YSDUt2qi388X4f9C5wjnPN85x8L3DS
         /DXBmn2y282LkXk6bFNBZx3cw/miW1h1cEPr3NZ+5UZmbFv+C4/HmWwZr90ez5zXvo77
         FAm9zvTIBt6lt4cO4moWARC+AcWaSjaxlMvpJLNYA/PqTRzbd/4w8YVlh+HkovsZ6//0
         u1kfLMUP6BRh6iGOLHrTqfel1HluvtLlCbB2VgPzWnSPpnUxx9R1569I5+qPRlpG4/kM
         cDPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xqb9+Qi7JEzQs9BDmcRuAQ9tcm+g+UC6+1Q6gwB66yw=;
        b=nqQqbrUyryXLEqJQLjCcHPIuFymfJ20HuaYatELdhcA/lg1OR2hQF56+dFp6OrO8Z6
         draKZUmLUJdgjIlI3+ybJcvqLKAP05NM+aD5B7j1Fv414U2se5in2KPC0wgn4Cu2aTsy
         O+UaV9new3ecTNT37RdLSGMLLeg3LNQQbaNKnuAC17s+CpAZLLcmhInCy7Efy7zrbHTJ
         VkcrygQHQHqYcCefeJ6h6o56sDrZVMbm3sHcSM7mbvLo3Q79VR3+3LIntOR6+jG/XrnI
         j9ZWjyhvzqY9vzPEKvfaiokxb5Fp1sBwmqzlJ/gADqiUkE3RtUYR8+/8WhedYQSQ1KsX
         OlNg==
X-Gm-Message-State: APjAAAUqGnHyb0AYPzCXwzIFLtNlY6jC8wT9UU8c7sT/ukK8iKRnsc05
        WlykxPUUNNrzU38V5qHjWo+5XGYXRZIjW9yL6ME=
X-Google-Smtp-Source: APXvYqyrQMROls3E255LqBsq3sbRh5DFbFZ8OZZcsEXP76odHqk61pLwU4AGti8oXrJmqhts3Tl5hzeKRbAM50XWzMM=
X-Received: by 2002:a17:907:11cc:: with SMTP id va12mr5075081ejb.164.1575367865323;
 Tue, 03 Dec 2019 02:11:05 -0800 (PST)
MIME-Version: 1.0
References: <BN8PR12MB3266E99E5C289CB6B77A5C58D3420@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB3266E99E5C289CB6B77A5C58D3420@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 3 Dec 2019 12:10:54 +0200
Message-ID: <CA+h21hpTLOtjobFjGt5dzJ+nZvLjAMfCO+_-3OCCAaSE1yMSfQ@mail.gmail.com>
Subject: Re: tperf: An initial TSN Performance Utility
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose,

On Tue, 3 Dec 2019 at 12:00, Jose Abreu <Jose.Abreu@synopsys.com> wrote:
>
> Hi netdev,
>
> [ I added in cc the people I know that work with TSN stuff, please add
> anyone interested ]
>
> We are currently using a very basic tool for monitoring the CBS
> performance of Synopsys-based NICs which we called tperf. This was based
> on a patchset submitted by Jesus back in 2017 so credits to him and
> blames on me :)
>
> The current version tries to send "dummy" AVTP packets, and measures the
> bandwidth of both receiver and sender. By using this tool in conjunction
> with iperf3 we can check if CBS reserved queues are behaving correctly
> by reserving the priority traffic for AVTP packets.
>
> You can checkout the tool in the following address:
>         GitHub: https://github.com/joabreu/tperf
>
> We are open to improve this to more robust scenarios, so that we can
> have a common tool for TSN testing that's at the same time light
> weighted and precise.
>
> Anyone interested in helping ?
>
> ---
> Thanks,
> Jose Miguel Abreu

Sounds nice, I'm interested in giving this a try on the LS1028A ENETC.

Do you have any more tooling around tperf? Does the talker advertise
the stream in such a way that a switch could reserve bandwidth too?

Do you plan to add this to the kernel tree (e.g.
tools/testing/selftests/tsn or such) or how do you want to maintain
this long-term?

I've added more people from NXP who may also be interested.

Thanks,
-Vladimir
