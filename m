Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71163A1A3A
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 14:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbfH2MjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 08:39:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45580 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfH2MjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 08:39:24 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 77FB48A1A6; Wed, 28 Aug 2019 15:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567005368;
        bh=+EwOCSrATTfaecERMGr7s8wbx3PWkrc30gIRhDZCi1A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VrjuRwfm8DZtQigZQgTgHkacGaLb3S1IyYgj8Deg5Oy3mitdGf4UFK2t7XyRuTIqD
         h4KWBeC1ksA7iJ6dcJsuLFOqa8wytoZh1aY8Wkkf20mBg6rS+epDCenYX27jaqep8s
         9VamivGkRTlawfhG3bCPC4JREr4/mTrEsfB/AOsM=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 82BCB782A7;
        Wed, 28 Aug 2019 07:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1566978287;
        bh=+EwOCSrATTfaecERMGr7s8wbx3PWkrc30gIRhDZCi1A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aeeVAq6YhSYhMWz5IV7u9cU/D4kOmDQxphEmV2RiAkhT1SkP42Py3FRu9qpZkEGNG
         RghbuZp6w/Row9bs6u7Hyyhn6yI4zf7ZGSoNTjQxL5kc8maOZhqdV7rU4MelYQ2Jy+
         UqWQva2uAXCEWYF+vfLcIxVcjRGLUR2anHdGlsC0=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 28 Aug 2019 10:44:46 +0300
From:   merez@codeaurora.org
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        wil6210@qti.qualcomm.com, "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] wil6210: Delete an unnecessary kfree() call in
 wil_tid_ampdu_rx_alloc()
In-Reply-To: <b9620e49-618d-b392-6456-17de5807df75@web.de>
References: <b9620e49-618d-b392-6456-17de5807df75@web.de>
Message-ID: <6eea96653c83cffe648465bc8b953913@codeaurora.org>
X-Sender: merez@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-08-27 17:44, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 27 Aug 2019 16:39:02 +0200
> 
> A null pointer would be passed to a call of the function “kfree”
> directly after a call of the function “kcalloc” failed at one place.
> Remove this superfluous function call.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---

Reviewed-by: Maya Erez <merez@codeaurora.org>

-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
