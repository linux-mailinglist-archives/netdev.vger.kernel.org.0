Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3688E2AEF2
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 08:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfE0Gvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 02:51:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48886 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfE0Gvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 02:51:55 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 967096087B; Mon, 27 May 2019 06:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558939914;
        bh=s0wLD8B/zseIR5f2YHD59ExN/luEudxhv79WY6CFMbg=;
        h=From:To:Subject:Date:From;
        b=CuNTeeKsA4INvRY3bhcdXQ+41Imm+8uQftmtIt03SRl+GAsx8adSZ7MsYKHJa0iKS
         6cmb4E+Gq7zzoB0MAPMf2UcvP7tdobg0jioYNNRvrVbnuKHHIMNJjhK4/KoA6t+uVM
         pHg8vJsQ3+XKL0GWwW9qy1ddX7dcAKVQ7kq335e0=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.206.25.51] (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: aneela@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5CB326019D;
        Mon, 27 May 2019 06:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558939914;
        bh=s0wLD8B/zseIR5f2YHD59ExN/luEudxhv79WY6CFMbg=;
        h=From:To:Subject:Date:From;
        b=CuNTeeKsA4INvRY3bhcdXQ+41Imm+8uQftmtIt03SRl+GAsx8adSZ7MsYKHJa0iKS
         6cmb4E+Gq7zzoB0MAPMf2UcvP7tdobg0jioYNNRvrVbnuKHHIMNJjhK4/KoA6t+uVM
         pHg8vJsQ3+XKL0GWwW9qy1ddX7dcAKVQ7kq335e0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5CB326019D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=aneela@codeaurora.org
From:   Arun Kumar Neelakantam <aneela@codeaurora.org>
To:     netdev@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Chris Lew <clew@codeaurora.org>
Subject: netdev_alloc_skb is failing for 16k length
Message-ID: <6891cd8b-a3be-91f5-39c4-7a7e7d498921@codeaurora.org>
Date:   Mon, 27 May 2019 12:21:51 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi team,

we are using "skb = netdev_alloc_skb(NULL, len);" which is getting 
failed sometimes for len = 16k.

I suspect mostly system memory got fragmented and hence atomic memory 
allocation for 16k is failing, can you please suggest best way to handle 
this failure case.

Thanks

Arun N

