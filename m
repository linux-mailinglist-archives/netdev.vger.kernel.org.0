Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CF01CF907
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730289AbgELPYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgELPYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:24:15 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEBAC061A0C;
        Tue, 12 May 2020 08:24:13 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id r66so18551469oie.5;
        Tue, 12 May 2020 08:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R4bBQNOyVmEDF5yOENpfq3TI5XtdI9DFH4GYyVIMd9g=;
        b=sz8qwUSeKjGwoqq32JHD6h8tg3zu/28HnMyoetmhxXOroV9T5tS7TvARTprBXLPKyy
         s9E2vH3rn2DeNVEJT8YPiNu70XCh+LD7HabhYjWc5BcP2sTXxzFlj2cZyWovCN5HRBIi
         VDR4i9Kz17t3hqfHwiuidSPUnHR2I3W8DaM1wQ/V0eXB/K10tsbtyEQVGZvIzGw93ziC
         QEC6qztYxfq7I2dki8/kfbzVZMkc8FXMISI/XvfT/unx8KjysP3P3kO1JvKL6gCE8mOV
         CWB8sHQF3L/VbeysZY1SOeqPSWrbrwVUqUl/DLB3MoI9MxewPUnBrMrmvwbWEgdQbGrB
         LBpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R4bBQNOyVmEDF5yOENpfq3TI5XtdI9DFH4GYyVIMd9g=;
        b=QZPNcyUQzA4gBfkhPgdQ5EL/fKx4nfQbnkUMt2Ad86yO7AE/7P5kh9VPGn4GjGIrdC
         HULn28t3pwuCcRbLVauApvQ97Y1z8lqYpxRdQf+X8wo84CGdAZQTDBp0muQqMcf/9o+F
         Q4r5giiL8Ut5clUe6uAh/HsApYRb0OQtYwfMZvmq4JIVRA5wEqUhA1pzOTckOR1qgJp2
         z+d+U0ML7s968X9dShAM675RTBs//Yq9qVwzp7tAB1oM2jEqQDW8JW87oC+Sec0D9gOm
         qIEQPk0diiE0mbxjHZU41EiuGJV2E2K4NN04rHljt3MstimRCBk/mT3oWxY/16kA0DZ6
         ycTQ==
X-Gm-Message-State: AGi0PuaLV+uMC78NoXkv7DPiPBRI725YJrDAAt8lihWBQCMQgpGoOkNH
        BGKjp4UV3OKMNOVrLI0nc55GS/c6
X-Google-Smtp-Source: APiQypIw806N9r5xWuOSJN3CM95Q9xSnXDIknnD+QUSQVprA0SJ5s6IxZ0Wx8e2ecMO88TTQ0zo9/Q==
X-Received: by 2002:aca:fc45:: with SMTP id a66mr24071661oii.5.1589297053062;
        Tue, 12 May 2020 08:24:13 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id k8sm3746481ood.24.2020.05.12.08.24.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 08:24:11 -0700 (PDT)
Subject: Re: [PATCH -next] net/wireless/rtl8225: Remove unused variable
 rtl8225z2_tx_power_ofdm
To:     ChenTao <chentao107@huawei.com>, herton@canonical.com,
        htl10@users.sourceforge.net, kvalo@codeaurora.org
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200512111408.157738-1-chentao107@huawei.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <377df527-267a-2405-5519-8ae956636248@lwfinger.net>
Date:   Tue, 12 May 2020 10:24:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200512111408.157738-1-chentao107@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/20 6:14 AM, ChenTao wrote:
> Fix the following warning:
> 
> drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c:609:17: warning:
> ‘rtl8225z2_tx_power_ofdm’ defined but not used
>   static const u8 rtl8225z2_tx_power_ofdm[] = {
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: ChenTao <chentao107@huawei.com>

The patch is OK, but the subject is wrong. It should be "[PATCH-next] rtl8187: 
Remove ...."

With that change, ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry
