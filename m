Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53FF5DF472
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 19:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729734AbfJURkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 13:40:43 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58318 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfJURkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 13:40:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AE7DB60779; Mon, 21 Oct 2019 17:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571679642;
        bh=jBKnhG83d3RpN9ZxT9S+XWnmMWOAmj+xdkB7Xox0YgE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LzjZDz3EuZjUTWUOv9pL76BKqgTbuqjWM4RFTFUTv7qEG5ZTD42umJum3evB1dyD0
         QGrGdaluKlwkdNCBeVaa0kna2laF0sRm934ZDyspRYYRvp6zknwmN1VpcjuBjUEDmR
         Ho1jJ6YYvqCIqtGEPwmNi8EOOGNROsgffGuUMz48=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 2CD4A60112;
        Mon, 21 Oct 2019 17:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571679642;
        bh=jBKnhG83d3RpN9ZxT9S+XWnmMWOAmj+xdkB7Xox0YgE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LzjZDz3EuZjUTWUOv9pL76BKqgTbuqjWM4RFTFUTv7qEG5ZTD42umJum3evB1dyD0
         QGrGdaluKlwkdNCBeVaa0kna2laF0sRm934ZDyspRYYRvp6zknwmN1VpcjuBjUEDmR
         Ho1jJ6YYvqCIqtGEPwmNi8EOOGNROsgffGuUMz48=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 21 Oct 2019 11:40:42 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, ycheng@google.com, ncardwell@google.com
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
In-Reply-To: <d09e2d5d-ccad-5add-59c5-a0d2058644e3@gmail.com>
References: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
 <d09e2d5d-ccad-5add-59c5-a0d2058644e3@gmail.com>
Message-ID: <8cbba50ce2e3ea12cd78277b3dc2d162@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Please give us a pointer to the exact git tree and sha1.
> 
> I do not analyze TCP stack problems without an exact starting point,
> or at least a crystal ball, which I do not have.

Hi Eric

We are at this commit - Merge 4.19.75 into android-4.19-q.

https://android.googlesource.com/kernel/common/+/cfe571e421ab873403a8f75413e04ecf5bf7e393

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
