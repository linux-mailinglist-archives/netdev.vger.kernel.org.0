Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C031C3B6B7
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 16:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390681AbfFJOHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 10:07:20 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:57476 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390679AbfFJOHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 10:07:20 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 63415B40068;
        Mon, 10 Jun 2019 14:07:18 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 10 Jun
 2019 07:07:14 -0700
Subject: Re: [RFC v2 PATCH 0/5] seg6: Segment routing fixes
To:     Tom Herbert <tom@quantonium.net>
CC:     Tom Herbert <tom@herbertland.com>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <dlebrun@google.com>
References: <1559933708-13947-1-git-send-email-tom@quantonium.net>
 <000fe40c-18d9-9fc0-b894-f7bcecdfcb47@solarflare.com>
 <CAPDqMerN8k_79_oG2M=fGpSUPLUuwWGKYG25hJDZGotcyKsycg@mail.gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <37b3454d-50cc-b436-c0ca-de92adc78f5d@solarflare.com>
Date:   Mon, 10 Jun 2019 15:07:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAPDqMerN8k_79_oG2M=fGpSUPLUuwWGKYG25hJDZGotcyKsycg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24664.003
X-TM-AS-Result: No-5.092900-4.000000-10
X-TMASE-MatchedRID: 9zTThWtzImvmLzc6AOD8DfHkpkyUphL9SeIjeghh/zPI13IEGi/Kk0Yj
        NK+Q6GZAefvOlC0ENOKVPrpaSemR9ZAKfxlzhVDoiJwEp8weVXylAfiiC1VA/QpCjqVELlwV166
        Xb3/Hw4OxGfWj/2r2eZLzIxsc5+z/eJO388q+Do60pXj1GkAfe3dIxEZu/8QSmyiLZetSf8nJ4y
        0wP1A6AJj9/HNwzYskxx7l0wJgoV3dB/CxWTRRu25FeHtsUoHu0pyreA3BeZ8mdOMAyuG3Shl1d
        fG/0GPYolSKTWoIyIo2RRIMOrvjaQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.092900-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24664.003
X-MDID: 1560175639-lLWx-ACBWVX9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/06/2019 15:03, Tom Herbert wrote:
> On Mon, Jun 10, 2019, 5:54 AM Edward Cree <ecree@solarflare.com <mailto:ecree@solarflare.com>> wrote:
>
>     On 07/06/2019 19:55, Tom Herbert wrote:
>     > This patch set includes fixes to bring the segment routing
>     > implementation into conformance with the latest version of the
>     > draft (draft-ietf-6man-segment-routing-header-19).
>     AIUI the concept of "conformance" doesn't really belong in the context
>
>
> They can't be referred to as standards, but if conform is too strong a term, maybe we can say implements draft xyz.
That seems reasonable, yes.
