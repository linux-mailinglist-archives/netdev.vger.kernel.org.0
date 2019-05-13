Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7361BC9C
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 20:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbfEMSHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 14:07:17 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:60614 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726948AbfEMSHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 14:07:17 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id CAFD2340081;
        Mon, 13 May 2019 18:07:15 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 13 May
 2019 11:07:12 -0700
Subject: Re: [PATCH net v2] rtnetlink: always put ILFA_LINK for links with a
 link-netnsid
To:     Sabrina Dubroca <sd@queasysnail.net>, <netdev@vger.kernel.org>
CC:     Dan Winship <danw@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
References: <d5c4710117d390e0f204b7046483727daf452233.1557755096.git.sd@queasysnail.net>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <7fdaebf3-effb-c011-3ba1-9bc0362a6ac1@solarflare.com>
Date:   Mon, 13 May 2019 19:07:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <d5c4710117d390e0f204b7046483727daf452233.1557755096.git.sd@queasysnail.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24610.005
X-TM-AS-Result: No-0.797400-4.000000-10
X-TMASE-MatchedRID: sDm3xtR6Ud+2tlYdo0NnhJdc7I2df+msfS0Ip2eEHny+qryzYw2E8CKv
        eQ4wmYdM4O7Keec/AUNMtbUiZq6OLj9BWL7GG0LsKrauXd3MZDX371moSn0VOE8H9D44BeITpAX
        V9YxoSfro5TbKHqCg1YC3X+tA07BzK88bwYdp5bMGxECHxaZMBwbZYBYdvap6SswcLuSaZJYnLg
        OZZEScAO90JQgW5qyr
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-0.797400-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24610.005
X-MDID: 1557770836-JnsbzmOBQC-d
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IFLA_LINK is typoed in subject line, you might want to fix that if respinning.

-Ed
