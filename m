Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 973341613B7
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 14:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgBQNmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 08:42:16 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:40490 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726779AbgBQNmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 08:42:15 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6FEC4300069;
        Mon, 17 Feb 2020 13:42:14 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 17 Feb
 2020 13:42:09 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 0/2] couple more ARFS tidy-ups
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <3d83a647-beb0-6de7-39f7-c960e3299dc7@solarflare.com>
Date:   Mon, 17 Feb 2020 13:42:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25236.003
X-TM-AS-Result: No-1.731800-8.000000-10
X-TMASE-MatchedRID: IggxIvKXn1WAVlxKYvddDGivjLE8DPtZZAGtCJE23YhuOTbkZwMFPMnf
        ymxuFRJbMbl1XSwG2T5TvVffeIwvQwUcfW/oedmqjQlVVwSbjydm8D3OAra5/pcFdomgH0lnOX/
        V8P8ail2cIZLVZAQa0Gsr5yNKIeaXUEhWy9W70AHCttcwYNipX9TGCNBptnYukeGHo8REecOL+r
        m2vhLV9prv3hYzpvIpR0B3b2Eyqy0xwqle67/WNUAzBbitj/RY7aFmrxFux0RN2fIyiQnUdEX8J
        4/ri1ec
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.731800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25236.003
X-MDID: 1581946935-l26Y9fRJNH5Z
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tie up some loose ends from the recent ARFS work.

Edward Cree (2):
  sfc: only schedule asynchronous filter work if needed
  sfc: move some ARFS code out of headers

 drivers/net/ethernet/sfc/efx.h          | 18 ------------------
 drivers/net/ethernet/sfc/efx_channels.c | 25 ++++++++++++++++++++++++-
 2 files changed, 24 insertions(+), 19 deletions(-)

