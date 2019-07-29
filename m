Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCBE0789B0
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfG2KiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:38:08 -0400
Received: from mx-relay17-hz1.antispameurope.com ([94.100.132.217]:57916 "EHLO
        mx-relay17-hz1.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728151AbfG2KiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:38:08 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jul 2019 06:38:07 EDT
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay17-hz1.antispameurope.com;
 Mon, 29 Jul 2019 12:30:30 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Mon, 29 Jul
 2019 12:30:21 +0200
To:     <netdev@vger.kernel.org>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Subject: DSA Rate Limiting in 88E6390
Message-ID: <5a632696-946d-504b-1077-f7eb6d31ec19@eks-engel.de>
Date:   Mon, 29 Jul 2019 12:30:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay17-hz1.antispameurope.com with 49F23E404A4
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:2.358
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
is there a possibility to set the rate limiting for the 6390 with linux tools?
I've seen that the driver will init all to zero, so rate limiting is disabled, 
but there is no solution for it in the ip tool?

The only thing I found for rate limiting is the tc tool, but I guess this is 
only a software solution?

Furthermore, does exist a table or a tutorial which functions DSA supports?
The background is that we are using the DSDT driver (in future maybe the UMSD
driver) but we would like to switch to the in kernel DSA entirely. And our
software is using some of the DSDT functions, so I have to find an 
alternative to these functions.

Thanks in advance.

Best regards,
Benjamin

