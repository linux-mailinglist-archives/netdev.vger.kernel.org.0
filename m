Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D55C324802
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 01:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbhBYAq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 19:46:28 -0500
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:42382 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235900AbhBYAq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 19:46:27 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 11P0i5G0019657; Thu, 25 Feb 2021 09:44:05 +0900
X-Iguazu-Qid: 34tKPbYPQdqNqkLbSv
X-Iguazu-QSIG: v=2; s=0; t=1614213844; q=34tKPbYPQdqNqkLbSv; m=TU+Ws2vmJCuvZEf+Q1Gizk484DT4l6hyz5nTkb+Ssq8=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1511) id 11P0i39v001739
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Feb 2021 09:44:04 +0900
Received: from enc02.toshiba.co.jp (enc02.toshiba.co.jp [61.202.160.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx12-a.toshiba.co.jp (Postfix) with ESMTPS id B53D31000AE;
        Thu, 25 Feb 2021 09:44:03 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 11P0i3QW022839;
        Thu, 25 Feb 2021 09:44:03 +0900
From:   Punit Agrawal <punit1.agrawal@toshiba.co.jp>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        "Brandeburg\, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen\, Anthony L" <anthony.l.nguyen@intel.com>,
        "daichi1.fukui\@toshiba.co.jp" <daichi1.fukui@toshiba.co.jp>,
        "nobuhiro1.iwamatsu\@toshiba.co.jp" 
        <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Corinna Vinschen <vinschen@redhat.com>,
        "Brown\, Aaron.F" <aaron.f.brown@intel.com>,
        "Keller\, Jacob.E" <jacob.e.keller@intel.com>,
        "David.S.Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4.4.y, v4.9.y] igb: Remove incorrect "unexpected SYS WRAP" log message
References: <20210210013448.2116413-1-punit1.agrawal@toshiba.co.jp>
        <c5d7ccb5804b46eea2ef9fe29c66720f@intel.com>
        <87blcaw650.fsf@kokedama.swc.toshiba.co.jp>
        <20210224085126.45af7b68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Thu, 25 Feb 2021 09:44:02 +0900
In-Reply-To: <20210224085126.45af7b68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Wed, 24 Feb 2021 08:51:26 -0800")
X-TSB-HOP: ON
Message-ID: <87wnuxugbx.fsf@kokedama.swc.toshiba.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 24 Feb 2021 11:28:59 +0900 Punit Agrawal wrote:
>> > It makes sense to me for htis to apply to those stable trees as well.  
>> 
>> Thanks Jake.
>> 
>> Networking maintainers - It's been a couple of weeks this patch is on
>> the list. Is there anything else that needs to be done for it to be
>> picked up for stable?
>
> Network maintainers only handle stable selection at the time of
> submission (if that). So if you want to request a backport of a commit
> which is already in Linus's tree and wasn't selected you should follow
> the standard stable procedure and submit the request to stable@, CCing
> netdev.

Ah I missed that. Thanks for the pointer - I'll resend the request to
stable with netdev in CC.
