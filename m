Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9966542193B
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 23:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbhJDV05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 17:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235646AbhJDV04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 17:26:56 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E8BC061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 14:25:07 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id 134so21959492iou.12
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 14:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=PwJVhdoxxqIfPfaNCg004A0T8RFZ8MlwuKVPLNjOZPU=;
        b=njNuF7Q7cluDciTupv5L9CIlm/aGQNqD0jdkIkpT3n0lUagsP+ahfFAuMMUSgs7d5X
         M9TIuZl5k1tMdcfQFG7zVBhOGSFSfLLhiMhbGBT+ilL4TLD57gnGmaUGSKvxTbEO58AQ
         615AjUvMth3LUHKUbKzTZMrbLDCnWKpONEB/yiEErnOV8xg8KJypsizVszCNWKlL3Bfn
         Qd6M1ncgXqn7Uwoz+PsK086OmsNxxLDA5EmYSTtwlg81P3pt6DwR83QVFvIlSqenNrA6
         +9pWn6nE4J2BPRp8h0gSwfNTxFcdu1NhbTKbP7XqRnmDpM3SJDZdhi1MBBJnV2/gGR4V
         Bsrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=PwJVhdoxxqIfPfaNCg004A0T8RFZ8MlwuKVPLNjOZPU=;
        b=gNqzgwHyr3lwr8cnBVVj/x2KmXhT6D+BNJzMY+Mcf5QWLxMFCjmUCDq6hGs71ErLZZ
         nrAy/JTh069M44omiWYIriAmNlY0jbp5qtJUP3zimjf2CzSNkMFJLe7NBZYlZaOzlnt6
         nPFO9BdNDI338vYNj06VZsWZndkb1/M65mVxU8gU1V1Vp9PixiT5EJ2M/RVndg51TAPM
         1ZBOTvHIvnT7X67ZazfxL0JjjgQdP1aYMe4CnVfl4D+FmXHcPJd8nnPM1MvFIyMGpcpy
         zEfveh2w/2m11ZkzTc567sooW3VVzRURb3H/clC4RDIOpM1cwpH9ybeW/WPiB68ILIVh
         e2Dw==
X-Gm-Message-State: AOAM531iDkoH28FHmJzgWb5kS0qJO0SC/oAb0c6xj9K7zDF7CuhixgZW
        MyJrq7DHP7ibGe5AtStcVLwTWb8oaT8=
X-Google-Smtp-Source: ABdhPJxk0juqDq6eUKqM4hTQMl78YjuHNn+zCdj5MROirvOWYZcPQzG21BOrFvXGurRNGNV+J6acuQ==
X-Received: by 2002:a6b:f302:: with SMTP id m2mr10963745ioh.180.1633382706616;
        Mon, 04 Oct 2021 14:25:06 -0700 (PDT)
Received: from [192.168.6.19] (45-27-190-129.lightspeed.livnmi.sbcglobal.net. [45.27.190.129])
        by smtp.gmail.com with ESMTPSA id i13sm1230485ion.27.2021.10.04.14.25.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 14:25:06 -0700 (PDT)
To:     netdev@vger.kernel.org
From:   John Rama <john.rama01@gmail.com>
Subject: Q on how to test "gcm-aes-xpn-128"
Message-ID: <179b54f4-62e4-8d23-07f3-0dd6c8aa0ee4@gmail.com>
Date:   Mon, 4 Oct 2021 17:25:05 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi macsec specialist,

One question on macsec

I want to test macsec with "gcm-aes-xpn-128", but it seems that iproute2 
does not support it yet.
Is there any tool available to set SSCI and Salt from user space ?
In other words, how gcm-aes-xpn-128 is tested ?

Thanks.

John

