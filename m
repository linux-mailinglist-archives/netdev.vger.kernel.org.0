Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7539390791
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 20:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfHPSNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 14:13:13 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:56664 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727490AbfHPSNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 14:13:12 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8C6E04C0062;
        Fri, 16 Aug 2019 18:13:11 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 16 Aug
 2019 11:13:07 -0700
Subject: Re: [RFC bpf-next 0/3] tools: bpftool: add subcommand to count map
 entries
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <oss-drivers@netronome.com>
References: <20190813130921.10704-1-quentin.monnet@netronome.com>
 <20190814015149.b4pmubo3s4ou5yek@ast-mbp>
 <ab11a9f2-0fbd-d35f-fee1-784554a2705a@netronome.com>
 <bdb4b47b-25fa-eb96-aa8d-dd4f4b012277@solarflare.com>
 <18f887ec-99fd-20ae-f5d6-a1f4117b2d77@netronome.com>
 <84aa97e3-5fde-e041-12c6-85863e27d2d9@solarflare.com>
 <031de7fd-caa7-9e66-861f-8e46e5bb8851@netronome.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <c62611b7-9322-4efe-6b44-cb4087617e29@solarflare.com>
Date:   Fri, 16 Aug 2019 19:13:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <031de7fd-caa7-9e66-861f-8e46e5bb8851@netronome.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24850.005
X-TM-AS-Result: No-1.736300-4.000000-10
X-TMASE-MatchedRID: 7ySqCuYCpfjmLzc6AOD8DfHkpkyUphL99+PHtghP8GLo5ylrWfS0yzKy
        dfFQiPH7pVO+oN4Yy+nwJd0y95699XufZC0Pz+WkBcaL/tyWL2PDu9Ig2VAzuXRBPvVzfVU/m+q
        3qIvun/12d8d8QAF3I+P3YB3VAfGPlwV2iaAfSWc5f9Xw/xqKXXJnzNw42kCx2bNx1HEv7HAqtq
        5d3cxkNcDmktstdnbHsCD6Gug0nSw6dFPM3ONtRe0449QWDDb4Oidh6Pj4BzCFcgJc+QNMwu8bJ
        ovJYm8FYupx0XjSQPLDOFVmKqGJ4bPn3tFon6UK
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.736300-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24850.005
X-MDID: 1565979192-y5jBoVQEMl90
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/08/2019 15:15, Quentin Monnet wrote:
> So if I understand correctly, we would use the bpf() syscall to trigger
> a run of such program on all map entries (for map implementing the new
> operation), and the context would include pointers to the key and the
> value for the entry being processed so we can count/sum/compute an
> average of the values or any other kind of processing?
Yep, that's pretty much exactly what I had in mind.

-Ed
