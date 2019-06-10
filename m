Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5D8A3B547
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 14:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390070AbfFJMyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 08:54:55 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:52986 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388373AbfFJMyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 08:54:55 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DC760580061;
        Mon, 10 Jun 2019 12:54:53 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 10 Jun
 2019 05:54:50 -0700
Subject: Re: [RFC v2 PATCH 0/5] seg6: Segment routing fixes
To:     Tom Herbert <tom@herbertland.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <dlebrun@google.com>
CC:     Tom Herbert <tom@quantonium.net>
References: <1559933708-13947-1-git-send-email-tom@quantonium.net>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <000fe40c-18d9-9fc0-b894-f7bcecdfcb47@solarflare.com>
Date:   Mon, 10 Jun 2019 13:54:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1559933708-13947-1-git-send-email-tom@quantonium.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24664.003
X-TM-AS-Result: No-5.461800-4.000000-10
X-TMASE-MatchedRID: O/y65JfDwwvmLzc6AOD8DfHkpkyUphL9APiR4btCEeYZwGrh4y4izBBF
        KFUMyPpqO4ATHzn+nOWURMo5LLQQ1HwQ5fqealuzkr0W/BDHWEU0AJe3B5qfBquPvo9L6iaIL3c
        bWSYN50zsSy0aia6koUkNkm+UyEfTiUBuiwwXS8ueAiCmPx4NwJwhktVkBBrQjBlWW/k2kQBQSF
        bL1bvQASAHAopEd76v7s8uF2fbQSO8XdZ8EsA/WdugCp426ZmtnFPnOqvLczYydK01ElireA==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.461800-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24664.003
X-MDID: 1560171294-FRuFNi4Ejza2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/06/2019 19:55, Tom Herbert wrote:
> This patch set includes fixes to bring the segment routing
> implementation into conformance with the latest version of the
> draft (draft-ietf-6man-segment-routing-header-19).
AIUI the concept of "conformance" doesn't really belong in the context
 of an Internet-Draft.  See e.g. RFC2026 §2.2, and the I-D preface
    'It is inappropriate to use Internet-Drafts as reference
     material or to cite them other than as "work in progress."'

-Ed
