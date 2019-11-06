Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A70A4F1A3F
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 16:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732098AbfKFPmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 10:42:35 -0500
Received: from www.os-cillation.de ([87.106.250.87]:55906 "EHLO
        www.os-cillation.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbfKFPme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 10:42:34 -0500
Received: by www.os-cillation.de (Postfix, from userid 1030)
        id 2AC807FD; Wed,  6 Nov 2019 16:42:35 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        s17988253.onlinehome-server.info
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.5 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from core2019.osc.gmbh (p578a635d.dip0.t-ipconnect.de [87.138.99.93])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by www.os-cillation.de (Postfix) with ESMTPSA id 65084772;
        Wed,  6 Nov 2019 16:42:31 +0100 (CET)
Received: from [192.168.3.92] (hd2019.osc.gmbh [192.168.3.92])
        by core2019.osc.gmbh (Postfix) with ESMTPA id 447948E00E0;
        Wed,  6 Nov 2019 16:42:29 +0100 (CET)
Subject: Re: [Possible regression?] ip route deletion behavior change
To:     David Miller <davem@davemloft.net>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, David Ahern <dsa@cumulusnetworks.com>,
        Shrijeet Mukherjee <shm@cumulusnetworks.com>,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
References: <603d815f-f6db-3967-c0df-cbf084a1cbcd@os-cillation.de>
 <20191031.121651.2154293729808989384.davem@davemloft.net>
From:   Hendrik Donner <hd@os-cillation.de>
Openpgp: preference=signencrypt
Message-ID: <7973ab5b-6354-7a60-5cad-ecc708f566a3@os-cillation.de>
Date:   Wed, 6 Nov 2019 16:42:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191031.121651.2154293729808989384.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/19 8:16 PM, David Miller wrote:
> 
> Why haven't you CC:'d the author of the change you think caused the
> problem, nor the VRF maintainer?
> 
> Please do that and resend your report.
> 

My bad, i might have overly relied on the output of get_maintainer.pl for
the code in question. I will add the relevant people to the discussion.
